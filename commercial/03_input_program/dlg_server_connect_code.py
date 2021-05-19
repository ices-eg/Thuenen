from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
import configparser

import dlg_server_connect
import psycopg2 as pg


class ServerListModel(QAbstractListModel):
    """
    Serverliste - nimmt Daten aus serverlist.ini
    """
    
    def __init__(self):

        super(ServerListModel, self).__init__()
        self.cfg = configparser.ConfigParser()
        self.cfg.read('serverlist.ini')

        self.servers = []
        self.servers.extend(self.cfg.sections())

    def rowCount(self, index=QModelIndex()):
        return len(self.servers)

    def data(self, index, role=Qt.DisplayRole):
        if not index.isValid():
            return None

        if role == Qt.DisplayRole:
            return self.servers[index.row()]

        return None

    def get_cfg(self, section):
        return self.cfg[section]
    
    def connectionString(self,idx):
        server_cfg = self.cfg[self.servers[idx]]
        return server_cfg
    
    def schema(self, idx):
        return self.cfg[self.servers[idx]]['schema']


class Dlg_Server_Connect(QDialog, dlg_server_connect.Ui_dlg_ServerConnect):

    def __init__(self, parent=None):
        super(Dlg_Server_Connect, self).__init__(parent)
        self.setupUi(self)
        self.log = None

        self.cfg_model = ServerListModel()
        self.lv_cfg.setModel(self.cfg_model)
        self.lv_cfg.selectionModel().currentChanged.connect(self.lv_cfg_currentChanged)

        self.btn_connect.clicked.connect(self.btn_connect_clicked)

    def btn_connect_clicked(self):
        idx = self.lv_cfg.selectionModel().currentIndex().row()
        log = self.cfg_model.connectionString(idx)
        
        try:
            #self.log = pg.connect(user=log['user'], password=log['password'],
            #           host=log['server'], port=log['port'],
            #           dbname=log['database'],
            #           options='-c search_path=' + log['schema'])
            self.log = pg.connect(user=log['user'], password=log['password'],
                       host=log['server'], port=log['port'],
                       options='-c search_path=' + log['schema'])
            self.done(0)
        
        except:
            QMessageBox.warning(self, 'Fehler', 'Verbindung könnte nicht aufgebaut werden')
            return

    def lv_cfg_currentChanged(self, current, previous):
        cfg = self.cfg_model.get_cfg(self.cfg_model.data(current))
        self.edt_name.setText(self.cfg_model.data(current))
        self.edt_host.setText(cfg['server'])
        self.edt_port.setText(cfg['port'])
        self.edt_schema.setText(cfg['schema'])
        self.edt_user.setText(cfg['user'])
        self.edt_password.setText(cfg['password'])
