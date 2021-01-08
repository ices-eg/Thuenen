# -*- coding: utf-8 -*-
"""
Created on Tue Oct  6 13:40:30 2020

@author: hardadi
"""
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *

import csv
import frm_gear

#import account
from reference import Reference as ref


def row_dict(row, cur):
    col_names = [col[0] for col in cur.description]
    return dict(zip(col_names, row))

class Frm_Gear(QWidget, frm_gear.Ui_frm_gear):

    def __init__(self, parent=None):
        super(Frm_Gear, self).__init__(parent)
        self.setupUi(self)

        gear_prop = []
        with open('gear_map.csv', newline='') as gear_codes_file:
            spamreader = csv.reader(gear_codes_file, delimiter=',')
            for row in spamreader:
                gear_prop.append(row)
        
        self.gear_names = [gear[0] for gear in gear_prop]
        
        self.cb_netz.addItems(self.gear_names[1:])
        
        self.buttons = [self.edit_minDepth, self.edit_maxDepth, self.edit_waterDepth,
                        self.edit_tier5, self.edit_tier6, self.edit_gear,
                        self.edit_meshSizeRange, self.edit_device, self.edit_deviceMesh,
                        self.edit_spGroup, self.edit_sp, self.edit_spNum, self.edit_catch,
                        self.edit_gearAdd, self.edit_meshSize, self.edit_codendMeshSize,
                        self.edit_footrope, self.edit_footropeLength, self.edit_jagerLength,
                        self.edit_netBoard, self.edit_netHori, self.edit_netVert,
                        self.edit_netGirth, self.edit_curlLineLength, self.edit_rollerDiam,
                        self.edit_beamLength, self.edit_beamChains, self.edit_setNetNum,
                        self.edit_setNetLength, self.edit_setNetHeight, self.edit_setNetTotal,
                        self.edit_pinger, self.edit_pingerType, self.edit_hooks, self.edit_traps]
        
        self.gear_prop = gear_prop
        
        index = self.cb_netz.currentIndex()
        
        for i in range(13):
            self.buttons[i].setEnabled(1)
        
        for i in range(13, len(self.buttons)):
            self.buttons[i].setEnabled(int(self.gear_prop[index+1][i-11]))
        
        self.cb_netz.currentIndexChanged.connect(self.select_gear)
        self.btn_save.clicked.connect(self.save)
    
    def select_gear(self):
        index = self.cb_netz.currentIndex()
        self.cb_netz.setCurrentIndex(index)
        
        for i in range(13):
            self.buttons[i].setEnabled(1)
        
        for i in range(13, len(self.buttons)):
            self.buttons[i].setEnabled(int(self.gear_prop[index+1][i-11]))
        
    def show_data(self):
        self.cruise_uid = ref.cruise_uid
        self.haul_uid = ref.haul_uid
        
        cur = ref.connection.cursor()
        
        sql_statement = """SELECT * FROM com_new_final.haul_gear WHERE
        tr_index = {} AND ha_index = {}""".format(self.cruise_uid, self.haul_uid)
        
        cur.execute(sql_statement)
        
        self.__data = cur.fetchone()
        cur.close()
        
        if self.__data != None:
            gear, gear_index = self.__data[7], 0
        
            for i in range(1, len(self.gear_names)):
                if self.gear_names[i][:3] == gear:
                    gear_index = i - 1
        
            self.cb_netz.setCurrentIndex(gear_index)
        
            for i in range(len(self.buttons)):
                if self.__data[i + 2] != None:
                    self.buttons[i].setText(str(self.__data[i + 2]))
                else:
                    self.buttons[i].setText("")
        else:
            pass
    
    def clear(self):
        for i in self.buttons:
            i.clear()
    
    def save(self):
        self.cruise_uid = ref.cruise_uid
        self.haul_uid = ref.haul_uid
        
        self.fields = []
        for i in self.buttons:
            self.fields.append(i.text())
        
        """List contains positions of self.fields with integer values"""
        for i in [0,1,2,7,8,11,12,14,15,17,18,23,24,25,26,27,33,34]:
            try:
                self.fields[i] = int(self.fields[i])
            except ValueError:
                self.fields[i] = -9
        
        """List contains positions of self.fields with float (double) values"""
        for i in [19,20,21,22,28,29,30]:
            try:
                self.fields[i] = float(self.fields[i])
            except ValueError:
                self.fields[i] = -9
        
        cur = ref.connection.cursor()
        
        sql_statement = """SELECT * FROM com_new_final.haul_gear WHERE
        tr_index = {} AND ha_index = {}""".format(self.cruise_uid, self.haul_uid)
        
        cur.execute(sql_statement)
        
        if cur.fetchone() == None:
            sql_cols = "SELECT column_name FROM INFORMATION_SCHEMA.columns WHERE TABLE_NAME = 'haul_gear';"
            
            cur.execute(sql_cols)
            header = cur.fetchall()
            self.header = [i[0] for i in header]
            
            sql_statement = "INSERT INTO com_new_final.haul_gear ("
            for i in range(len(self.header) - 1):
                sql_statement += self.header[i] + ", "
            sql_statement += self.header[-1] + ") VALUES "
            
            result = "({}, {}, ".format(self.haul_uid, self.cruise_uid)
            for i in self.fields:
                if i == "" or i == None:
                    result += "NULL, "
                elif type(i) == int or type(i) == float:
                    result += str(i) + ", "
                else:
                    result += "'{}', ".format(i)
            result = result[:-2] + ")"
    
            print(sql_statement + result)
            cur.execute(sql_statement + result)
            ref.connection.commit()
            cur.close()
            
        else:
            sql_cols = "SELECT column_name FROM INFORMATION_SCHEMA.columns WHERE TABLE_NAME = 'haul_gear';"
            
            cur.execute(sql_cols)
            header = cur.fetchall()
            self.header = [i[0] for i in header]
            
            sql_statement = "UPDATE com_new_final.haul_gear SET tr_index = {}, ".format(self.cruise_uid)
            for i in range(2, len(self.header)):
                sql_statement += self.header[i] + " = "
                if self.fields[i - 2] == "" or self.fields[i - 2] == None:
                    sql_statement += "NULL, "
                elif type(self.fields[i - 2]) == int or type(self.fields[i - 2]) == float:
                    sql_statement += str(self.fields[i - 2]) + ", "
                else:
                    sql_statement += "'{}', ".format(self.fields[i - 2])
            sql_statement = sql_statement[:-2] + " WHERE ha_index = {}".format(self.haul_uid)
            
            print(sql_statement)
            cur.execute(sql_statement)
            ref.connection.commit()
            cur.close()
            
            