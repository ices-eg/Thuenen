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
        
        self.header = ['Fischart', 'Category', 'Gesamtgewicht', 'Gesamtanzahl', 'UP Gewicht', 'UP Anzahl']
        
        column = [2,5,6,7,8,9]
        
        if weight_data != []:
            ref.weight_uid = weight_data[0][0]
        
        self.__data = [dict((self.header[i], r[column[i]]) for i in
                    range(len(column))) for r in weight_data]
        
        we_id = 0
        for s in self.__data:
            s["Weight_id"] = weight_data[we_id][0]
            we_id += 1
            s["dirty"] = False
        
        if len(self.__data) == 0:
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
    
    # def setData(self, index, value, role=Qt.EditRole):
    #     if not index.isValid():
    #         return False

    #     if role == Qt.EditRole:
    #         self.__data[index.row()][index.column()] = value

    #         k = self.header[index.column()]
    #         self.__data[index.row()][k] = value
    #         self.__data[index.row()]["dirty"] = True

    #         if index.row() >= (len(self.__data)-1):
    #             self.insertRows(index.row()+1, 1, data=[{}])
    #         self.dataChanged.emit(index, index)
    #         return True
    #     return False
    
    def insertRows(self, row, count, parent=QModelIndex(), data={}):
        self.beginInsertRows(parent, row, row+count-1)
        data["dirty"] = True
        self.__data.insert(row, data)
        self.endInsertRows()
        return True
    
    def save_data(self):
        cur = ref.connection.cursor()
        index_statement = """SELECT MAX(we_index) FROM com_new_final.sample_weight;"""
        cur.execute(index_statement)
        new_id = cur.fetchone()[0] + 1
                
        for rec in self.__data:
            if rec != {'dirty': True}:
                # Datensatz bearbeitet
                if rec["dirty"] is True:
                    # Datensatz ist neu
                    insert_statement = """INSERT INTO com_new_final.sample_weight 
                    (we_index, ha_index, species, aphia_id, latin_name,
                     catch_category, total_weight, total_numbers, subsample_weight,
                     subsample_numbers, number_measured, weight_unit, length_unit) VALUES
                    ({}, {}, '{}', {}, '{}', '{}', {}, {}, {}, {}, {},
                     '{}', '{}');""".format(new_id, ref.haul_uid, rec['Fischart'], 0,
                    "test", rec['Category'], rec['Gesamtgewicht'], rec['Gesamtanzahl'],
                    rec['UP Gewicht'], rec['UP Anzahl'], "cm", "cm")
    
                    cur = ref.connection.cursor()
                    cur.execute(insert_statement)
                    new_id += 1
                    ref.connection.commit()
                    cur.close()
                
                else:
                    update_statement = """UPDATE com_new_final.sample_weight SET
                    total_weight = {}, total_numbers = {}, subsample_weight = {},
                    subsample_numbers = {}, number_measured = {} WHERE ha_index = {}
                    AND species = '{}' AND catch_category = '{}';""".format(rec['Gesamtgewicht'],
                    rec['Gesamtanzahl'], rec['UP Gewicht'], rec['UP Anzahl'], 
                    ref.haul_uid, rec['Fischart'], rec['Category'])
                    
                    cur = ref.connection.cursor()
                    cur.execute(update_statement)
                    ref.connection.commit()
                    cur.close()
        

class LengthTableModel(QAbstractTableModel):

    def __init__(self):
        super(LengthTableModel, self).__init__()
        
        self.weight_uid = ref.weight_uid
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
        else:
            self.__data = [dict((self.header[i], "") for i in
                    range(len(self.header)))]
        
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
    
    def insertRows(self, row, count, parent=QModelIndex(), data=[]):
        self.beginInsertRows(parent, row, row+len(data))
        for d in data:
            d.extend([None, False])
            print('insertRows : {0}'.format(d))
            self.__data.insert(row, d)
        self.endInsertRows()
        print('insertRows : {0}'.format(self.__data))
        return True

    def set_length(self, length, number, weight=0.0):
        try:
            idx = [l[0] for l in self.__data].index(length)
            self.__data[idx][1] = number
            self.__data[idx][2] = weight
            self.__data[idx][-1] = True
        except ValueError:
            length_data = [length, number, weight]
            self.insertRows(len(self.__data), 1, data=[length_data])


class Frm_Length(QWidget, frm_length.Ui_frm_length):

    def __init__(self):
        super(Frm_Length, self).__init__()
        
        self.setupUi(self)
        
        self.cb_fishCategory.addItems(["Landing", "Discard"])
        self.cb_lengthUnit.addItems(["cm", "cm below", "1/2 cm"])
        self.cb_weightUnit.addItems(["g", "kg", "t"])
        
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
            ref.length_uid = self.__data[0]
        except:
            ref.length_uid = None
        
        self.length_model = LengthTableModel()
        self.tv_length.setModel(self.length_model)
        
        if self.__data != None:
            
            self.sb_length_weight.setValue(self.__data[2])
            self.sb_number.setValue(self.__data[3])
            
    def add_weight(self):
        fish_id = self.wgt_species.cb_latin.currentIndex()
        fish_name = self.wgt_species.alpha_names[fish_id]
        
        try:
            self.weight_model.insertRows(
                self.weight_model.rowCount(), 1, QModelIndex(),
                data = {'Fischart': fish_name})
        
            self.sb_weight_all.clear()
            self.sb_number_all.clear()
            self.sb_weight_sample.clear()
            self.sb_number_sample.clear()
            
            self.tv_weight.reset()
            self.tv_weight.setModel(self.weight_model)
            
            cur = ref.connection.cursor()
            
            sql_statement = """SELECT MAX(we_index) FROM com_new_final.sample_weight"""
            cur.execute(sql_statement)
            weight_data = cur.fetchone()
            
            ref.weight_uid = weight_data[0]
            ref.weight_uid += 1
            
            self.tv_length.reset()
            self.length_model = LengthTableModel()
            self.tv_length.setModel(self.length_model)
            
            self.sb_length_weight.clear()
            self.sb_number.clear()
                        
        except:
            pass
        
    def save_weight_data(self):
        self.weight_model.save_data()
            
    def save_length_data(self):
        pass

