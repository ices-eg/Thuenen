from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *

import csv
import wgt_species_chooser


class Wgt_Species_Chooser(QWidget, wgt_species_chooser.Ui_wgt_Species_Chooser):
    def __init__(self, parent=None):
        super(Wgt_Species_Chooser, self).__init__(parent)
        self.setupUi(self)

        alpha_id_file = open("alpha_id.csv")
        alpha_codes = csv.reader(alpha_id_file)
        alpha_names = [a[1] for a in alpha_codes]
        alpha_names = alpha_names[1:]
        alpha_names.sort()
        alpha_names +=  ["OTH"]
        
        self.cb_latin.addItems(alpha_names)
        
        self.cb_latin.currentIndexChanged.connect(self.activate)


    def activate(self):
        if self.cb_latin.itemText(self.cb_latin.currentIndex()) == "OTH":
            self.edit_aphiaid.setEnabled(1)
            self.edit_latin.setEnabled(1)
        else:
            self.edit_aphiaid.setEnabled(0)
            self.edit_latin.setEnabled(0)