from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *

import csv
import frm_gear


class Frm_Gear(QWidget, frm_gear.Ui_frm_gear):

    def __init__(self, parent=None):
        super(Frm_Gear, self).__init__(parent)
        self.setupUi(self)

        gear_prop = []
        with open('gear_map.csv', newline='') as gear_codes_file:
            spamreader = csv.reader(gear_codes_file, delimiter=',')
            for row in spamreader:
                gear_prop.append(row)
        gear_names = [gear[0] for gear in gear_prop]
        
        self.cb_netz.addItems(gear_names[1:])
        
        self.buttons = [self.edit_minDepth, self.edit_maxDepth, self.edit_waterDepth,
                  self.edit_nation, self.edit_tier5, self.edit_tier6, self.edit_gear,
                  self.edit_meshSizeRange, self.edit_device, self.edit_deviceMesh,
                  self.edit_spGroup, self.edit_sp, self.edit_spNum, self.edit_catch,
                  self.edit_gearAdd, self.edit_meshSize, self.edit_codendMeshSize,
                  self.edit_footrope, self.edit_footropeLength, self.edit_jagerLength,
                  self.edit_netBoard, self.edit_netHori, self.edit_netVert,
                  self.edit_netGirth, self.edit_curlLineLength, self.edit_rollerDiam,
                  self.edit_beamLength, self.edit_beamChains, self.edit_setNetNum,
                  self.edit_setNetLength, self.edit_setNetHeight, self.edit_setNetTotal,
                  self.edit_pinger, self.edit_pingerType, self.edit_hooks, self.edit_traps]
        
        self.gear_prop = gear_prop
        
        index = self.cb_netz.currentIndex()
        
        for i in range(14):
            self.buttons[i].setEnabled(1)
        
        for i in range(14, len(self.buttons)):
            self.buttons[i].setEnabled(int(self.gear_prop[index+1][i-12]))
        
        self.cb_netz.currentIndexChanged.connect(self.select_gear)
    
    def select_gear(self):
        index = self.cb_netz.currentIndex()
        self.cb_netz.setCurrentIndex(index)
        
        for i in range(14):
            self.buttons[i].setEnabled(1)
        
        for i in range(14, len(self.buttons)):
            self.buttons[i].setEnabled(int(self.gear_prop[index+1][i-12]))
        
    def save_button(self):
        minDepth = self.edit_minDepth.text()
        maxDepth = self.edit_maxDepth.text()
        waterDepth = self.edit_waterDepth.text()
        nation = self.edit_nation.text()
        tier5 = self.edit_tier5.text()
        tier6 = self.edit_tier6.text()
        gear = self.edit_gear.text()
        meshSizeRange = self.edit_meshSizeRange.text()
        device = self.edit_device.text()
        deviceMesh = self.edit_deviceMesh.text()
        spGroup = self.edit_spGroup.text()
        species = self.edit_sp.text()
        spNum = self.edit_spNum.text()
        catch = self.edit_catch.text()
        gearAdd = self.edit_gearAdd.text()
        meshSize = self.edit_meshSize.text()
        codendMeshSize = self.edit_codendMeshSize.text()
        footrope = self.edit_footrope.text()
        footropeLength = self.edit_footropeLength.text()
        jagerLength = self.edit_jagerLength.text()
        netBoard = self.edit_netBoard.text()
        netHori = self.edit_netHori.text()
        netVert = self.edit_netVert.text()
        netGirth = self.edit_netGirth.text()
        curlLineLength = self.edit_curlLineLength.text()
        rollerDiam = self.edit_rollerDiam.text()
        beamLength = self.edit_beamLength.text()
        beamChains = self.edit_beamChains.text()
        setNetNum = self.edit_setNetNum.text()
        setNetLength = self.edit_setNetLength.text()
        setNetHeight = self.edit_setNetHeight.text()
        setNetTotal = self.edit_setNetTotal.text()
        pinger = self.edit_pinger.text()
        pingerType = self.edit_pingerType.text()
        hooks = self.edit_hooks.text()
        traps = self.edit_traps.text()
        
        con = psycopg2.connect(pg_engine)
        cur = con.cursor()
        
        trip_comm = "INSERT INTO com_new_final.trip (year, trip_number, eunr, \
            vessel_name, vessel_sign, start_date, end_date, start_loc, end_loc, \
            observer, trip_valid, trip_type) VALUES "
        
        result = "({}, {}, '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', true, \
            {});".format(minDepth, maxDepth, waterDepth, nation, tier5, tier6,
    gear, meshSizeRange, device, deviceMesh, spGroup, species, spNum, catch,
    gearAdd, meshSize, codendMeshSize, footrope, footropeLength, jagerLength,
    netBoard, netHori, netVert, netGirth, curlLineLength, rollerDiam, beamLength,
    beamChains, setNetNum, setNetLength, setNetHeight, setNetTotal, pinger,
    pingerType, hooks, traps)
        
        try:
            cur.execute(trip_comm + result)
            con.commit()
            cur.close()
            con.close()
            self.close()
        except:
            self.show_error()
    
    def show_error(self):
        notif = QMessageBox()
        notif.setWindowTitle("Error")
        notif.setText("Daten Input ist falsch")
        notif.setIcon(QMessageBox.Warning)
        notif.setStandardButtons(QMessageBox.Ok)
        
        show = notif.exec_()
