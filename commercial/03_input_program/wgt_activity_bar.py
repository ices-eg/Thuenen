# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'wgt_activity_bar.ui'
#
# Created by: PyQt5 UI code generator 5.12.3
#
# WARNING! All changes made in this file will be lost!


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_Wgt_Activity_Bar(object):
    def setupUi(self, Wgt_Activity_Bar):
        Wgt_Activity_Bar.setObjectName("Wgt_Activity_Bar")
        Wgt_Activity_Bar.resize(240, 43)
        self.horizontalLayout = QtWidgets.QHBoxLayout(Wgt_Activity_Bar)
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.btn_add_haul = QtWidgets.QPushButton(Wgt_Activity_Bar)
        self.btn_add_haul.setObjectName("btn_add_haul")
        self.horizontalLayout.addWidget(self.btn_add_haul)
        spacerItem = QtWidgets.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout.addItem(spacerItem)

        self.retranslateUi(Wgt_Activity_Bar)
        QtCore.QMetaObject.connectSlotsByName(Wgt_Activity_Bar)

    def retranslateUi(self, Wgt_Activity_Bar):
        _translate = QtCore.QCoreApplication.translate
        Wgt_Activity_Bar.setWindowTitle(_translate("Wgt_Activity_Bar", "Form"))
        self.btn_add_haul.setText(_translate("Wgt_Activity_Bar", "+ Hol"))
