# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'dlg_cruise_select.ui'
#
# Created by: PyQt5 UI code generator 5.12.3
#
# WARNING! All changes made in this file will be lost!


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_dlg_cruise_select(object):
    def setupUi(self, dlg_cruise_select):
        dlg_cruise_select.setObjectName("dlg_cruise_select")
        dlg_cruise_select.resize(706, 700)
        self.gridLayout = QtWidgets.QGridLayout(dlg_cruise_select)
        self.gridLayout.setObjectName("gridLayout")
        self.frm_cruise = Frm_Cruise(dlg_cruise_select)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Expanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.frm_cruise.sizePolicy().hasHeightForWidth())
        self.frm_cruise.setSizePolicy(sizePolicy)
        self.frm_cruise.setObjectName("frm_cruise")
        self.gridLayout.addWidget(self.frm_cruise, 1, 0, 1, 3)
        spacerItem = QtWidgets.QSpacerItem(248, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.gridLayout.addItem(spacerItem, 2, 0, 1, 1)
        self.btn_search = QtWidgets.QPushButton(dlg_cruise_select)
        self.btn_search.setObjectName("btn_search")
        self.gridLayout.addWidget(self.btn_search, 2, 1, 1, 1)
        self.btn_select = QtWidgets.QPushButton(dlg_cruise_select)
        self.btn_select.setObjectName("btn_select")
        self.gridLayout.addWidget(self.btn_select, 2, 2, 1, 1)
        self.tv_cruises = QtWidgets.QTableView(dlg_cruise_select)
        self.tv_cruises.setObjectName("tv_cruises")
        self.gridLayout.addWidget(self.tv_cruises, 0, 0, 1, 3)

        self.retranslateUi(dlg_cruise_select)
        QtCore.QMetaObject.connectSlotsByName(dlg_cruise_select)
        dlg_cruise_select.setTabOrder(self.tv_cruises, self.btn_search)
        dlg_cruise_select.setTabOrder(self.btn_search, self.btn_select)

    def retranslateUi(self, dlg_cruise_select):
        _translate = QtCore.QCoreApplication.translate
        dlg_cruise_select.setWindowTitle(_translate("dlg_cruise_select", "Reise auswählen"))
        self.btn_search.setText(_translate("dlg_cruise_select", "Süchen"))
        self.btn_select.setText(_translate("dlg_cruise_select", "Auswählen"))
from frm_cruise_code import Frm_Cruise
