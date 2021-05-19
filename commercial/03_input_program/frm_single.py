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
        frm_single.resize(614, 618)
        self.verticalLayout_2 = QtWidgets.QVBoxLayout(frm_single)
        self.verticalLayout_2.setObjectName("verticalLayout_2")
        self.horizontalLayout_3 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_3.setObjectName("horizontalLayout_3")
        self.wgt_species = Wgt_Species_Chooser(frm_single)
        self.wgt_species.setObjectName("wgt_species")
        self.horizontalLayout_3.addWidget(self.wgt_species)
        self.verticalLayout = QtWidgets.QVBoxLayout()
        self.verticalLayout.setObjectName("verticalLayout")
        spacerItem = QtWidgets.QSpacerItem(20, 13, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Fixed)
        self.verticalLayout.addItem(spacerItem)
        self.horizontalLayout_2 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_2.setObjectName("horizontalLayout_2")
        spacerItem1 = QtWidgets.QSpacerItem(18, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout_2.addItem(spacerItem1)
        self.label = QtWidgets.QLabel(frm_single)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Preferred, QtWidgets.QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.label.sizePolicy().hasHeightForWidth())
        self.label.setSizePolicy(sizePolicy)
        self.label.setMinimumSize(QtCore.QSize(85, 0))
        self.label.setObjectName("label")
        self.horizontalLayout_2.addWidget(self.label)
        self.cb_fishCategory = QtWidgets.QComboBox(frm_single)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.cb_fishCategory.sizePolicy().hasHeightForWidth())
        self.cb_fishCategory.setSizePolicy(sizePolicy)
        self.cb_fishCategory.setMinimumSize(QtCore.QSize(170, 25))
        self.cb_fishCategory.setObjectName("cb_fishCategory")
        self.horizontalLayout_2.addWidget(self.cb_fishCategory)
        spacerItem2 = QtWidgets.QSpacerItem(28, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout_2.addItem(spacerItem2)
        self.label_2 = QtWidgets.QLabel(frm_single)
        self.label_2.setMinimumSize(QtCore.QSize(85, 0))
        self.label_2.setObjectName("label_2")
        self.horizontalLayout_2.addWidget(self.label_2)
        self.cb_length_class = QtWidgets.QComboBox(frm_single)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Preferred, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.cb_length_class.sizePolicy().hasHeightForWidth())
        self.cb_length_class.setSizePolicy(sizePolicy)
        self.cb_length_class.setMinimumSize(QtCore.QSize(130, 25))
        self.cb_length_class.setObjectName("cb_length_class")
        self.horizontalLayout_2.addWidget(self.cb_length_class)
        spacerItem3 = QtWidgets.QSpacerItem(28, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout_2.addItem(spacerItem3)
        self.verticalLayout.addLayout(self.horizontalLayout_2)
        spacerItem4 = QtWidgets.QSpacerItem(20, 13, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Fixed)
        self.verticalLayout.addItem(spacerItem4)
        self.horizontalLayout_3.addLayout(self.verticalLayout)
        self.verticalLayout_2.addLayout(self.horizontalLayout_3)
        self.tv_single = SingleTableView(frm_single)
        self.tv_single.setObjectName("tv_single")
        self.verticalLayout_2.addWidget(self.tv_single)
        self.horizontalLayout = QtWidgets.QHBoxLayout()
        self.horizontalLayout.setObjectName("horizontalLayout")
        spacerItem5 = QtWidgets.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout.addItem(spacerItem5)
        self.btn_save = QtWidgets.QPushButton(frm_single)
        self.btn_save.setObjectName("btn_save")
        self.horizontalLayout.addWidget(self.btn_save)
        self.verticalLayout_2.addLayout(self.horizontalLayout)

        self.retranslateUi(frm_single)
        QtCore.QMetaObject.connectSlotsByName(frm_single)
        frm_single.setTabOrder(self.cb_fishCategory, self.cb_length_class)
        frm_single.setTabOrder(self.cb_length_class, self.tv_single)
        frm_single.setTabOrder(self.tv_single, self.btn_save)

    def retranslateUi(self, frm_single):
        _translate = QtCore.QCoreApplication.translate
        frm_single.setWindowTitle(_translate("frm_single", "Form"))
        self.label.setText(_translate("frm_single", "Category"))
        self.label_2.setText(_translate("frm_single", "Laenge"))
        self.btn_save.setText(_translate("frm_single", "Speichern"))
from singletableview import SingleTableView
from wgt_species_chooser_code import Wgt_Species_Chooser
