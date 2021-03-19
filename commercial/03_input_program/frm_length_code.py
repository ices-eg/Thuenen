# -*- coding: utf-8 -*-
"""
Created on Thu Dec 10 11:07:54 2020

@author: hardadi
"""

from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *

import frm_length
import csv

from reference import Reference as ref


class WeightTableModel(QAbstractTableModel):

    def __init__(self):
        super(WeightTableModel, self).__init__()
        
        self.haul_uid = ref.haul_uid
        self.weight_uid = None
        
        cur = ref.connection.cursor()
        
        sql_statement = """SELECT * FROM com_new_final.sample_weight WHERE
        ha_index = {}""".format(self.haul_uid)
        cur.execute(sql_statement)
        weight_data = cur.fetchall()
        
        self.header = ['Fischart', 'Category', 'Gesamtgewicht', 'Gesamtanzahl',
                       'UP Gewicht', 'UP Anzahl', 'Gewicht Unit', 'Length Unit']
        
        column = [2] + list(range(5,10)) + [11,12]
        
        if weight_data != []:
            print(weight_data)
            ref.weight_uid = weight_data[0][0]
            
            self.__data = [dict((self.header[i], r[column[i]]) for i in
                    range(len(column))) for r in weight_data]
            
            we_id = 0
            
            for s in self.__data:
                s["Weight_id"] = weight_data[we_id][0]
                we_id += 1
                s["dirty"] = False
        
        else:
            self.__data.append({"dirty": True})
        
        cur.close()

    def rowCount(self, index=QModelIndex()):
        return len(self.__data)

    def columnCount(self, index=QModelIndex()):
        return len(self.header)

    def headerData(self, section, orientation, role=Qt.DisplayRole):
        if role != Qt.DisplayRole:
            return None
        if orientation == Qt.Horizontal:
            return self.header[section]
        return int(section+1)
    
    def flags(self, index):
        return Qt.ItemFlags(QAbstractTableModel.flags(self, index)|Qt.ItemIsEditable)

    def data(self, index, role = Qt.DisplayRole):
        if not index.isValid() or not (0 <= index.row()< len(self.__data)) or index.column() >= len(self.header):
            return None

        data_row = self.__data[index.row()]
        k = self.header[index.column()]

        if role == Qt.DisplayRole or role == Qt.EditRole:
            if k in data_row.keys():
                return data_row[k]
            else:
                return None

        return None
    
    def weightID(self, index):
        if not index.isValid() or not (0 <= index.row()< len(self.__data)) or index.column() >= len(self.header):
            return None

        data_row = self.__data[index.row()]
        
        return data_row['Weight_id']
    
    def insertRows(self, row, count, parent=QModelIndex(), data=[{}]):
        self.beginInsertRows(parent, row, row+count-1)
        for i, d in enumerate(data):
            d2 = d.copy()
            d2["dirty"] = True
            self.__data.insert(row+i, d2)
        self.endInsertRows()
        return True
    
    def insertWeight(self, cat, wg_all, num_all, wg_sample, num_sample,
                     wg_unit, len_unit):
        
        if cat == 'D':
            self.__data[-2]['Category'] = 'L'
            self.__data[-2]['Gesamtgewicht'] = wg_all
            self.__data[-2]['Gesamtanzahl'] = num_all
            self.__data[-2]['UP Gewicht'] = wg_sample
            self.__data[-2]['UP Anzahl'] = num_sample
            self.__data[-2]['Gewicht Unit'] = wg_unit
            self.__data[-2]['Length Unit'] = len_unit
        else:
            self.__data[-3]['Category'] = 'D'
            self.__data[-3]['Gesamtgewicht'] = wg_all
            self.__data[-3]['Gesamtanzahl'] = num_all
            self.__data[-3]['UP Gewicht'] = wg_sample
            self.__data[-3]['UP Anzahl'] = num_sample
            self.__data[-3]['Gewicht Unit'] = wg_unit
            self.__data[-3]['Length Unit'] = len_unit
        
    def save_data(self, wg_all, num_all, wg_sample, num_sample, wg_unit, len_unit):
        
        cur = ref.connection.cursor()
        index_statement = """SELECT MAX(we_index) FROM com_new_final.sample_weight;"""
        cur.execute(index_statement)
        new_id = cur.fetchone()[0] + 1
        
        self.__data[-1]['Gesamtgewicht'] = wg_all
        self.__data[-1]['Gesamtanzahl'] = num_all
        self.__data[-1]['UP Gewicht'] = wg_sample
        self.__data[-1]['UP Anzahl'] = num_sample
        self.__data[-1]['Gewicht Unit'] = wg_unit
        self.__data[-1]['Length Unit'] = len_unit
        
        for rec in self.__data:
            if rec != {'dirty': True}:
                if rec["dirty"] is True:
                    insert_statement = """INSERT INTO com_new_final.sample_weight 
                    (we_index, ha_index, species, aphiaid, latin_name,
                     catch_category, total_weight, total_numbers, subsample_weight,
                     subsample_numbers, number_measured, weight_unit, length_unit) VALUES
                    ({}, {}, '{}', {}, '{}', '{}', {}, {}, {}, {}, {},
                     '{}', '{}');""".format(new_id, ref.haul_uid, rec['Fischart'], 0,
                    "test", rec['Category'], rec['Gesamtgewicht'], rec['Gesamtanzahl'],
                    rec['UP Gewicht'], rec['UP Anzahl'], rec['UP Anzahl'],
                    rec['Gewicht Unit'], rec['Length Unit'])
    
                    cur = ref.connection.cursor()
                    cur.execute(insert_statement)
                    print(insert_statement)
                    new_id += 1
                    ref.connection.commit()
                    cur.close()
                
                else:
                    update_statement = """UPDATE com_new_final.sample_weight SET
                    total_weight = {}, total_numbers = {}, subsample_weight = {},
                    subsample_numbers = {}, number_measured = {} WHERE ha_index = {}
                    AND species = '{}' AND catch_category = '{}';""".format(rec['Gesamtgewicht'],
                    rec['Gesamtanzahl'], rec['UP Gewicht'], rec['UP Anzahl'], 
                    rec['UP Anzahl'], ref.haul_uid, rec['Fischart'], rec['Category'])
                    
                    cur = ref.connection.cursor()
                    cur.execute(update_statement)
                    print(update_statement)
                    ref.connection.commit()
                    cur.close()
        

