# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'dlg_server_connect.ui'
#
# Created by: PyQt5 UI code generator 5.12.3
#
# WARNING! All changes made in this file will be lost!


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_dlg_ServerConnect(object):
    def setupUi(self, dlg_ServerConnect):
        dlg_ServerConnect.setObjectName("dlg_ServerConnect")
        dlg_ServerConnect.resize(457, 237)
        self.gridLayout = QtWidgets.QGridLayout(dlg_ServerConnect)
        self.gridLayout.setObjectName("gridLayout")
        self.lv_cfg = QtWidgets.QListView(dlg_ServerConnect)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Expanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.lv_cfg.sizePolicy().hasHeightForWidth())
        self.lv_cfg.setSizePolicy(sizePolicy)
        self.lv_cfg.setMinimumSize(QtCore.QSize(140, 0))
        self.lv_cfg.setMaximumSize(QtCore.QSize(140, 16777215))
        self.lv_cfg.setObjectName("lv_cfg")
        self.gridLayout.addWidget(self.lv_cfg, 0, 0, 1, 1)
        self.formLayout = QtWidgets.QFormLayout()
        self.formLayout.setObjectName("formLayout")
        self.label = QtWidgets.QLabel(dlg_ServerConnect)
        self.label.setObjectName("label")
        self.formLayout.setWidget(0, QtWidgets.QFormLayout.LabelRole, self.label)
        self.edt_name = QtWidgets.QLineEdit(dlg_ServerConnect)
        self.edt_name.setObjectName("edt_name")
        self.formLayout.setWidget(0, QtWidgets.QFormLayout.FieldRole, self.edt_name)
        self.label_2 = QtWidgets.QLabel(dlg_ServerConnect)
        self.label_2.setObjectName("label_2")
        self.formLayout.setWidget(1, QtWidgets.QFormLayout.LabelRole, self.label_2)
        self.edt_host = QtWidgets.QLineEdit(dlg_ServerConnect)
        self.edt_host.setObjectName("edt_host")
        self.formLayout.setWidget(1, QtWidgets.QFormLayout.FieldRole, self.edt_host)
        self.label_3 = QtWidgets.QLabel(dlg_ServerConnect)
        self.label_3.setObjectName("label_3")
        self.formLayout.setWidget(2, QtWidgets.QFormLayout.LabelRole, self.label_3)
        self.edt_port = QtWidgets.QLineEdit(dlg_ServerConnect)
        self.edt_port.setObjectName("edt_port")
        self.formLayout.setWidget(2, QtWidgets.QFormLayout.FieldRole, self.edt_port)
        self.label_4 = QtWidgets.QLabel(dlg_ServerConnect)
        self.label_4.setObjectName("label_4")
        self.formLayout.setWidget(3, QtWidgets.QFormLayout.LabelRole, self.label_4)
        self.edt_schema = QtWidgets.QLineEdit(dlg_ServerConnect)
        self.edt_schema.setObjectName("edt_schema")
        self.formLayout.setWidget(3, QtWidgets.QFormLayout.FieldRole, self.edt_schema)
        self.label_5 = QtWidgets.QLabel(dlg_ServerConnect)
        self.label_5.setObjectName("label_5")
        self.formLayout.setWidget(4, QtWidgets.QFormLayout.LabelRole, self.label_5)
        self.edt_user = QtWidgets.QLineEdit(dlg_ServerConnect)
        self.edt_user.setObjectName("edt_user")
        self.formLayout.setWidget(4, QtWidgets.QFormLayout.FieldRole, self.edt_user)
        self.label_6 = QtWidgets.QLabel(dlg_ServerConnect)
        self.label_6.setObjectName("label_6")
        self.formLayout.setWidget(5, QtWidgets.QFormLayout.LabelRole, self.label_6)
        self.edt_password = QtWidgets.QLineEdit(dlg_ServerConnect)
        self.edt_password.setObjectName("edt_password")
        self.formLayout.setWidget(5, QtWidgets.QFormLayout.FieldRole, self.edt_password)
        self.gridLayout.addLayout(self.formLayout, 0, 1, 1, 2)
        spacerItem = QtWidgets.QSpacerItem(204, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.gridLayout.addItem(spacerItem, 1, 1, 1, 1)
        self.btn_connect = QtWidgets.QPushButton(dlg_ServerConnect)
        self.btn_connect.setObjectName("btn_connect")
        self.gridLayout.addWidget(self.btn_connect, 1, 2, 1, 1)

        self.retranslateUi(dlg_ServerConnect)
        QtCore.QMetaObject.connectSlotsByName(dlg_ServerConnect)
        dlg_ServerConnect.setTabOrder(self.lv_cfg, self.edt_name)
        dlg_ServerConnect.setTabOrder(self.edt_name, self.edt_host)
        dlg_ServerConnect.setTabOrder(self.edt_host, self.edt_port)
        dlg_ServerConnect.setTabOrder(self.edt_port, self.edt_schema)
        dlg_ServerConnect.setTabOrder(self.edt_schema, self.edt_user)
        dlg_ServerConnect.setTabOrder(self.edt_user, self.edt_password)
        dlg_ServerConnect.setTabOrder(self.edt_password, self.btn_connect)

    def retranslateUi(self, dlg_ServerConnect):
        _translate = QtCore.QCoreApplication.translate
        dlg_ServerConnect.setWindowTitle(_translate("dlg_ServerConnect", "Server Verbindung"))
        self.label.setText(_translate("dlg_ServerConnect", "Name:"))
        self.label_2.setText(_translate("dlg_ServerConnect", "Server:"))
        self.label_3.setText(_translate("dlg_ServerConnect", "Port:"))
        self.label_4.setText(_translate("dlg_ServerConnect", "Schema:"))
        self.label_5.setText(_translate("dlg_ServerConnect", "Benutzer"))
        self.label_6.setText(_translate("dlg_ServerConnect", "Passwort"))
        self.btn_connect.setText(_translate("dlg_ServerConnect", "Verbinden"))
