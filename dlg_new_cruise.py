# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'dlg_new_cruise.ui'
#
# Created by: PyQt5 UI code generator 5.12.3
#
# WARNING! All changes made in this file will be lost!


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_dlg_New_Cruise(object):
    def setupUi(self, dlg_New_Cruise):
        dlg_New_Cruise.setObjectName("dlg_New_Cruise")
        dlg_New_Cruise.resize(641, 349)
        self.gridLayout = QtWidgets.QGridLayout(dlg_New_Cruise)
        self.gridLayout.setObjectName("gridLayout")
        spacerItem = QtWidgets.QSpacerItem(162, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.gridLayout.addItem(spacerItem, 1, 0, 1, 1)
        self.btn_close = QtWidgets.QPushButton(dlg_New_Cruise)
        self.btn_close.setObjectName("btn_close")
        self.gridLayout.addWidget(self.btn_close, 1, 1, 1, 1)
        self.btn_save = QtWidgets.QPushButton(dlg_New_Cruise)
        self.btn_save.setObjectName("btn_save")
        self.gridLayout.addWidget(self.btn_save, 1, 2, 1, 1)
        self.frm_cruise = Frm_Cruise(dlg_New_Cruise)
        self.frm_cruise.setObjectName("frm_cruise")
        self.gridLayout.addWidget(self.frm_cruise, 0, 0, 1, 3)

        self.retranslateUi(dlg_New_Cruise)
        QtCore.QMetaObject.connectSlotsByName(dlg_New_Cruise)

    def retranslateUi(self, dlg_New_Cruise):
        _translate = QtCore.QCoreApplication.translate
        dlg_New_Cruise.setWindowTitle(_translate("dlg_New_Cruise", "Dialog"))
        self.btn_close.setText(_translate("dlg_New_Cruise", "Abbrechen"))
        self.btn_save.setText(_translate("dlg_New_Cruise", "Anlegen"))
from frm_cruise_code import Frm_Cruise