class LengthTableModel(QAbstractTableModel):

    def __init__(self, position):
        super(LengthTableModel, self).__init__()
        
        self.weight_uid = ref.weight_uid + position
        self.length_uid = None
        
        self.header = ['Length Class', 'Length Number']
        
        cur = ref.connection.cursor()
        
        sql_statement = """SELECT * FROM com_new_final.sample_length WHERE
        we_index = {}""".format(self.weight_uid)
        cur.execute(sql_statement)
        length_data = cur.fetchall()
        
        if length_data != None:
            self.__data = [dict((self.header[i], r[i+2]) for i in
                    range(len(self.header))) for r in length_data]
            
            for i in range(len(self.__data)):
                self.__data[i]["Length_id"] = length_data[i][0]
                self.__data[i]['dirty'] = False
            
            self.length_uid = self.__data[0]["Length_id"]
            ref.length_uid = self.length_uid
            print(ref.length_uid, 'initial')
            
        else:
            self.__data = [{'dirty': True}]
        
        cur.close()

    def rowCount(self, index=QModelIndex()):
        return len(self.__data)

    def columnCount(self, index=QModelIndex()):
        return len(self.header)

    def headerData(self, section, orientation, role=Qt.DisplayRole):
        if role != Qt.DisplayRole:
            return None
        if orientation == Qt.Horizontal:
            return self.header[section]
        return int(section+1)

    def data(self, index, role = Qt.DisplayRole):
        if not index.isValid() or not (0 <= index.row() < len(self.__data)) or index.column() >= len(self.header):
            return None

        data_row = self.__data[index.row()]
        k = self.header[index.column()]

        if role == Qt.DisplayRole or role == Qt.EditRole:
            if k in data_row.keys():
                return data_row[k]
            else:
                return None

        return None    
    
    def flags(self, index):
        return Qt.ItemFlags(QAbstractTableModel.flags(self, index)|Qt.ItemIsEditable)

    def setData(self, index, value, role=Qt.EditRole):
        if not index.isValid():
            return False
        row = index.row()
        if index.column() > 0:
            self.__data[row][index.column()] = value
            self.__data[row][-1] = True
            self.dataChanged.emit(index, index)
            return True
        return False
    
    def insertRows(self, row, count, parent=QModelIndex(), data=[{}]):
        self.beginInsertRows(parent, row, row+len(data))
        for d in data:
            self.__data.insert(row, d)
        self.endInsertRows()
        return True

    def set_length(self, length, number, position = 0):
        cur = ref.connection.cursor()
            
        sql_statement = """SELECT * FROM com_new_final.sample_length WHERE
        we_index = {}""".format(ref.weight_uid)
        cur.execute(sql_statement)
        length_data = cur.fetchall()
        
        try:
            self.__data[position]['Length_id'] = length
            self.__data[position]['Length Class'] = length
            self.__data[position]['Length Number'] = number
            self.__data[position]['dirty'] = True
        
        except IndexError:
            cur = ref.connection.cursor()
            sql_statement = """SELECT MAX (le_index) FROM com_new_final.sample_length"""
            cur.execute(sql_statement)
            new_id = cur.fetchone()
            
            try:
                position = len(self.__data)
            except:
                position = 0
            
            length_data = {'Length_id': new_id[0] + position + 1, 'Length Class': length,
                           'Length Number': number, 'dirty': True}
            self.insertRows(len(self.__data), 1, data=[length_data])
            
    def save_data(self, length_weight, length_number):
        
        self.__data[-1]['Length_id'] = self.__data[-2]['Length_id'] + 1
        self.__data[-1]['Length Class'] = length_weight
        self.__data[-1]['Length Number'] = length_number
        
        for rec in self.__data:
            if rec != {'dirty': True}:
                if rec["dirty"] is True:
                    select_statement = """SELECT length_unit FROM com_new_final.sample_weight WHERE
                    we_index = {}""".format(ref.weight_uid)
                    
                    cur = ref.connection.cursor()
                    cur.execute(select_statement)
                    length_unit = cur.fetchone()
                    
                    insert_statement = """INSERT INTO com_new_final.sample_length 
                    (le_index, we_index, length_class, numbers_length, length_unit) VALUES
                    ({}, {}, {}, {}, '{}');""".format(rec['Length_id'], ref.weight_uid,
                    rec['Length Class'], rec['Length Number'], length_unit[0])
                    
                    cur.execute(insert_statement)
                    print(insert_statement)
                    ref.connection.commit()
                    cur.close()
                
                else:
                    update_statement = """UPDATE com_new_final.sample_length SET
                    length_class = {}, numbers_length = {} WHERE
                    le_index = {};""".format(rec['Length Class'], rec['Length Number'], 
                    rec['Length_id'])
                    
                    cur = ref.connection.cursor()
                    cur.execute(update_statement)
                    print(update_statement)
                    ref.connection.commit()
                    cur.close()


