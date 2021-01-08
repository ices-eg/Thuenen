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

    def __init__(self, cruise_uid, species=None, parent=None):
        super(SingleTableModel, self).__init__(parent)

        self.cruise_uid = cruise_uid
        self.species = species
        
        cur = ref.connection.cursor()
        
        sql_statement = """SELECT * FROM com_new_final.sample_bio WHERE
        bi_index = {}""".format(self.haul_uid)
        cur.execute(sql_statement)
        weight_data = cur.fetchall()

        if weight_data != None:
            self.__data = [[] for i in range(len(weight_data))]
            for i in range(len(weight_data)):
                for j in [2,5,6,7,8,9]:
                    self.__data[i].append(weight_data[i][j])

        self.header = ['Fischart', 'Category', 'Gesamtgewicht', 'Gesamtanzahl', 'UP Gewicht', 'UP Anzahl']

        cur.close()

        # db_cruise = session.query(db.Cruise).filter(db.Cruise.id == self.cruise_uid).first()

        # self.__data = [s.as_dict() for s in db_cruise.singles() if s.species() == species]

        # for s in self.__data:
        #     s["dirty"] = False

        # self.single_protocol = [[sp.name,sp.table] for sp in session.query(db.Single_Protocol).filter(db.Single_Protocol.species == int(species)).order_by(db.Single_Protocol.col_nr).all()]

        # translation = {r.english: r.german for r in session.query(db.Ui_Translation).all()}
        # self.header = [translation[item[0]] for item in self.single_protocol]

        # if len(self.__data) == 0:
        #     self.__data.append({"id": None, "dirty": False})

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
        k = self.single_protocol[index.column()][0]

        if role == Qt.DisplayRole or role == Qt.EditRole:
            if k in data_row.keys():
                return data_row[k]
            else:
                return None
        return None

    def flags(self, index):
        return Qt.ItemFlags(QAbstractTableModel.flags(self, index)|Qt.ItemIsEditable)

    def setData(self, index, value, role=Qt.EditRole):
        if not index.isValid():
            return False

        if role == Qt.EditRole:
            k = self.single_protocol[index.column()][0]
            self.__data[index.row()][k] = value
            self.__data[index.row()]["dirty"] = True

            if index.row() >= (len(self.__data)-1):
                self.insertRows(index.row()+1, 1, data=[{}])
            self.dataChanged.emit(index, index)
            print(self.__data)
            return True
        return False

    def insertRows(self, row, count, parent=QModelIndex(), data=[{}]):
        self.beginInsertRows(parent, row, row+count-1)
        for i, d in enumerate(data):
            d2 = d.copy()
            d2["id"] = None
            d2["dirty"] = True
            self.__data.insert(row+i, d2)
        self.endInsertRows()
        return True

    def handle_nutrition(self, record, key, db_single, session):

        (col, idx) = key.split('_')
        attr = ''
        if col == 'Item':
            attr = 'nutrition'
        elif col == 'perc':
            attr = 'percentage'

        if int(idx)-1 > len(db_single.nutritions)-1:
            nutri = db.Single_nutrition()
            db_single.nutritions.append(nutri)
            setattr(nutri, attr, record[key])
            session.add(nutri)
        else:
            setattr(db_single.nutritions[int(idx)-1], attr, record[key])

    def set_values(self, record, db_single, session):

        for prot_item in self.single_protocol:
            key = prot_item[0]
            table = prot_item[1]

            if key in record.keys():
                if table == 'single':
                    setattr(db_single, key, record[key])
                elif table == 'single_trait':
                    if key not in db_single.traits.keys():
                        db_param = session.query(db.Parameter).filter(db.Parameter.name == key).first()
                        new_trait = db.Single_Trait(parameter=db_param, value=record[key])
                        db_single.traits[key] = new_trait
                        session.add(new_trait)
                    else:
                        db_single.traits[key].value = record[key]
                elif table == 'single_nutrition':
                    self.handle_nutrition(record, key, db_single, session)

    def new_data(self, record, session):
        db_single = db.Single()
        db_new_station = session.query(db.Station).filter(db.Station.name == record["station"]).first()
        db_single.activity = db_new_station.hauls[0].activity
        db_single.weight = db_single.weight[:]
        db_single.weight.append(db_new_station.hauls[0].weight(self.species))

        self.set_values(record, db_single, session)

        session.add(db_single)

    def update_data(self, record, session):

        db_single = session.query(db.Single).filter(db.Single.id == record["id"]).first()
        if db_single.activity.haul[0].station().name != record["station"]:
            # hänge station um
            db_new_station = session.query(db.Station).filter(db.Station.name == record["station"]).first()
            db_single.activity = db_new_station.hauls[0].activity
            db_single.weight = db_single.weight[:]
            db_single.weight.append(db_new_station.hauls[0].weight(self.species))

        self.set_values(record, db_single, session)

        session.add(db_single)

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

        self.cruise_uid = None
        self.species = None

        self.model = None

        self.btn_save.clicked.connect(self.save_data)

        self.setEnabled(False)

    def set_data(self, cruise_uid):
        self.wgt_species.set_data()
        self.wgt_species.dataChanged.connect(self.species_selected)

        self.setEnabled(True)

    def species_selected(self, bfa_num):
        self.model = SingleTableModel(self.cruise_uid, str(bfa_num))
        self.tv_single.horizontalHeader().set_context(self.model.header)
        self.tv_single.setModel(self.model)

    def save_data(self):
        if self.model is not None:
            self.model.save_data()