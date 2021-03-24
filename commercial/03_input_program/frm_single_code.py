# -*- coding: utf-8 -*-
"""
Created on Thu Jan  7 15:35:03 2021

@author: hardadi
"""

from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *

import frm_single

#import account
from reference import Reference as ref
from materialized_view import MaterializedView as mv

class SingleTableModel(QAbstractTableModel):

    def __init__(self, parent=None):
        super(SingleTableModel, self).__init__(parent)

        self.length_uid = ref.length_uid
        self.header = ['Fisch ID', 'Length', 'Weight', 'Sex', 'Maturity', 'Age',
                       'Readability', 'Gut Weight', 'Liver Weight', 'Liver Color',
                       'Stomach', 'Parasites', 'Fins', 'Gonad Weight']
        
        cur = ref.connection.cursor()
        
        single_table = mv(self.length_uid)
        sql_statement = single_table.sql()
        cur.execute(sql_statement)
        
        bio_data = cur.fetchall()
        ref.connection.commit()
        cur.close()
        
        self.__data = [dict((self.header[i-1], r[i]) for i in
                            range(1, len(r))) for r in bio_data]
        for s in self.__data:
            s["dirty"] = False
        
        if len(self.__data) == 0:
            self.__data.append({"dirty": True})

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

    def data(self, index, role=Qt.DisplayRole):
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

        if role == Qt.EditRole:
            self.__data[index.row()][index.column()] = value

            k = self.header[index.column()]
            self.__data[index.row()][k] = value
            self.__data[index.row()]["dirty"] = True

            if index.row() >= (len(self.__data)-1):
                self.insertRows(index.row()+1, 1, data=[{}])
            self.dataChanged.emit(index, index)
            return True
        return False

    def insertRows(self, row, count, parent=QModelIndex(), data=[{}]):
        self.beginInsertRows(parent, row, row+count-1)
        for i, d in enumerate(data):
            d2 = d.copy()
            d2["dirty"] = True
            self.__data.insert(row+i, d2)
        self.endInsertRows()
        return True
    
    def save_data(self):
        cur = ref.connection.cursor()
        index_statement = """SELECT MAX(bi_index) FROM com_new_final.sample_bio;"""
        cur.execute(index_statement)
        new_id = cur.fetchone()[0] + 1
        
        parameter_id = "SELECT * FROM com_new_final.parameter;"
        cur.execute(parameter_id)
        parameter = cur.fetchall()
        
        units = {}
        for i in parameter:
            units[int(i[0])] = int(i[2])
        
        for rec in self.__data:
            
            if rec != {'dirty': True}:
                # Datensatz bearbeitet
                if rec["dirty"] is True:
                    # Datensatz ist neu
                    fish_id, par, value, unit = 0, 0, 0, 0
                    
                    for i in range(1, len(rec) // 2 - 1):
                        fish_id = int(rec['Fisch ID'])
                        par = int(i)
                        value = rec[self.header[par]]
                        unit = units[par]
                        
                        insert_statement = """INSERT INTO com_new_final.sample_bio 
                    (bi_index, le_index, fish_id, parameter, value, unit) VALUES
                    ({}, {}, {}, {}, '{}', {});""".format(new_id,
                    self.length_uid, fish_id, par, value, unit)
                        
                        cur = ref.connection.cursor()
                        cur.execute(insert_statement)
                        new_id += 1
                        ref.connection.commit()
                        cur.close()
                
                else:
                    # Datensatz ist schon vorbereit
                    fish_id = int(rec['Fisch ID'])
                    
                    select_bi_index = """SELECT bi_index FROM
                    com_new_final.sample_bio WHERE le_index = {} AND
                    fish_id = {};""".format(self.length_uid, fish_id)
                    
                    select_parameter = """SELECT parameter FROM
                    com_new_final.sample_bio WHERE le_index = {} AND
                    fish_id = {};""".format(self.length_uid, fish_id)
                    
                    cur = ref.connection.cursor()
                    cur.execute(select_bi_index)
                    update_bi_id = cur.fetchall()
                    
                    cur = ref.connection.cursor()
                    cur.execute(select_parameter)
                    update_parameter = cur.fetchall()
                    
                    for i in range(1, len(rec) // 2 - 1):
                        par = int(i)
                        value = rec[self.header[par]]
                        unit = units[par]
                        
                        if par in update_parameter:
                            bi_id = update_bi_id[update_parameter.index(par)]
                            
                            update_statement = """UPDATE com_new_final.sample_bio 
                    SET parameter = {}, value = '{}', unit = {} WHERE bi_index =
                    {};""".format(par, value, unit, bi_id)
                        
                            cur = ref.connection.cursor()
                            cur.execute(update_statement)
                            new_id += 1
                            ref.connection.commit()
                            cur.close()
                        
                        else:
                            insert_statement = """INSERT INTO com_new_final.sample_bio 
                    (bi_index, le_index, fish_id, parameter, value, unit) VALUES
                    ({}, {}, {}, {}, '{}', {});""".format(new_id,
                    self.length_uid, fish_id, par, value, unit)
    
                            cur = ref.connection.cursor()
                            cur.execute(insert_statement)
                            new_id += 1
                            ref.connection.commit()
                            cur.close()
    

class Frm_Single(QWidget,frm_single.Ui_frm_single):

    def __init__(self,parent=None):
        super(Frm_Single, self).__init__(parent)
        self.setupUi(self)
        
        self.cb_fishCategory.addItems(["Landing", "Discard"])
        
        self.wgt_species.cb_latin.currentIndexChanged.connect(self.select_species)
        self.cb_length_class.currentIndexChanged.connect(self.select_length)
        
        self.btn_save.clicked.connect(self.save_data)

        self.setEnabled(False)

    def set_data(self):
        self.haul_uid = ref.haul_uid
        
        cur = ref.connection.cursor()
        
        sql_statement = """SELECT we_index, species, catch_category FROM
        com_new_final.sample_weight WHERE ha_index = {};""".format(self.haul_uid)
        
        cur.execute(sql_statement)
        weight_data = cur.fetchone()
        cur.close()
        
        if weight_data != None:
            ref.weight_uid = weight_data[0]
            
            index = self.wgt_species.alpha_names.index(weight_data[1])
            self.wgt_species.cb_latin.setCurrentIndex(index)
            self.wgt_species.activate()
            
            if weight_data[2] == "L":
                self.cb_fishCategory.setCurrentIndex(0)
            else:
                self.cb_fishCategory.setCurrentIndex(1)
            
            self.species_selected()
            self.setEnabled(True)

    def species_selected(self):
        self.weight_uid = ref.weight_uid
        cur = ref.connection.cursor()
        
        sql_statement = """SELECT le_index, length_class FROM
        com_new_final.sample_length WHERE we_index = {};""".format(self.weight_uid)
            
        cur.execute(sql_statement)
        length_data = cur.fetchall()
        cur.close()
            
        self.__data = {}
        for i in length_data:
            self.__data[str(i[1])] = i[0]
            
        length_class = list(self.__data.keys())
        #print(ref.weight_uid, ref.length_uid, length_class)
            
        self.cb_length_class.clear()
        self.cb_length_class.addItems(length_class)
        
        #print(ref.weight_uid, ref.length_uid)
        self.single_model = SingleTableModel()
        self.tv_single.horizontalHeader().set_context(self.single_model.header)
        self.tv_single.setModel(self.single_model)
        #print(ref.weight_uid, ref.length_uid)
        
    def select_species(self):
        self.haul_uid = ref.haul_uid
        
        species = self.wgt_species.cb_latin.currentText()
        if self.cb_fishCategory.currentIndex() == 0:
            catch = 'L'
        else:
            catch = 'D'
        
        cur = ref.connection.cursor()
        
        sql_statement = """SELECT we_index, species, catch_category FROM
        com_new_final.sample_weight WHERE ha_index = {} AND species = '{}'
        AND catch_category = '{}';""".format(self.haul_uid, species, catch)
        
        cur.execute(sql_statement)
        weight_data = cur.fetchone()
        cur.close()
        
        if weight_data != None:
            ref.weight_uid = weight_data[0]
        else:
            QMessageBox.warning(self, 'Fehler', 'Keine Fisch')
            return
        
        self.species_selected()
    
    def select_length(self):
        length = self.cb_length_class.currentText()
        
        try:
            self.length_uid = self.__data[str(length)]
            ref.length_uid = self.length_uid
        except:
            pass
        
        self.single_model = SingleTableModel()
        self.tv_single.horizontalHeader().set_context(self.single_model.header)
        self.tv_single.setModel(self.single_model)
        #print(ref.weight_uid, ref.length_uid)

    def save_data(self):
        if self.single_model is not None:
            self.single_model.save_data()