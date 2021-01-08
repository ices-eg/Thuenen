from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *

import wgt_activity_bar


class Wgt_Activity_Bar(QWidget, wgt_activity_bar.Ui_Wgt_Activity_Bar):

    new_haul_clicked = pyqtSignal()
        
    def __init__(self, parent=None):
        super(Wgt_Activity_Bar, self).__init__(parent)
        self.setupUi(self)

        self.btn_add_haul.clicked.connect(self.new_haul_clicked.emit)
