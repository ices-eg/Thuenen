# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'frm_station.ui'
#
# Created by: PyQt5 UI code generator 5.12.3
#
# WARNING! All changes made in this file will be lost!


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_frm_station(object):
    def setupUi(self, frm_station):
        frm_station.setObjectName("frm_station")
        frm_station.resize(576, 616)
        self.verticalLayout = QtWidgets.QVBoxLayout(frm_station)
        self.verticalLayout.setObjectName("verticalLayout")
        self.lb_cruise = QtWidgets.QLabel(frm_station)
        self.lb_cruise.setObjectName("lb_cruise")
        self.verticalLayout.addWidget(self.lb_cruise)
        self.gridLayout = QtWidgets.QGridLayout()
        self.gridLayout.setObjectName("gridLayout")
        self.label = QtWidgets.QLabel(frm_station)
        self.label.setObjectName("label")
        self.gridLayout.addWidget(self.label, 0, 0, 1, 1)
        self.label_2 = QtWidgets.QLabel(frm_station)
        self.label_2.setObjectName("label_2")
        self.gridLayout.addWidget(self.label_2, 0, 1, 1, 1)
        self.label_3 = QtWidgets.QLabel(frm_station)
        self.label_3.setObjectName("label_3")
        self.gridLayout.addWidget(self.label_3, 0, 2, 1, 1)
        self.label_4 = QtWidgets.QLabel(frm_station)
        self.label_4.setObjectName("label_4")
        self.gridLayout.addWidget(self.label_4, 0, 3, 1, 1)
        self.edt_jahr = QtWidgets.QLineEdit(frm_station)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.edt_jahr.sizePolicy().hasHeightForWidth())
        self.edt_jahr.setSizePolicy(sizePolicy)
        self.edt_jahr.setMinimumSize(QtCore.QSize(0, 22))
        self.edt_jahr.setObjectName("edt_jahr")
        self.gridLayout.addWidget(self.edt_jahr, 1, 0, 1, 1)
        self.edt_quartal = QtWidgets.QLineEdit(frm_station)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.edt_quartal.sizePolicy().hasHeightForWidth())
        self.edt_quartal.setSizePolicy(sizePolicy)
        self.edt_quartal.setMinimumSize(QtCore.QSize(0, 22))
        self.edt_quartal.setObjectName("edt_quartal")
        self.gridLayout.addWidget(self.edt_quartal, 1, 1, 1, 1)
        self.edt_monat = QtWidgets.QLineEdit(frm_station)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.edt_monat.sizePolicy().hasHeightForWidth())
        self.edt_monat.setSizePolicy(sizePolicy)
        self.edt_monat.setMinimumSize(QtCore.QSize(0, 22))
        self.edt_monat.setObjectName("edt_monat")
        self.gridLayout.addWidget(self.edt_monat, 1, 2, 1, 1)
        self.edt_haul_name = QtWidgets.QLineEdit(frm_station)
        self.edt_haul_name.setMinimumSize(QtCore.QSize(155, 22))
        self.edt_haul_name.setObjectName("edt_haul_name")
        self.gridLayout.addWidget(self.edt_haul_name, 1, 3, 1, 1)
        self.verticalLayout.addLayout(self.gridLayout)
        self.gridLayout_2 = QtWidgets.QGridLayout()
        self.gridLayout_2.setObjectName("gridLayout_2")
        self.label_5 = QtWidgets.QLabel(frm_station)
        self.label_5.setObjectName("label_5")
        self.gridLayout_2.addWidget(self.label_5, 0, 0, 1, 1)
        self.label_6 = QtWidgets.QLabel(frm_station)
        self.label_6.setObjectName("label_6")
        self.gridLayout_2.addWidget(self.label_6, 0, 1, 1, 1)
        self.label_7 = QtWidgets.QLabel(frm_station)
        self.label_7.setObjectName("label_7")
        self.gridLayout_2.addWidget(self.label_7, 0, 2, 1, 1)
        self.label_8 = QtWidgets.QLabel(frm_station)
        self.label_8.setObjectName("label_8")
        self.gridLayout_2.addWidget(self.label_8, 0, 3, 1, 1)
        self.label_11 = QtWidgets.QLabel(frm_station)
        self.label_11.setObjectName("label_11")
        self.gridLayout_2.addWidget(self.label_11, 0, 4, 1, 1)
        self.de_start = QtWidgets.QDateEdit(frm_station)
        self.de_start.setMinimumSize(QtCore.QSize(75, 22))
        self.de_start.setObjectName("de_start")
        self.gridLayout_2.addWidget(self.de_start, 1, 0, 1, 1)
        self.te_start = QtWidgets.QTimeEdit(frm_station)
        self.te_start.setMinimumSize(QtCore.QSize(50, 22))
        self.te_start.setObjectName("te_start")
        self.gridLayout_2.addWidget(self.te_start, 1, 1, 1, 1)
        self.de_end = QtWidgets.QDateEdit(frm_station)
        self.de_end.setMinimumSize(QtCore.QSize(75, 22))
        self.de_end.setObjectName("de_end")
        self.gridLayout_2.addWidget(self.de_end, 1, 2, 1, 1)
        self.te_end = QtWidgets.QTimeEdit(frm_station)
        self.te_end.setMinimumSize(QtCore.QSize(50, 22))
        self.te_end.setObjectName("te_end")
        self.gridLayout_2.addWidget(self.te_end, 1, 3, 1, 1)
        self.te_duration = QtWidgets.QTimeEdit(frm_station)
        self.te_duration.setMinimumSize(QtCore.QSize(50, 22))
        self.te_duration.setObjectName("te_duration")
        self.gridLayout_2.addWidget(self.te_duration, 1, 4, 1, 1)
        self.btn_save1 = QtWidgets.QPushButton(frm_station)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.btn_save1.sizePolicy().hasHeightForWidth())
        self.btn_save1.setSizePolicy(sizePolicy)
        self.btn_save1.setMinimumSize(QtCore.QSize(75, 22))
        self.btn_save1.setObjectName("btn_save1")
        self.gridLayout_2.addWidget(self.btn_save1, 1, 5, 1, 1)
        self.verticalLayout.addLayout(self.gridLayout_2)
        self.label_10 = QtWidgets.QLabel(frm_station)
        self.label_10.setObjectName("label_10")
        self.verticalLayout.addWidget(self.label_10)
        self.tv_coords = QtWidgets.QTableView(frm_station)
        self.tv_coords.setObjectName("tv_coords")
        self.verticalLayout.addWidget(self.tv_coords)
        self.horizontalLayout = QtWidgets.QHBoxLayout()
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.btn_add_coords = QtWidgets.QPushButton(frm_station)
        self.btn_add_coords.setObjectName("btn_add_coords")
        self.horizontalLayout.addWidget(self.btn_add_coords)
        spacerItem = QtWidgets.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout.addItem(spacerItem)
        self.verticalLayout.addLayout(self.horizontalLayout)
        self.widget = Frm_Weather(frm_station)
        self.widget.setMinimumSize(QtCore.QSize(0, 125))
        self.widget.setObjectName("widget")
        self.verticalLayout.addWidget(self.widget)
        self.label_9 = QtWidgets.QLabel(frm_station)
        self.label_9.setObjectName("label_9")
        self.verticalLayout.addWidget(self.label_9)
        self.pte_notation = QtWidgets.QPlainTextEdit(frm_station)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.pte_notation.sizePolicy().hasHeightForWidth())
        self.pte_notation.setSizePolicy(sizePolicy)
        self.pte_notation.setMinimumSize(QtCore.QSize(0, 70))
        self.pte_notation.setMaximumSize(QtCore.QSize(16777215, 100))
        self.pte_notation.setObjectName("pte_notation")
        self.verticalLayout.addWidget(self.pte_notation)
        self.horizontalLayout_3 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_3.setObjectName("horizontalLayout_3")
        spacerItem1 = QtWidgets.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout_3.addItem(spacerItem1)
        self.btn_save2 = QtWidgets.QPushButton(frm_station)
        self.btn_save2.setObjectName("btn_save2")
        self.horizontalLayout_3.addWidget(self.btn_save2)
        self.verticalLayout.addLayout(self.horizontalLayout_3)

        self.retranslateUi(frm_station)
        QtCore.QMetaObject.connectSlotsByName(frm_station)

    def retranslateUi(self, frm_station):
        _translate = QtCore.QCoreApplication.translate
        frm_station.setWindowTitle(_translate("frm_station", "Form"))
        self.lb_cruise.setText(_translate("frm_station", "<html><head/><body><p><span style=\" font-weight:600;\">Reise:</span> XX 999 | SURVEY | Dr Max Mustermann</p></body></html>"))
        self.label.setText(_translate("frm_station", "<html><head/><body><p><span style=\" font-weight:600;\">Jahr</span></p></body></html>"))
        self.label_2.setText(_translate("frm_station", "<html><head/><body><p><span style=\" font-weight:600;\">Quartal</span></p></body></html>"))
        self.label_3.setText(_translate("frm_station", "<html><head/><body><p><span style=\" font-weight:600;\">Monat</span></p></body></html>"))
        self.label_4.setText(_translate("frm_station", "<html><head/><body><p><span style=\" font-weight:600;\">Hol</span></p></body></html>"))
        self.label_5.setText(_translate("frm_station", "<html><head/><body><p><span style=\" font-weight:600;\">Startdatum</span></p></body></html>"))
        self.label_6.setText(_translate("frm_station", "<html><head/><body><p><span style=\" font-weight:600;\">Startzeit</span></p></body></html>"))
        self.label_7.setText(_translate("frm_station", "<html><head/><body><p><span style=\" font-weight:600;\">Enddatum</span></p></body></html>"))
        self.label_8.setText(_translate("frm_station", "<html><head/><body><p><span style=\" font-weight:600;\">Endzeit</span></p></body></html>"))
        self.label_11.setText(_translate("frm_station", "<html><head/><body><p><span style=\" font-weight:600;\">Dauert</span></p></body></html>"))
        self.de_start.setDisplayFormat(_translate("frm_station", "dd.MM.yyyy"))
        self.de_end.setDisplayFormat(_translate("frm_station", "dd.MM.yyyy"))
        self.btn_save1.setText(_translate("frm_station", "Speichern"))
        self.label_10.setText(_translate("frm_station", "<html><head/><body><p><span style=\" font-weight:600;\">Koordinaten</span></p></body></html>"))
        self.btn_add_coords.setText(_translate("frm_station", "Start/End Koordinaten hinzufügen"))
        self.label_9.setText(_translate("frm_station", "<html><head/><body><p><span style=\" font-weight:600;\">Bemerkungen</span></p></body></html>"))
        self.btn_save2.setText(_translate("frm_station", "Speichern"))
from frm_enviro_code import Frm_Weather
