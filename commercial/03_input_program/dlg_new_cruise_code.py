from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
import checking_ranges as check
from datetime import datetime

import dlg_new_cruise
import dlg_server_connect_code as sc


class dlg_New_Cruise(QDialog, dlg_new_cruise.Ui_dlg_New_Cruise):

    def __init__(self, parent=None):
        super(dlg_New_Cruise, self).__init__(parent)
        self.setupUi(self)
        
        self.btn_save.clicked.connect(self.save)
    
    def save(self):
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
        self.stateWin=0

        self.beprober = self.frm_cruise.cb_leader.itemText(self.frm_cruise.cb_leader.currentIndex())
        #self.nc_dlg.startdate  self.nc_dlg.enddate
        start = datetime.strptime(self.startdate, '%d.%m.%Y')#.date()
        end = datetime.strptime(self.enddate, '%d.%m.%Y')#.date()
        """Integration of error notification"""
        error_trip = check.checkingRangeTRIP((self.year),
            (self.cruise_num), self.EU_num, self.ship_name,
            self.ship_sign, start, end, self.starthafen, self.endhafen,
            self.beprober, True, (self.cruise_type))

        print(error_trip)
        if error_trip == [[], [], []]:
            self.stateWin=1
            self.done(1)
        else:
          # """Else, message boxes are shown as notification"""
            for i in range(len(error_trip[2])):
                QMessageBox.warning(self, error_trip[1][i],
                                        error_trip[0][i] + ": " + error_trip[2][i])


        