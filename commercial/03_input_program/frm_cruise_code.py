# -*- coding: utf-8 -*-
"""
Created on Tue Oct  6 13:40:30 2020

@author: hardadi
"""
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *

import csv
import frm_cruise


class Frm_Cruise(QWidget, frm_cruise.Ui_frm_cruise):

    def __init__(self, parent=None):
        super(Frm_Cruise, self).__init__(parent)
        self.setupUi(self)

        harbour_codes_file = open("harbour_codes.csv")
        harbour_codes = csv.reader(harbour_codes_file, delimiter=';')
        harbour_names = [hb[3] for hb in harbour_codes]
        harbour_names = [" "] + harbour_names[1:]
        harbour_names.sort()
        
        self.cb_HarbourStart.addItems(harbour_names)
        self.cb_HarbourEnd.addItems(harbour_names)
        
        leaders_file = open("beprober.csv")
        leaders = csv.reader(leaders_file, delimiter=',')
        leader_codes = [i[1] for i in leaders]
        leader_codes = [" "] + leader_codes[1:-4]
        leader_codes.sort()
        
        self.cb_leader.addItems(leader_codes)
