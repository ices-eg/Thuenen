from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *

import frm_enviro


class Frm_Weather(QWidget, frm_enviro.Ui_frm_weather):

    def __init__(self, parent=None):
        super(Frm_Weather, self).__init__(parent)
        self.setupUi(self)
