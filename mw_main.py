# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'mw_main.ui'
#
# Created by: PyQt5 UI code generator 5.12.3
#
# WARNING! All changes made in this file will be lost!


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_mw_Main(object):
    def setupUi(self, mw_Main):
        mw_Main.setObjectName("mw_Main")
        mw_Main.resize(880, 750)
        self.centralwidget = QtWidgets.QWidget(mw_Main)
        self.centralwidget.setObjectName("centralwidget")
        self.gridLayout = QtWidgets.QGridLayout(self.centralwidget)
        self.gridLayout.setObjectName("gridLayout")
        self.verticalLayout = QtWidgets.QVBoxLayout()
        self.verticalLayout.setObjectName("verticalLayout")
        self.activity_bar = Wgt_Activity_Bar(self.centralwidget)
        self.activity_bar.setMinimumSize(QtCore.QSize(0, 30))
        self.activity_bar.setMaximumSize(QtCore.QSize(240, 50))
        self.activity_bar.setObjectName("activity_bar")
        self.verticalLayout.addWidget(self.activity_bar)
        self.tv_activity = QtWidgets.QListWidget(self.centralwidget)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Expanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.tv_activity.sizePolicy().hasHeightForWidth())
        self.tv_activity.setSizePolicy(sizePolicy)
        self.tv_activity.setObjectName("tv_activity")
        self.verticalLayout.addWidget(self.tv_activity)
        self.gridLayout.addLayout(self.verticalLayout, 0, 0, 1, 1)
        self.tw_main = QtWidgets.QTabWidget(self.centralwidget)
        self.tw_main.setObjectName("tw_main")
        self.tab_station = Frm_Station()
        self.tab_station.setObjectName("tab_station")
        self.tw_main.addTab(self.tab_station, "")
        self.tab_gear = Frm_Gear()
        self.tab_gear.setObjectName("tab_gear")
        self.tw_main.addTab(self.tab_gear, "")
        self.tab_samples = Frm_Length()
        self.tab_samples.setObjectName("tab_samples")
        self.tw_main.addTab(self.tab_samples, "")
        self.tab_single = Frm_Single()
        self.tab_single.setObjectName("tab_single")
        self.tw_main.addTab(self.tab_single, "")
        self.gridLayout.addWidget(self.tw_main, 0, 1, 1, 1)
        mw_Main.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(mw_Main)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 880, 18))
        self.menubar.setObjectName("menubar")
        self.menuDatei = QtWidgets.QMenu(self.menubar)
        self.menuDatei.setObjectName("menuDatei")
        mw_Main.setMenuBar(self.menubar)
        self.statusbar = QtWidgets.QStatusBar(mw_Main)
        self.statusbar.setObjectName("statusbar")
        mw_Main.setStatusBar(self.statusbar)
        self.actionConnectServer = QtWidgets.QAction(mw_Main)
        self.actionConnectServer.setObjectName("actionConnectServer")
        self.actionChooseCruise = QtWidgets.QAction(mw_Main)
        self.actionChooseCruise.setObjectName("actionChooseCruise")
        self.actionNewCruise = QtWidgets.QAction(mw_Main)
        self.actionNewCruise.setObjectName("actionNewCruise")
        self.actionSingleProtocol = QtWidgets.QAction(mw_Main)
        self.actionSingleProtocol.setObjectName("actionSingleProtocol")
        self.menuDatei.addAction(self.actionConnectServer)
        self.menuDatei.addAction(self.actionChooseCruise)
        self.menuDatei.addAction(self.actionNewCruise)
        self.menubar.addAction(self.menuDatei.menuAction())

        self.retranslateUi(mw_Main)
        self.tw_main.setCurrentIndex(2)
        QtCore.QMetaObject.connectSlotsByName(mw_Main)

    def retranslateUi(self, mw_Main):
        _translate = QtCore.QCoreApplication.translate
        mw_Main.setWindowTitle(_translate("mw_Main", "FishInput"))
        self.tw_main.setTabText(self.tw_main.indexOf(self.tab_station), _translate("mw_Main", "Station"))
        self.tw_main.setTabText(self.tw_main.indexOf(self.tab_gear), _translate("mw_Main", "Gears"))
        self.tw_main.setTabText(self.tw_main.indexOf(self.tab_samples), _translate("mw_Main", "Proben"))
        self.tw_main.setTabText(self.tw_main.indexOf(self.tab_single), _translate("mw_Main", "Einzelfischdaten"))
        self.menuDatei.setTitle(_translate("mw_Main", "Datei"))
        self.actionConnectServer.setText(_translate("mw_Main", "Zu Server verbinden ..."))
        self.actionChooseCruise.setText(_translate("mw_Main", "Reise auswählen"))
        self.actionNewCruise.setText(_translate("mw_Main", "Neue Reise anlegen"))
        self.actionSingleProtocol.setText(_translate("mw_Main", "Einzelfischprotokoll"))
from frm_gear_code import Frm_Gear
from frm_length_code import Frm_Length
from frm_single_code import Frm_Single
from frm_station_code import Frm_Station
from wgt_activity_bar_code import Wgt_Activity_Bar
