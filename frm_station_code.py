from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *

import datetime

import frm_station

#import account
from reference import Reference as ref


class CoordTableModel(QAbstractTableModel):

    def __init__(self, row):
        super(CoordTableModel, self).__init__()
        
        self.__data = [[row['fostartdate'], row['fostarttime'], row['fostartlat'],
                        row['fostartlon'], row['rectangle']],
                       [row['foenddate'], row['foendtime'], row['fostoplat'],
                        row['fostoplon'], row['rectangle']]]
        self.__header = ["Datum", "Zeit", "Breitengrad", "Längengrad", "Rectangle"]        
        
    def rowCount(self, index=QModelIndex()):
        return len(self.__data)

    def columnCount(self, index=QModelIndex()):
        return len(self.__header)

    def headerData(self, section, orientation, role=Qt.DisplayRole):
        "section columns, rows, Qt.DisplayRole ask for the "
        if role != Qt.DisplayRole:
            return None
        if orientation == Qt.Horizontal:
            return self.__header[section]
        return None

    def data(self, index, role = Qt.DisplayRole):
        """
        index ___ QIndex, class 
        """
        if not index.isValid() or not (0 <= index.row() < len(self.__data)) or index.column() >= len(self.__header):
            return None

        row = index.row()
        col = index.column()

        if role == Qt.DisplayRole or role == Qt.EditRole:
            "in Cpp you need to put variables here first"
            if col == 0:
                return self.__data[row][col].strftime("%d.%m.%Y")
            elif col == 1:
                return self.__data[row][col].strftime("%H:%M")
            return self.__data[row][col]

        return None
    
    def flags(self, index):
        if index.column() < 2:
            "this will be deprecated"
            return Qt.ItemFlags(int(QAbstractTableModel.flags(self, index)))
        else:
            return Qt.ItemFlags(int(QAbstractTableModel.flags(self, index)|Qt.ItemIsEditable))
        
    def setData(self, index, value, role=Qt.EditRole):
        if not index.isValid():
            return False
        row = index.row()
        if index.column() > 1:
            self.__data[row][index.column()] = value
            self.dataChanged.emit(index,index) #signal / behaviour
            return True
        return False   


def row_dict(row, cur):
    col_names = [col[0] for col in cur.description]
    return dict(zip(col_names, row))


# def build_update(table_name, data, index_name):
#     sql = """ UPDATE com_new_final.{} SET """.format(table_name)
#     sql += ", ".join(["{} = {}".format(k,v) if type(v) is int else "{} = '{}'".format(k,v) for k,v in data.items()])
#     sql += " WHERE ha_index = {};".format(data[index_name])
#     return sql


