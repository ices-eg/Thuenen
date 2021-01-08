# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'wgt_species_chooser.ui'
#
# Created by: PyQt5 UI code generator 5.12.3
#
# WARNING! All changes made in this file will be lost!


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_wgt_Species_Chooser(object):
    def setupUi(self, wgt_Species_Chooser):
        wgt_Species_Chooser.setObjectName("wgt_Species_Chooser")
        wgt_Species_Chooser.resize(573, 33)
        self.horizontalLayout = QtWidgets.QHBoxLayout(wgt_Species_Chooser)
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.label = QtWidgets.QLabel(wgt_Species_Chooser)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.label.sizePolicy().hasHeightForWidth())
        self.label.setSizePolicy(sizePolicy)
        self.label.setMinimumSize(QtCore.QSize(80, 20))
        self.label.setAlignment(QtCore.Qt.AlignLeading|QtCore.Qt.AlignLeft|QtCore.Qt.AlignVCenter)
        self.label.setObjectName("label")
        self.horizontalLayout.addWidget(self.label)
        self.cb_latin = QtWidgets.QComboBox(wgt_Species_Chooser)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.cb_latin.sizePolicy().hasHeightForWidth())
        self.cb_latin.setSizePolicy(sizePolicy)
        self.cb_latin.setMinimumSize(QtCore.QSize(110, 20))
        self.cb_latin.setEditable(True)
        self.cb_latin.setObjectName("cb_latin")
        self.horizontalLayout.addWidget(self.cb_latin)
        spacerItem = QtWidgets.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout.addItem(spacerItem)
        self.edit_aphiaid = QtWidgets.QLineEdit(wgt_Species_Chooser)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.edit_aphiaid.sizePolicy().hasHeightForWidth())
        self.edit_aphiaid.setSizePolicy(sizePolicy)
        self.edit_aphiaid.setMinimumSize(QtCore.QSize(110, 18))
        self.edit_aphiaid.setObjectName("edit_aphiaid")
        self.horizontalLayout.addWidget(self.edit_aphiaid)
        spacerItem1 = QtWidgets.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout.addItem(spacerItem1)
        self.edit_latin = QtWidgets.QLineEdit(wgt_Species_Chooser)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.edit_latin.sizePolicy().hasHeightForWidth())
        self.edit_latin.setSizePolicy(sizePolicy)
        self.edit_latin.setMinimumSize(QtCore.QSize(185, 18))
        self.edit_latin.setObjectName("edit_latin")
        self.horizontalLayout.addWidget(self.edit_latin)

        self.retranslateUi(wgt_Species_Chooser)
        QtCore.QMetaObject.connectSlotsByName(wgt_Species_Chooser)

    def retranslateUi(self, wgt_Species_Chooser):
        _translate = QtCore.QCoreApplication.translate
        wgt_Species_Chooser.setWindowTitle(_translate("wgt_Species_Chooser", "Form"))
        self.label.setText(_translate("wgt_Species_Chooser", "Fischart"))
