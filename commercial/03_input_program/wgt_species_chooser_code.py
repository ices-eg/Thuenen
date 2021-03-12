from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *

import csv
import wgt_species_chooser


class Wgt_Species_Chooser(QWidget, wgt_species_chooser.Ui_wgt_Species_Chooser):
    def __init__(self, parent=None):
        super(Wgt_Species_Chooser, self).__init__(parent)
        self.setupUi(self)

        alpha_names, alpha_latin, alpha_aphiaid = [], [], []
        with open('alpha_id.csv', newline='') as alpha_id_file:
            spamreader = csv.reader(alpha_id_file, delimiter=',')
            for row in spamreader:
                alpha_names.append(row[1])
                alpha_latin.append(row[2])
                alpha_aphiaid.append(row[3])
                
        self.alpha_latin = dict(zip(alpha_names, alpha_latin))
        self.alpha_aphiaid = dict(zip(alpha_names, alpha_aphiaid))
        
        alpha_names = alpha_names[1:]
        alpha_names.sort()
        alpha_names +=  ["OTH"]
        self.alpha_names = alpha_names
        
        self.cb_latin.addItems(self.alpha_names)
        self.cb_latin.activated.connect(self.activate)


    def activate(self):
        fishcode = self.cb_latin.itemText(self.cb_latin.currentIndex())
        if fishcode == "OTH":
            self.edit_aphiaid.setEnabled(1)
            self.edit_latin.setEnabled(1)
        else:
            self.edit_aphiaid.setEnabled(0)
            self.edit_latin.setEnabled(0)
            
            self.edit_aphiaid.setText(self.alpha_aphiaid[fishcode])
            self.edit_latin.setText(self.alpha_latin[fishcode])
            
    
    def set_data(self):
        pass