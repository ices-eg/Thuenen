# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'frm_length.ui'
#
# Created by: PyQt5 UI code generator 5.12.3
#
# WARNING! All changes made in this file will be lost!


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_frm_length(object):
    def setupUi(self, frm_length):
        frm_length.setObjectName("frm_length")
        frm_length.resize(610, 613)
        self.verticalLayout = QtWidgets.QVBoxLayout(frm_length)
        self.verticalLayout.setObjectName("verticalLayout")
        self.horizontalLayout_2 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_2.setObjectName("horizontalLayout_2")
        self.wgt_species = Wgt_Species_Chooser(frm_length)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.wgt_species.sizePolicy().hasHeightForWidth())
        self.wgt_species.setSizePolicy(sizePolicy)
        self.wgt_species.setObjectName("wgt_species")
        self.horizontalLayout_2.addWidget(self.wgt_species)
        self.gridLayout_3 = QtWidgets.QGridLayout()
        self.gridLayout_3.setObjectName("gridLayout_3")
        spacerItem = QtWidgets.QSpacerItem(20, 13, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Fixed)
        self.gridLayout_3.addItem(spacerItem, 0, 2, 1, 1)
        spacerItem1 = QtWidgets.QSpacerItem(55, 13, QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Minimum)
        self.gridLayout_3.addItem(spacerItem1, 1, 0, 1, 1)
        self.label_7 = QtWidgets.QLabel(frm_length)
        self.label_7.setMinimumSize(QtCore.QSize(85, 0))
        self.label_7.setObjectName("label_7")
        self.gridLayout_3.addWidget(self.label_7, 1, 1, 1, 1)
        self.cb_fishCategory = QtWidgets.QComboBox(frm_length)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.cb_fishCategory.sizePolicy().hasHeightForWidth())
        self.cb_fishCategory.setSizePolicy(sizePolicy)
        self.cb_fishCategory.setMinimumSize(QtCore.QSize(140, 25))
        self.cb_fishCategory.setObjectName("cb_fishCategory")
        self.gridLayout_3.addWidget(self.cb_fishCategory, 1, 2, 1, 1)
        spacerItem2 = QtWidgets.QSpacerItem(55, 13, QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Minimum)
        self.gridLayout_3.addItem(spacerItem2, 1, 3, 1, 1)
        spacerItem3 = QtWidgets.QSpacerItem(20, 13, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Fixed)
        self.gridLayout_3.addItem(spacerItem3, 2, 2, 1, 1)
        self.horizontalLayout_2.addLayout(self.gridLayout_3)
        self.verticalLayout.addLayout(self.horizontalLayout_2)
        spacerItem4 = QtWidgets.QSpacerItem(13, 5, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Fixed)
        self.verticalLayout.addItem(spacerItem4)
        self.gridLayout = QtWidgets.QGridLayout()
        self.gridLayout.setObjectName("gridLayout")
        self.label_1 = QtWidgets.QLabel(frm_length)
        self.label_1.setObjectName("label_1")
        self.gridLayout.addWidget(self.label_1, 0, 0, 1, 1)
        spacerItem5 = QtWidgets.QSpacerItem(5, 30, QtWidgets.QSizePolicy.MinimumExpanding, QtWidgets.QSizePolicy.Minimum)
        self.gridLayout.addItem(spacerItem5, 0, 1, 2, 1)
        self.label_2 = QtWidgets.QLabel(frm_length)
        self.label_2.setObjectName("label_2")
        self.gridLayout.addWidget(self.label_2, 0, 2, 1, 1)
        spacerItem6 = QtWidgets.QSpacerItem(5, 30, QtWidgets.QSizePolicy.MinimumExpanding, QtWidgets.QSizePolicy.Minimum)
        self.gridLayout.addItem(spacerItem6, 0, 3, 2, 1)
        self.label_3 = QtWidgets.QLabel(frm_length)
        self.label_3.setObjectName("label_3")
        self.gridLayout.addWidget(self.label_3, 0, 4, 1, 1)
        spacerItem7 = QtWidgets.QSpacerItem(5, 30, QtWidgets.QSizePolicy.MinimumExpanding, QtWidgets.QSizePolicy.Minimum)
        self.gridLayout.addItem(spacerItem7, 0, 5, 2, 1)
        self.label_6 = QtWidgets.QLabel(frm_length)
        self.label_6.setObjectName("label_6")
        self.gridLayout.addWidget(self.label_6, 0, 6, 1, 1)
        spacerItem8 = QtWidgets.QSpacerItem(5, 30, QtWidgets.QSizePolicy.MinimumExpanding, QtWidgets.QSizePolicy.Minimum)
        self.gridLayout.addItem(spacerItem8, 0, 7, 2, 1)
        self.label_4 = QtWidgets.QLabel(frm_length)
        self.label_4.setObjectName("label_4")
        self.gridLayout.addWidget(self.label_4, 0, 8, 1, 1)
        spacerItem9 = QtWidgets.QSpacerItem(5, 30, QtWidgets.QSizePolicy.MinimumExpanding, QtWidgets.QSizePolicy.Minimum)
        self.gridLayout.addItem(spacerItem9, 0, 9, 2, 1)
        self.label_8 = QtWidgets.QLabel(frm_length)
        self.label_8.setObjectName("label_8")
        self.gridLayout.addWidget(self.label_8, 0, 10, 1, 1)
        spacerItem10 = QtWidgets.QSpacerItem(5, 30, QtWidgets.QSizePolicy.MinimumExpanding, QtWidgets.QSizePolicy.Minimum)
        self.gridLayout.addItem(spacerItem10, 0, 11, 2, 1)
        self.sb_weight_all = QtWidgets.QDoubleSpinBox(frm_length)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.sb_weight_all.sizePolicy().hasHeightForWidth())
        self.sb_weight_all.setSizePolicy(sizePolicy)
        self.sb_weight_all.setMinimumSize(QtCore.QSize(80, 25))
        self.sb_weight_all.setDecimals(4)
        self.sb_weight_all.setMaximum(999999999.0)
        self.sb_weight_all.setObjectName("sb_weight_all")
        self.gridLayout.addWidget(self.sb_weight_all, 1, 0, 1, 1)
        self.sb_number_all = QtWidgets.QSpinBox(frm_length)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.sb_number_all.sizePolicy().hasHeightForWidth())
        self.sb_number_all.setSizePolicy(sizePolicy)
        self.sb_number_all.setMinimumSize(QtCore.QSize(65, 25))
        self.sb_number_all.setMaximum(999999999)
        self.sb_number_all.setObjectName("sb_number_all")
        self.gridLayout.addWidget(self.sb_number_all, 1, 2, 1, 1)
        self.sb_weight_sample = QtWidgets.QDoubleSpinBox(frm_length)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.sb_weight_sample.sizePolicy().hasHeightForWidth())
        self.sb_weight_sample.setSizePolicy(sizePolicy)
        self.sb_weight_sample.setMinimumSize(QtCore.QSize(80, 25))
        self.sb_weight_sample.setDecimals(4)
        self.sb_weight_sample.setMaximum(9999.99)
        self.sb_weight_sample.setObjectName("sb_weight_sample")
        self.gridLayout.addWidget(self.sb_weight_sample, 1, 4, 1, 1)
        self.sb_number_sample = QtWidgets.QSpinBox(frm_length)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.sb_number_sample.sizePolicy().hasHeightForWidth())
        self.sb_number_sample.setSizePolicy(sizePolicy)
        self.sb_number_sample.setMinimumSize(QtCore.QSize(65, 25))
        self.sb_number_sample.setMaximum(99999)
        self.sb_number_sample.setObjectName("sb_number_sample")
        self.gridLayout.addWidget(self.sb_number_sample, 1, 6, 1, 1)
        self.cb_weightUnit = QtWidgets.QComboBox(frm_length)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.cb_weightUnit.sizePolicy().hasHeightForWidth())
        self.cb_weightUnit.setSizePolicy(sizePolicy)
        self.cb_weightUnit.setMinimumSize(QtCore.QSize(80, 25))
        self.cb_weightUnit.setObjectName("cb_weightUnit")
        self.gridLayout.addWidget(self.cb_weightUnit, 1, 8, 1, 1)
        self.cb_lengthUnit = QtWidgets.QComboBox(frm_length)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.cb_lengthUnit.sizePolicy().hasHeightForWidth())
        self.cb_lengthUnit.setSizePolicy(sizePolicy)
        self.cb_lengthUnit.setMinimumSize(QtCore.QSize(80, 25))
        self.cb_lengthUnit.setObjectName("cb_lengthUnit")
        self.gridLayout.addWidget(self.cb_lengthUnit, 1, 10, 1, 1)
        self.btn_save1 = QtWidgets.QPushButton(frm_length)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.btn_save1.sizePolicy().hasHeightForWidth())
        self.btn_save1.setSizePolicy(sizePolicy)
        self.btn_save1.setMinimumSize(QtCore.QSize(0, 25))
        self.btn_save1.setObjectName("btn_save1")
        self.gridLayout.addWidget(self.btn_save1, 1, 12, 1, 1)
        self.verticalLayout.addLayout(self.gridLayout)
        spacerItem11 = QtWidgets.QSpacerItem(20, 20, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Fixed)
        self.verticalLayout.addItem(spacerItem11)
        self.tv_weight = QtWidgets.QTableView(frm_length)
        self.tv_weight.setObjectName("tv_weight")
        self.verticalLayout.addWidget(self.tv_weight)
        spacerItem12 = QtWidgets.QSpacerItem(20, 20, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Fixed)
        self.verticalLayout.addItem(spacerItem12)
        self.horizontalLayout = QtWidgets.QHBoxLayout()
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.tv_length = QtWidgets.QTableView(frm_length)
        self.tv_length.setObjectName("tv_length")
        self.horizontalLayout.addWidget(self.tv_length)
        spacerItem13 = QtWidgets.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout.addItem(spacerItem13)
        self.gridLayout_2 = QtWidgets.QGridLayout()
        self.gridLayout_2.setObjectName("gridLayout_2")
        spacerItem14 = QtWidgets.QSpacerItem(20, 40, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Expanding)
        self.gridLayout_2.addItem(spacerItem14, 0, 1, 1, 1)
        self.label_10 = QtWidgets.QLabel(frm_length)
        self.label_10.setObjectName("label_10")
        self.gridLayout_2.addWidget(self.label_10, 1, 0, 1, 1)
        self.sb_length_weight = QtWidgets.QDoubleSpinBox(frm_length)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.sb_length_weight.sizePolicy().hasHeightForWidth())
        self.sb_length_weight.setSizePolicy(sizePolicy)
        self.sb_length_weight.setMinimumSize(QtCore.QSize(95, 25))
        self.sb_length_weight.setMaximum(9999.99)
        self.sb_length_weight.setObjectName("sb_length_weight")
        self.gridLayout_2.addWidget(self.sb_length_weight, 1, 1, 1, 1)
        self.label_5 = QtWidgets.QLabel(frm_length)
        self.label_5.setObjectName("label_5")
        self.gridLayout_2.addWidget(self.label_5, 2, 0, 1, 1)
        self.sb_number = QtWidgets.QSpinBox(frm_length)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.sb_number.sizePolicy().hasHeightForWidth())
        self.sb_number.setSizePolicy(sizePolicy)
        self.sb_number.setMinimumSize(QtCore.QSize(95, 25))
        self.sb_number.setMaximum(99999)
        self.sb_number.setObjectName("sb_number")
        self.gridLayout_2.addWidget(self.sb_number, 2, 1, 1, 1)
        spacerItem15 = QtWidgets.QSpacerItem(20, 40, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Expanding)
        self.gridLayout_2.addItem(spacerItem15, 3, 1, 1, 1)
        self.btn_save2 = QtWidgets.QPushButton(frm_length)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.btn_save2.sizePolicy().hasHeightForWidth())
        self.btn_save2.setSizePolicy(sizePolicy)
        self.btn_save2.setMinimumSize(QtCore.QSize(80, 25))
        self.btn_save2.setObjectName("btn_save2")
        self.gridLayout_2.addWidget(self.btn_save2, 4, 0, 1, 1)
        spacerItem16 = QtWidgets.QSpacerItem(20, 40, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Expanding)
        self.gridLayout_2.addItem(spacerItem16, 5, 1, 1, 1)
        self.horizontalLayout.addLayout(self.gridLayout_2)
        spacerItem17 = QtWidgets.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout.addItem(spacerItem17)
        self.verticalLayout.addLayout(self.horizontalLayout)

        self.retranslateUi(frm_length)
        QtCore.QMetaObject.connectSlotsByName(frm_length)
        frm_length.setTabOrder(self.cb_fishCategory, self.sb_weight_all)
        frm_length.setTabOrder(self.sb_weight_all, self.sb_number_all)
        frm_length.setTabOrder(self.sb_number_all, self.sb_weight_sample)
        frm_length.setTabOrder(self.sb_weight_sample, self.sb_number_sample)
        frm_length.setTabOrder(self.sb_number_sample, self.cb_weightUnit)
        frm_length.setTabOrder(self.cb_weightUnit, self.cb_lengthUnit)
        frm_length.setTabOrder(self.cb_lengthUnit, self.btn_save1)
        frm_length.setTabOrder(self.btn_save1, self.tv_weight)
        frm_length.setTabOrder(self.tv_weight, self.tv_length)
        frm_length.setTabOrder(self.tv_length, self.sb_length_weight)
        frm_length.setTabOrder(self.sb_length_weight, self.sb_number)
        frm_length.setTabOrder(self.sb_number, self.btn_save2)

    def retranslateUi(self, frm_length):
        _translate = QtCore.QCoreApplication.translate
        frm_length.setWindowTitle(_translate("frm_length", "Form"))
        self.label_7.setText(_translate("frm_length", "Category"))
        self.label_1.setText(_translate("frm_length", "Gesamtfang Art"))
        self.label_2.setText(_translate("frm_length", "Anzahl"))
        self.label_3.setText(_translate("frm_length", "Unterprobengewicht"))
        self.label_6.setText(_translate("frm_length", "Anzahl"))
        self.label_4.setText(_translate("frm_length", "Gewicht unit"))
        self.label_8.setText(_translate("frm_length", "Länge unit"))
        self.btn_save1.setText(_translate("frm_length", "Speichern"))
        self.label_10.setText(_translate("frm_length", "Länge"))
        self.label_5.setText(_translate("frm_length", "Anzahl"))
        self.btn_save2.setText(_translate("frm_length", "Speichern"))
from wgt_species_chooser_code import Wgt_Species_Chooser
