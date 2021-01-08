from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *

import dlg_cruise_select

from reference import Reference as ref


class CruisesTableModel(QAbstractTableModel):

    def __init__(self):
        super(CruisesTableModel, self).__init__()
        
        cur = ref.connection.cursor()

        sql_cols = "SELECT column_name FROM INFORMATION_SCHEMA.columns WHERE TABLE_NAME = 'trip';"
        sql_data = "SELECT * FROM com_new_final.trip;"
        
        cur.execute(sql_cols)
        header = cur.fetchall()
        header = header[1:11]
        self.header = [i[0] for i in header]

        cur.execute(sql_data)
        trip_record = cur.fetchall()
        
        self.id = []
        for i in trip_record:
            self.id.append(i[0])
        
        self.__data = []
        for i in trip_record:
            rowdata = []
            for j in range(1, 11):
                rowdata.append(str(i[j]))
            rowdata = tuple(rowdata)
            self.__data.append(rowdata)
        
        cur.close()

    def rowCount(self, index=QModelIndex()):
        return len(self.__data)

    def columnCount(self, index=QModelIndex()):
        return len(self.header)

    def headerData(self, section, orientation, role=Qt.DisplayRole):
        if role != Qt.DisplayRole:
            return None
        
        if orientation == Qt.Horizontal:
            return self.header[section]
        
        return int(section+1)

    def data(self, index, role = Qt.DisplayRole):
        if not (0 <= index.row() < len(self.__data)) or index.column() >= len(self.header):
            return None

        data_row = self.__data[index.row()]
        column = index.column()
        
        if role == Qt.DisplayRole or role == Qt.EditRole:
            return data_row[column]

        return None
    
    def uid(self, index):
        return self.id[index.row()]

class SearchCruisesTableModel(QSortFilterProxyModel):
    
    def __init__(self, parent=None):
        super().__init__(parent)

class dlg_Cruise_Select(QDialog, dlg_cruise_select.Ui_dlg_cruise_select):

    def __init__(self, parent=None):
        super(dlg_Cruise_Select, self).__init__(parent)
        self.setupUi(self)
        
        self.proxy_model = SearchCruisesTableModel()
        self.cruise_model = CruisesTableModel()
        self.proxy_model.setSourceModel(self.cruise_model)
        self.tv_cruises.setModel(self.proxy_model)
        
        self.tv_cruises.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.tv_cruises.selectionModel().currentRowChanged.connect(self.cruise_selected)

        self.btn_search.clicked.connect(self.btn_search_clicked)
        self.btn_select.clicked.connect(self.btn_select_clicked)
    
    def btn_search_clicked(self):
        self.proxy_model.layoutAboutToBeChanged.emit()
        
        self.year = self.frm_cruise.edit_jahr.text()
        self.cruise_num = self.frm_cruise.edit_cruisenum.text()
        self.cruise_type = self.frm_cruise.edit_cruisetype.text()
        self.EU_num = self.frm_cruise.edit_eunum.text()
        self.ship_name = self.frm_cruise.edit_shipname.text()
        self.ship_sign = self.frm_cruise.edit_shipsign.text()
        
        self.startdate = self.frm_cruise.date_start.text()
        self.enddate = self.frm_cruise.date_end.text()
        self.starthafen = self.frm_cruise.cb_HarbourStart.itemText(self.frm_cruise.cb_HarbourStart.currentIndex())
        self.endhafen = self.frm_cruise.cb_HarbourEnd.itemText(self.frm_cruise.cb_HarbourEnd.currentIndex())
        
        self.beprober = self.frm_cruise.cb_leader.itemText(self.frm_cruise.cb_leader.currentIndex())
        
        self.proxy_model.setFilterRegExp(self.year)
        
        self.proxy_model.layoutChanged.emit()

    def btn_select_clicked(self):
        self.cruise_uid = self.uid
        self.done(0)

    def cruise_selected(self, current):
        self.uid = self.cruise_model.uid(current)
