# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'frm_single.ui'
#
# Created by: PyQt5 UI code generator 5.12.3
#
# WARNING! All changes made in this file will be lost!


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_frm_single(object):
    def setupUi(self, frm_single):
        frm_single.setObjectName("frm_single")
        frm_single.resize(609, 614)
        self.verticalLayout = QtWidgets.QVBoxLayout(frm_single)
        self.verticalLayout.setObjectName("verticalLayout")
        self.wgt_species = Wgt_Species_Chooser(frm_single)
        self.wgt_species.setObjectName("wgt_species")
        self.verticalLayout.addWidget(self.wgt_species)
        self.tv_single = SingleTableView(frm_single)
        self.tv_single.setObjectName("tv_single")
        self.verticalLayout.addWidget(self.tv_single)
        self.horizontalLayout = QtWidgets.QHBoxLayout()
        self.horizontalLayout.setObjectName("horizontalLayout")
        spacerItem = QtWidgets.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout.addItem(spacerItem)
        self.btn_save = QtWidgets.QPushButton(frm_single)
        self.btn_save.setObjectName("btn_save")
        self.horizontalLayout.addWidget(self.btn_save)
        self.verticalLayout.addLayout(self.horizontalLayout)

        self.retranslateUi(frm_single)
        QtCore.QMetaObject.connectSlotsByName(frm_single)

    def retranslateUi(self, frm_single):
        _translate = QtCore.QCoreApplication.translate
        frm_single.setWindowTitle(_translate("frm_single", "Form"))
        self.btn_save.setText(_translate("frm_single", "Speichern"))
from singletableview import SingleTableView
from wgt_species_chooser_code import Wgt_Species_Chooser