class Frm_Station(QWidget, frm_station.Ui_frm_station):

    def __init__(self, parent=None):
        super(Frm_Station, self).__init__(parent)
        self.setupUi(self)
        
        self.btn_add_coords.clicked.connect(self.set_date_time)
        self.btn_save1.clicked.connect(self.save_fo)
        self.btn_save2.clicked.connect(self.save_env)
    
    def show_data(self):
        self.cruise_uid = ref.cruise_uid
        self.haul_uid = ref.haul_uid
        
        cur = ref.connection.cursor()
        
        sql_statement = """SELECT * FROM com_new_final.haul_fo WHERE
        tr_index = {} AND ha_index = {}""".format(self.cruise_uid, self.haul_uid)
        
        cur.execute(sql_statement)
        
        self.__data = row_dict(cur.fetchone(), cur)
        
        self.edt_jahr.setText(str(self.__data['year']))
        self.edt_monat.setText(str(self.__data['month']))
        self.edt_quartal.setText(str(self.__data['quarter']))
        self.edt_haul_name.setText(str(self.__data['haul']))
        
        self.de_start.setDate(self.__data['fostartdate'])
        self.te_start.setTime(self.__data['fostarttime'])
        self.de_end.setDate(self.__data['foenddate'])
        self.te_end.setTime(self.__data['foendtime'])
        
        duration = str(self.__data['fishing_duration']).split(':')
        duration = [int(i) for i in duration]
        
        self.te_duration.setTime(datetime.time(duration[0], duration[1], duration[2]))
        
        self.coord_model = CoordTableModel(self.__data)
        
        self.tv_coords.reset()
        self.tv_coords.setModel(self.coord_model)
        
        sql_statement = """SELECT * FROM com_new_final.haul_envir WHERE
        tr_index = {}""".format(self.cruise_uid)
        
        cur.execute(sql_statement)
        self.__enviro = row_dict(cur.fetchone(), cur)
        
        self.widget.sb_wind_speed.setValue(self.__enviro['wind_speed'])
        self.widget.sb_wind_dir.setValue(self.__enviro['wind_direction'])
        self.widget.sb_cloud.setValue(int(self.__enviro['cloud_cover']))
        self.widget.sb_temp_air.setValue(self.__enviro['temperature_air'])
        
        if self.__enviro['temperature_water'] != None:
            self.widget.sb_temp_water.setValue(self.__enviro['temperature_water'])
        
        self.widget.sb_weather.setValue(int(self.__enviro['weather']))
        self.widget.sb_light.setValue(int(self.__enviro['light']))
        self.widget.sb_currents.setValue(int(self.__enviro['currents']))
        
        self.pte_notation.setPlainText(self.__enviro['comments'])
            
        cur.close()
        
    def set_date_time(self):
        
        coord = dict(zip(['fostartdate', 'fostarttime', 'foenddate', 'foendtime',
                          'fostartlat', 'fostoplat', 'fostartlon', 'fostoplon', 'rectangle'],
                         [self.de_start.date().toPyDate(), self.te_start.time().toPyTime(),
                          self.de_end.date().toPyDate(), self.te_end.time().toPyTime(),
                          "", "", "", "", "", ""]))
        
        self.coord_model = CoordTableModel(coord)
        self.tv_coords.setModel(self.coord_model)
        
    def clear(self):
        self.edt_jahr.clear()
        self.edt_monat.clear()
        self.edt_quartal.clear()
        self.edt_haul_name.clear()
        
        self.de_start.clear()
        self.te_start.clear()
        self.de_end.clear()
        self.te_end.clear()
        self.te_duration.clear()
        
        self.tv_coords.reset()
        
        self.widget.sb_wind_speed.clear()
        self.widget.sb_wind_dir.clear()
        self.widget.sb_cloud.clear()
        self.widget.sb_temp_air.clear()
        self.widget.sb_temp_water.clear()
        
        self.widget.sb_weather.clear()
        self.widget.sb_light.clear()
        self.widget.sb_currents.clear()
        
        self.pte_notation.clear()
        
    def save_fo(self):
        self.cruise_uid = ref.cruise_uid
        self.haul_uid = ref.haul_uid
        
        cur = ref.connection.cursor()
        
        year = self.edt_jahr.text()
        month = self.edt_monat.text()
        quartal = self.edt_quartal.text()
        haul = self.edt_haul_name.text()
            
        de_start = self.de_start.text()
        te_start = self.te_start.text()
        de_end = self.de_end.text()
        te_end = self.te_end.text()
        duration = self.te_duration.text()
            
        lat_start = self.coord_model.data(self.coord_model.index(0, 2))
        lat_end = self.coord_model.data(self.coord_model.index(1, 2))
        lon_start = self.coord_model.data(self.coord_model.index(0, 3))
        lon_start = self.coord_model.data(self.coord_model.index(1, 2))
        rectangle = self.coord_model.data(self.coord_model.index(0, 4))
            
        sql_statement = """SELECT * FROM com_new_final.haul_fo WHERE
        tr_index = {} AND ha_index = {}""".format(self.cruise_uid, self.haul_uid)
        
        cur.execute(sql_statement)
        
        if cur.fetchone() == None:
            sql_statement = """INSERT INTO com_new_final.haul_fo (ha_index,
            tr_index, year, quarter, month, haul, fostartdate, fostarttime,
            foenddate, foendtime, fishing_duration, fostartlat,
            fostartlon, fostoplat, fostoplon, rectangle) VALUES """

            result = """({}, {}, {}, {}, {}, {}, '{}', '{}', '{}', '{}', '{}',
            '{}', '{}', '{}', '{}', '{}');""".format(self.haul_uid, self.cruise_uid, 
            year, quartal, month, haul, de_start, te_start, de_end, te_end, duration, 
            lat_start, lat_end, lon_start, lon_start, rectangle)
    
            print(sql_statement + result)
            cur.execute(sql_statement + result)
            ref.connection.commit()
            cur.close()
            
        else:
            sql_statement = """UPDATE com_new_final.haul_fo SET tr_index = {},
            year = {}, quarter = {}, month = {}, haul = {}, fostartdate = '{}',
            fostarttime = '{}', foenddate = '{}', foendtime = '{}', fishing_duration = '{}',
            fostartlat = '{}', fostartlon = '{}', fostoplat = '{}', fostoplon = '{}',
            rectangle = '{}') WHERE ha_index = {}""".format(self.cruise_uid, 
            year, quartal, month, haul, de_start, te_start, de_end, te_end, duration, 
            lat_start, lat_end, lon_start, lon_start, rectangle, self.haul_uid)
    
            print(sql_statement)
            cur.execute(sql_statement)
            ref.connection.commit()
            cur.close()
            
    def save_env(self):
        self.cruise_uid = ref.cruise_uid
        self.haul_uid = ref.haul_uid
        
        cur = ref.connection.cursor()
        
        wind_speed = self.widget.sb_wind_speed.text()
        wind_dir = self.widget.sb_wind_dir.text()
        cloud = self.widget.sb_cloud.text()
        temp_air = self.widget.sb_temp_air.text()
        temp_water = self.widget.sb_temp_water.text()
            
        weather = self.widget.sb_weather.text()
        light = self.widget.sb_light.text()
        currents = self.widget.sb_currents.text()
            
        comments = self.pte_notation.toPlainText()
            
        sql_statement = """SELECT * FROM com_new_final.haul_envir WHERE
        ha_index = {}""".format(self.haul_uid)
        
        cur.execute(sql_statement)
        
        if cur.fetchone() == None:
            sql_statement = """INSERT INTO com_new_final.haul_envir (ha_index,
            tr_index, wind_speed, wind_direction, cloud_cover, temperature_air, 
            temperature_water, weather, light, currents, comments) VALUES """

            result = """({}, {}, {}, {}, '{}', {}, {}, '{}', '{}', '{}', 
            '{}');""".format(self.haul_uid, self.cruise_uid, wind_speed, wind_dir,
            cloud, temp_air, temp_water, weather, light, currents, comments)
    
            print(sql_statement + result)
            cur.execute(sql_statement + result)
            ref.connection.commit()
            cur.close()
            
        else:
            sql_statement = """UPDATE com_new_final.haul_envir SET tr_index = {},
            wind_speed = {}, wind_direction = {}, cloud_cover = {}, temperature_air = {},
            temperature_water = '{}', weather = '{}', light = '{}', currents = '{}',
            comments = '{}' WHERE ha_index = {}""".format(self.cruise_uid, 
            wind_speed, wind_dir, cloud, temp_air, temp_water, weather, light,
            currents, comments, self.haul_uid)
    
            print(sql_statement)
            cur.execute(sql_statement)
            ref.connection.commit()
            cur.close()

