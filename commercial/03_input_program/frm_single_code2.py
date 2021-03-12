# -*- coding: utf-8 -*-
"""
Created on Thu Jan  7 15:35:03 2021

@author: hardadi
"""

from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *

import frm_single

#import account
from reference import Reference as ref


class SingleTableModel(QAbstractTableModel):

    def __init__(self, parent=None):
        super(SingleTableModel, self).__init__(parent)

        self.length_uid = ref.length_uid
        
        cur = ref.connection.cursor()
        
        sql_statement = """SELECT DISTINCT bi_index FROM com_new_final.sample_bio WHERE
        le_index = {}""".format(self.length_uid)
        cur.execute(sql_statement)
        bio_data = cur.fetchall()

        if bio_data != None:
            self.__data = [[] for i in range(len(bio_data))]
            for i in range(len(bio_data)):
                for j in range(2, 7):
                    self.__data[i].append(bio_data[i][j])

        self.header = ['Fisch ID', 'Parameter', 'Value', 'Unit', 'Comments']

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

    def data(self, index, role=Qt.DisplayRole):
        if not index.isValid() or not (0 <= index.row() < len(self.__data)) or index.column() >= len(self.header):
            return None

        data_row = self.__data[index.row()]
        column = index.column()

        if role == Qt.DisplayRole or role == Qt.EditRole:
            return data_row[column]
        
        return None

    def flags(self, index):
        return Qt.ItemFlags(QAbstractTableModel.flags(self, index)|Qt.ItemIsEditable)

    def setData(self, index, value, role=Qt.EditRole):
        if not index.isValid():
            return False

        if role == Qt.EditRole:
            self.__data[index.row()][index.column()] = value

            if index.row() >= (len(self.__data)-1):
                self.insertRows(index.row()+1, 1, data=[{}])
            self.dataChanged.emit(index, index)
            return True
        return False

    def insertRows(self, row, count, parent=QModelIndex(), data=[{}]):
        self.beginInsertRows(parent, row, row+count-1)
        for i, d in enumerate(data):
            print(d)
            d2 = d.copy()
            d2["id"] = None
            d2["dirty"] = True
            self.__data.insert(row+i, d2)
        self.endInsertRows()
        return True

    # def set_values(self, record, session):

    #     for prot_item in self.single_protocol:
    #         key = prot_item[0]
    #         table = prot_item[1]

    #         if key in record.keys():setattr(key, record[key])

    # def new_data(self, record, session):
    #     db_single = db.Single()
    #     db_new_station = session.query(db.Station).filter(db.Station.name == record["station"]).first()
    #     db_single.activity = db_new_station.hauls[0].activity
    #     db_single.weight = db_single.weight[:]
    #     db_single.weight.append(db_new_station.hauls[0].weight(self.species))

    #     self.set_values(record, db_single, session)

    #     session.add(db_single)

    # def update_data(self, record, session):

    #     db_single = session.query(db.Single).filter(db.Single.id == record["id"]).first()
    #     if db_single.activity.haul[0].station().name != record["station"]:
    #         # hänge station um
    #         db_new_station = session.query(db.Station).filter(db.Station.name == record["station"]).first()
    #         db_single.activity = db_new_station.hauls[0].activity
    #         db_single.weight = db_single.weight[:]
    #         db_single.weight.append(db_new_station.hauls[0].weight(self.species))

    #     self.set_values(record, db_single, session)

    #     session.add(db_single)

    # def save_data(self):
    #     session = db.session()

    #     for record in self.__data:
    #         if record != {'id': None, 'dirty': True}:
    #             # Datensatz bearbeitet
    #             if record["dirty"] is True:
    #                 # Datensatz ist neu
    #                 if record["id"] is None:
    #                     self.new_data(record, session)
    #                     record["dirty"] = False
    #                 else:
    #                     self.update_data(record, session)
    #                     record["dirty"] = False

    #     session.commit()
    #     session.close()

class Frm_Single(QWidget,frm_single.Ui_frm_single):

    def __init__(self,parent=None):
        super(Frm_Single, self).__init__(parent)
        self.setupUi(self)

        self.btn_save.clicked.connect(self.save_data)

        self.setEnabled(False)

    def set_data(self):
        self.cruise_uid = ref.cruise_uid
        
        self.wgt_species.set_data()
        self.species_selected()

        self.setEnabled(True)

    def species_selected(self):
        self.model = SingleTableModel()
        self.tv_single.horizontalHeader().set_context(self.model.header)
        self.tv_single.setModel(self.model)

    def save_data(self):
        if self.model is not None:
            self.model.save_data()