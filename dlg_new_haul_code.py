from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *

import dlg_new_haul

class dlg_New_Haul(QDialog, dlg_new_haul.Ui_dlg_New_Haul):

    def __init__(self, cruise_uid, parent=None):
        super(dlg_New_Haul, self).__init__(parent)
        self.setupUi(self)
        self.cruise_uid = cruise_uid
        
        self.btn_ok.clicked.connect(self.create_haul)

    def create_haul(self):
        self.ha_index = self.edt_haul.text()
        
        self.done(0)
