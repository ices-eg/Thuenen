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

        if weight_data != None:
            self.__data = [[] for i in range(len(weight_data))]
            for i in range(len(weight_data)):
                for j in [2,5,6,7,8,9]:
                    self.__data[i].append(weight_data[i][j])

        self.header = ['Fischart', 'Category', 'Gesamtgewicht', 'Gesamtanzahl', 'UP Gewicht', 'UP Anzahl']

        ref.weight_uid = weight_data[0][0]
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
        column = index.column()

        if role == Qt.DisplayRole or role == Qt.EditRole:
            return data_row[column]

        return None
    
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

class LengthTableModel(QAbstractTableModel):

    def __init__(self):
        super(LengthTableModel, self).__init__()
        
        self.weight_uid = ref.weight_uid
        self.length_uid = None
        
        cur = ref.connection.cursor()
        
        sql_statement = """SELECT * FROM com_new_final.sample_length WHERE
        we_index = {}""".format(self.weight_uid)
        cur.execute(sql_statement)
        length_data = cur.fetchall()
        
        if length_data != None:
            self.__data = [[] for i in range(len(length_data))]
            for i in range(len(length_data)):
                for j in [2,3]:
                    self.__data[i].append(length_data[i][j])

        self.header = ['Length Class', 'Length Number']

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
        column = index.column()

        if role == Qt.DisplayRole or role == Qt.EditRole:
            return data_row[column]

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
        
        # alpha_names, alpha_latin, alpha_aphiaid = [], [], []
        # with open('alpha_id.csv', newline='') as alpha_id_file:
        #     spamreader = csv.reader(alpha_id_file, delimiter=',')
        #     for row in spamreader:
        #         alpha_names.append(row[1])
        #         alpha_latin.append(row[2])
        #         alpha_aphiaid.append(row[3])
                
        # self.alpha_latin = dict(zip(alpha_names, alpha_latin))
        # self.alpha_aphiaid = dict(zip(alpha_names, alpha_aphiaid))
        
        # alpha_names = alpha_names[1:]
        # alpha_names.sort()
        # alpha_names +=  ["OTH"]
        # self.alpha_names = alpha_names
        
        # self.cb_latin.addItems(self.alpha_names)
        
        self.cb_fishCategory.addItems(["Landing", "Discard"])
        self.cb_lengthUnit.addItems(["cm", "cm below", "1/2 cm"])
        self.cb_weightUnit.addItems(["g", "kg", "t"])
        
        # self.cb_latin.activated.connect(self.activate)
        

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
            

    # def activate(self):
    #     fishcode = self.cb_latin.itemText(self.cb_latin.currentIndex())
    #     if fishcode == "OTH":
    #         self.edit_aphiaid.setEnabled(1)
    #         self.edit_latin.setEnabled(1)
    #     else:
    #         self.edit_aphiaid.setEnabled(0)
    #         self.edit_latin.setEnabled(0)
            
    #         self.edit_aphiaid.setText(self.alpha_aphiaid[fishcode])
    #         self.edit_latin.setText(self.alpha_latin[fishcode])
    
    
    def set_length_data(self):
        
        self.weight_uid = ref.weight_uid

        cur = ref.connection.cursor()
        
        sql_statement = """SELECT * FROM com_new_final.sample_length WHERE
        we_index = {};""".format(self.weight_uid)
        
        cur.execute(sql_statement)
        
        self.__data = cur.fetchone()
        cur.close()
        
        ref.length_uid = self.__data[0]
        
        if self.__data != None:
            
            self.length_model = LengthTableModel()
            
            self.tv_length.setModel(self.length_model)
            
            self.sb_length_weight.setValue(self.__data[2])
            self.sb_number.setValue(self.__data[3])
            
            

