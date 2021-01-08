# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'dlg_new_haul.ui'
#
# Created by: PyQt5 UI code generator 5.12.3
#
# WARNING! All changes made in this file will be lost!


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_dlg_New_Haul(object):
    def setupUi(self, dlg_New_Haul):
        dlg_New_Haul.setObjectName("dlg_New_Haul")
        dlg_New_Haul.resize(234, 88)
        self.gridLayout = QtWidgets.QGridLayout(dlg_New_Haul)
        self.gridLayout.setObjectName("gridLayout")
        self.btn_ok = QtWidgets.QPushButton(dlg_New_Haul)
        self.btn_ok.setObjectName("btn_ok")
        self.gridLayout.addWidget(self.btn_ok, 1, 2, 1, 1)
        self.label_2 = QtWidgets.QLabel(dlg_New_Haul)
        self.label_2.setObjectName("label_2")
        self.gridLayout.addWidget(self.label_2, 0, 0, 1, 1)
        self.edt_haul = QtWidgets.QLineEdit(dlg_New_Haul)
        self.edt_haul.setObjectName("edt_haul")
        self.gridLayout.addWidget(self.edt_haul, 0, 1, 1, 2)
        spacerItem = QtWidgets.QSpacerItem(71, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.gridLayout.addItem(spacerItem, 1, 1, 1, 1)

        self.retranslateUi(dlg_New_Haul)
        QtCore.QMetaObject.connectSlotsByName(dlg_New_Haul)

    def retranslateUi(self, dlg_New_Haul):
        _translate = QtCore.QCoreApplication.translate
        dlg_New_Haul.setWindowTitle(_translate("dlg_New_Haul", "Station anlegen"))
        self.btn_ok.setText(_translate("dlg_New_Haul", "Anlegen"))
        self.label_2.setText(_translate("dlg_New_Haul", "Hol"))