class Frm_Length(QWidget, frm_length.Ui_frm_length):

    def __init__(self):
        super(Frm_Length, self).__init__()
        
        self.setupUi(self)
        
        self.cb_fishCategory.addItems(["Landing", "Discard"])
        self.cb_lengthUnit.addItems(["cm", "cm below", "1/2 cm"])
        self.cb_weightUnit.addItems(["g", "kg", "t"])
        
        self.sb_number.editingFinished.connect(self.insert_length)
        
        self.btn_save1.clicked.connect(self.save_weight_data)
        self.btn_save2.clicked.connect(self.save_length_data)

    def set_weight_data(self):
        
        self.haul_uid = ref.haul_uid
        self.weight_uid = None

        cur = ref.connection.cursor()
        
        sql_statement = """SELECT * FROM com_new_final.sample_weight WHERE
        ha_index = {};""".format(self.haul_uid)
        
        cur.execute(sql_statement)
        
        self.__data = cur.fetchone()
        cur.close()
        
        if self.__data != None:
            ref.weight_uid = self.__data[1]
            
            index = self.wgt_species.alpha_names.index(self.__data[2])
            self.wgt_species.cb_latin.setCurrentIndex(index)
            self.wgt_species.activate()
            
            if self.__data[5] == "L":
                self.cb_fishCategory.setCurrentIndex(0)
            else:
                self.cb_fishCategory.setCurrentIndex(1)
            
            if self.__data[11] == "g":
                self.cb_lengthUnit.setCurrentIndex(0)
            elif self.__data[11] == "kg":
                self.cb_lengthUnit.setCurrentIndex(1)
            else:
                self.cb_lengthUnit.setCurrentIndex(2)
            
            if self.__data[12] == "cm":
                self.cb_weightUnit.setCurrentIndex(0)
            elif self.__data[12] == "cm below":
                self.cb_weightUnit.setCurrentIndex(1)
            else:
                self.cb_weightUnit.setCurrentIndex(2)
            
            self.sb_weight_all.setValue(self.__data[6])
            self.sb_number_all.setValue(self.__data[7])
            self.sb_weight_sample.setValue(self.__data[8])
            self.sb_number_sample.setValue(self.__data[9])
            
        self.weight_model = WeightTableModel()
        self.tv_weight.setModel(self.weight_model)
    
    
    def set_length_data(self):
        
        self.weight_uid = ref.weight_uid
        
        cur = ref.connection.cursor()
        
        sql_statement = """SELECT * FROM com_new_final.sample_length WHERE
        we_index = {};""".format(self.weight_uid)
        
        cur.execute(sql_statement)
        
        self.__data = cur.fetchone()
        cur.close()
        
        try:
            ref.length_uid = self.__data[0][0]
        except:
            cur = ref.connection.cursor()
            
            sql_statement = """SELECT MAX (le_index) FROM
            com_new_final.sample_length;"""
            
            cur.execute(sql_statement)
            ref.length_uid = cur.fetchone()[0] + 1
            
            cur.close()
        
        self.length_model = LengthTableModel(0)
        self.tv_length.setModel(self.length_model)
        print(ref.length_uid, 'set')
        if self.__data != None:
            
            self.sb_length_weight.setValue(self.__data[2])
            self.sb_number.setValue(self.__data[3])
    
    def select_length_data(self):
        
        self.weight_uid = ref.weight_uid
        
        position = self.tv_weight.selectionModel().selectedIndexes()[0].row()
        
        cur = ref.connection.cursor()
        
        sql_statement = """SELECT * FROM com_new_final.sample_length WHERE
        we_index = {};""".format(self.weight_uid + position)
        
        cur.execute(sql_statement)
        
        self.__data = cur.fetchone()
        cur.close()
        
        try:
            ref.length_uid = self.__data[0]
        except:
            cur = ref.connection.cursor()
            
            sql_statement = """SELECT MAX (le_index) FROM
            com_new_final.sample_length;"""
            
            cur.execute(sql_statement)
            ref.length_uid = cur.fetchone()[0] + position + 1
            
            cur.close()
        print(ref.length_uid, 'select')
        self.tv_length.reset()
        self.length_model = LengthTableModel(position)
        self.tv_length.setModel(self.length_model)
        
        if self.__data != None:
            
            self.sb_length_weight.setValue(self.__data[2])
            self.sb_number.setValue(self.__data[3])
    
    def add_weight(self):
        fish_id = self.wgt_species.cb_latin.currentIndex()
        fish_name = self.wgt_species.alpha_names[fish_id]
        fish_list = set()
        
        try:
            for i in range(self.weight_model.rowCount()):
                fish_list.add(self.weight_model.data(self.weight_model.index(i, 0)))
            
            if fish_name not in fish_list:
                self.weight_model.insertRows(self.weight_model.rowCount(), 2, QModelIndex(),
                    data = [{'Fischart': fish_name, 'Category': 'L', 'dirty': True},
                        {'Fischart': fish_name, 'Category': 'D', 'dirty': True}])
                
                self.cb_fishCategory.setCurrentIndex(0)
            
                self.sb_weight_all.clear()
                self.sb_number_all.clear()
                self.sb_weight_sample.clear()
                self.sb_number_sample.clear()
            
                self.tv_weight.reset()
                self.tv_weight.setModel(self.weight_model)
            
                cur = ref.connection.cursor()
            
                sql_statement = """SELECT MAX(we_index) FROM
                com_new_final.sample_weight"""
                cur.execute(sql_statement)
                weight_data = cur.fetchone()
            
                ref.weight_uid = weight_data[0]
                ref.weight_uid += 1
            
                self.tv_length.reset()
                self.length_model = LengthTableModel(0)
                self.tv_length.setModel(self.length_model)
            
                self.sb_length_weight.clear()
                self.sb_number.clear()
                        
            else:
                wg_all = float(self.sb_weight_all.value())
                num_all = int(self.sb_number_all.value())
                wg_sample = float(self.sb_weight_sample.value())
                num_sample = int(self.sb_number_sample.value())
                wg_unit = self.cb_weightUnit.currentText()
                len_unit = self.cb_lengthUnit.currentText()
            
                fish_id = self.wgt_species.cb_latin.currentIndex()
                fish_name = self.wgt_species.alpha_names[fish_id]
            
                if self.cb_fishCategory.currentIndex() == 1:
                    data = ['D', wg_all, num_all, wg_sample, num_sample,
                    wg_unit, len_unit]
                else:
                    data = ['L', wg_all, num_all, wg_sample, num_sample,
                    wg_unit, len_unit]   
                
                self.weight_model.insertWeight(*data)
                self.tv_weight.reset()
                self.tv_weight.setModel(self.weight_model)
        except:
            pass
        
    def save_weight_data(self):
        wg_all = float(self.sb_weight_all.value())
        num_all = int(self.sb_number_all.value())
        wg_sample = float(self.sb_weight_sample.value())
        num_sample = int(self.sb_number_sample.value())
        wg_unit = self.cb_weightUnit.currentText()
        len_unit = self.cb_lengthUnit.currentText()
            
        self.weight_model.save_data(wg_all, num_all, wg_sample, num_sample, 
        wg_unit, len_unit)
            
    def insert_length(self):
        try:
            position = self.length_model.rowCount()
        except:
            position = 0
        
        self.length_model.set_length(self.sb_length_weight.value(),
                                     self.sb_number.value(), position)

        self.sb_length_weight.setValue(self.sb_length_weight.value() + 1)

        self.sb_number.editingFinished.disconnect(self.insert_length)
        self.sb_number.setValue(0)
        self.sb_number.editingFinished.connect(self.insert_length)

        self.tv_length.setModel(self.length_model)
        self.tv_length.sortByColumn(0, Qt.AscendingOrder)
        self.tv_length.setSortingEnabled(True)
        self.tv_length.viewport().update()
    
    def save_length_data(self):
        length_weight = float(self.sb_length_weight.value())
        length_number = int(self.sb_number.value())
            
        self.length_model.save_data(length_weight, length_number)

