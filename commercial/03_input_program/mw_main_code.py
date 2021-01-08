from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *

import mw_main
import dlg_server_connect_code as sc
import dlg_cruise_select_code as cs
import dlg_new_cruise_code as nc
import dlg_new_haul_code as nh

#import account
from reference import Reference as ref


class MainWindow(QMainWindow, mw_main.Ui_mw_Main):

    def __init__(self, parent=None):
        super(MainWindow, self).__init__(parent)
        self.setupUi(self)

        self.cruise_uid = None
        self.haul_uid = None
        
        self.actionChooseCruise.setEnabled(0)
        self.actionNewCruise.setEnabled(0)
        
        self.tab_station.setEnabled(0)
        self.tab_gear.setEnabled(0)
        self.tab_samples.setEnabled(0)
        self.tab_single.setEnabled(0)
        
        self.actionConnectServer.triggered.connect(self.server_connect_triggered)
            
        self.actionChooseCruise.triggered.connect(self.choose_cruise_triggered)
        self.actionNewCruise.triggered.connect(self.new_cruise_triggered)

        self.activity_bar.new_haul_clicked.connect(self.new_haul)
        
        self.tw_main.tabBarClicked.connect(self.open_samples)
        self.tw_main.tabBarClicked.connect(self.open_single)
    
    def server_connect_triggered(self):
        self.sv_dlg = sc.Dlg_Server_Connect(self)
        self.sv_dlg.finished.connect(self.account_activated)
        self.sv_dlg.show()
    
    def account_activated(self):
        ref.connection = self.sv_dlg.log
        if ref.connection != None:
            self.actionChooseCruise.setEnabled(1)
            self.actionNewCruise.setEnabled(1)
        
    def choose_cruise_triggered(self):
        self.cs_dlg = cs.dlg_Cruise_Select(self)
        self.cs_dlg.finished.connect(self.cruise_chosen)
        self.cs_dlg.show()

    def cruise_chosen(self):
        try:
            self.cruise_uid = self.cs_dlg.cruise_uid
            ref.cruise_uid = self.cruise_uid
            self.load_activities()
        except AttributeError:
            pass

    def load_activities(self):
        self.tv_activity.clear()
        
        cruise_uid = self.cruise_uid
        
        cur = ref.connection.cursor()
        
        sql_data = "SELECT ha_index, haul FROM com_new_final.haul_fo WHERE tr_index = {};".format(cruise_uid)
        
        cur.execute(sql_data)
        activity_uid = cur.fetchall()
        
        cur.close()
        
        self.haul_list = [("HOL " + str(i[1])) for i in activity_uid]
        self.haul_idcs = [i[0] for i in activity_uid]

        self.tv_activity.addItems(self.haul_list)
        self.tv_activity.activated.connect(self.haul_selected)
    
    def new_cruise_triggered(self):
        self.nc_dlg = nc.dlg_New_Cruise(self)
        self.nc_dlg.finished.connect(self.new_cruise_added)
        self.nc_dlg.show()

    def new_cruise_added(self):
        cur = ref.connection.cursor()
        cur.execute("SELECT MAX(tr_index) from com_new_final.trip;")
        self.cruise_uid = cur.fetchone()[0] + 1
        
        try:
            trip_comm = """INSERT INTO com_new_final.trip (tr_index, year, trip_number, eunr, 
            vessel_name, vessel_sign, start_date, end_date, start_loc, end_loc, 
            observer, trip_valid, trip_type) VALUES """
    
            result = """({}, {}, {}, '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', true, 
            {});""".format(self.cruise_uid, self.nc_dlg.year, self.nc_dlg.cruise_num,
            self.nc_dlg.EU_num, self.nc_dlg.ship_name, self.nc_dlg.ship_sign,
            self.nc_dlg.startdate, self.nc_dlg.enddate, self.nc_dlg.starthafen,
            self.nc_dlg.endhafen, self.nc_dlg.beprober, self.nc_dlg.cruise_type)
        
            cur.execute(trip_comm + result)
            ref.cruise_uid = self.cruise_uid
            ref.connection.commit()
            cur.close()
            
            self.tv_activity.clear()

            self.nh_dlg = nh.dlg_New_Haul(self.cruise_uid, self)
            self.nh_dlg.finished.connect(self.new_haul_added)
            self.nh_dlg.show()
            
        except:
            QMessageBox.warning(self, 'Fehler', 'Not valid')
            return

    def new_haul(self):
        if self.cruise_uid is None:
            QMessageBox.warning(self, 'Fehler', 'Keine Reise ausgewählt')
            return
        
        else:
            self.nh_dlg = nh.dlg_New_Haul(self.cruise_uid, self)
            self.nh_dlg.finished.connect(self.new_haul_added)
            self.nh_dlg.show()
            
    def new_haul_added(self):
        self.haul_name = self.nh_dlg.ha_index
        self.tv_activity.addItem('HOL ' + self.haul_name)
        
        cur = ref.connection.cursor()
        cur.execute("SELECT MAX(ha_index) from com_new_final.haul_fo;")
        self.haul_uid = cur.fetchone()[0] + 1
        cur.close()
        
        ref.haul_uid = self.haul_uid
        
        if self.haul_uid != None:
            self.tab_station.setEnabled(1)
            self.tab_gear.setEnabled(1)
            
        self.tab_station.clear()
        self.tab_gear.clear()
    
    def haul_selected(self, current):
        try:
            self.haul_uid = self.haul_idcs[self.tv_activity.currentRow()]
        except IndexError:
            self.load_activities()
            self.haul_uid = self.haul_idcs[self.tv_activity.currentRow()]
        
        ref.haul_uid = self.haul_uid
        
        if self.haul_uid != None:
            self.tab_station.setEnabled(1)
            self.tab_gear.setEnabled(1)
            
            self.tab_station.show_data()
            self.tab_gear.show_data()
    
    def open_samples(self):
        if self.haul_uid != None:
            self.tab_samples.setEnabled(1)
            self.tab_samples.set_data()
        else:
            QMessageBox.warning(self, 'Fehler', 'Keine Hol ausgewählt')
            return    
    
    def open_single(self):
        if self.haul_uid != None:
            self.tab_single.setEnabled(1)
            self.tab_single.set_data()
        else:
            QMessageBox.warning(self, 'Fehler', 'Keine Hol ausgewählt')
            return   

if __name__ == '__main__':
    import sys
    app = QApplication(sys.argv)
    app.processEvents()
    mw = MainWindow()
    mw.show()
    app.exec_()