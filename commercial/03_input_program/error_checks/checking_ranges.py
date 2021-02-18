import xlrd
import psycopg2
from datetime import date
from datetime import time

class RangClass:
    '''The class for saving the range values.'''
    def __init__(self,tableName):
        '''
        This class for reading the ranges from the Excel file.
        The order of sheets in the Excel file is important.
        The titles of columns are '#', 'Name', 'Type', 'Mandatory', 'Null_9', 'Range', 'Range_min', 'Range_max',
         'Error_type', 'Error_message1', 'Error2', 'Error_message2', and 'Comments'.
         (((The excel file is temporary)))
        '''
        # Give the location of the file
        loc = ("Format.xlsx")

        # To open Workbook
        wb = xlrd.open_workbook(loc)
        sheet = wb.sheet_by_index(0)
        self.MyRangeData = []
        # For row 0 and column 0
        for x in range(1, 76):
            if tableName==sheet.cell_value(x, 0):
                self.MyRangeData.append(self.dataRangeClass(sheet.cell_value(x, 1), sheet.cell_value(x, 2), sheet.cell_value(x, 3),
                                              sheet.cell_value(x, 4), sheet.cell_value(x, 5), sheet.cell_value(x, 6),
                                              sheet.cell_value(x, 7), sheet.cell_value(x, 8), sheet.cell_value(x, 9),
                                              sheet.cell_value(x, 10), sheet.cell_value(x, 11), sheet.cell_value(x, 12),
                                              sheet.cell_value(x, 13),sheet.cell_value(x, 14),sheet.cell_value(x, 14)))
        sheet = wb.sheet_by_index(1)
        self.MyAreaRectangleData = []
        # For row 0 and column 0
        for x in range(1, 16):
            self.MyAreaRectangleData.append(self.dataAreaRectangleClass(sheet.cell_value(x, 0), sheet.cell_value(x, 1), sheet.cell_value(x, 2).split(",")))

    class dataRangeClass:
        '''The class for saving the range values.'''

        def __init__(self, Name_, Type_, mandatory_, Null_, _9_, Range_, Range_min_, Range_max_,value_,value_allowed_, error_type_,
                     error_message1_, error2_, error_message2_, comments_):
            self.Name = Name_
            self.Type = Type_
            self.mandatory = mandatory_
            self.Null = Null_
            self._9 = _9_
            self.Range = Range_
            self.Range_min = Range_min_
            self.Range_max = Range_max_
            self.value=value_
            self.value_allowed=value_allowed_
            self.error_type = error_type_
            self.error_message1 = error_message1_
            self.error2 = error2_
            self.error_message2 = error_message2_
            self.comments = comments_
    class dataAreaRectangleClass:
        '''The class for saving the range values.'''

        def __init__(self,id_, area_code_,allowed_rectangle_):
            self.id = id_
            self.area_code = area_code_
            self.allowed_rectangle=allowed_rectangle_

class dataTRIPClass:
    '''
    The class for saving the input numbers.
    '''
    def __init__(self):
            self.year = ""
            self.trip_number = ""
            self.eunr = ""
            self.vessel_name = ""
            self.vessel_sign = ""
            self.start_date = ""
            self.end_date = ""
            self.start_loc = ""
            self.end_loc = ""
            self.observer = ""
            self.trip_valid = ""
            self.trip_type = ""

    def input(self, year_, trip_number_, eunr_, vessel_name_, vessel_sign_, start_date_, end_date_, start_loc_,
                  end_loc_, observer_, trip_valid_, trip_type_):
            '''The function for getting the input numbers. '''
            self.year = year_
            self.trip_number = trip_number_
            self.eunr = eunr_
            self.vessel_name = vessel_name_
            self.vessel_sign = vessel_sign_
            self.start_date = start_date_
            self.end_date = end_date_
            self.start_loc = start_loc_
            self.end_loc = end_loc_
            self.observer = observer_
            self.trip_valid = trip_valid_
            self.trip_type = trip_type_

    def name2value(self, Name):
        '''
            The function returns the value of "Name".
        '''
        switcher = {
                "year": self.year,
                "trip_number": self.trip_number,
                "eunr": self.eunr,
                "vessel_name": self.vessel_name,
                "vessel_sign": self.vessel_sign,
                "start_date": self.start_date,
                "end_date": self.end_date,
                "start_loc": self.start_loc,
                "end_loc": self.end_loc,
                "observer": self.observer,
                "trip_valid": self.trip_valid,
                "trip_type": self.trip_type
            }
        return switcher.get(Name, "Invalid name")
class dataHAUL_FOClass:
    '''
    The class for saving the input numbers and data.
    '''
    def __init__(self):
        self.year = ""
        self.quarter = ""
        self.month = ""
        self.haul = ""
        self.fo_start_date = ""
        self.fo_start_time = ""
        self.fo_end_date = ""
        self.fo_end_time = ""
        self.fishing_duration = ""
        self.fo_start_lat = ""
        self.fo_start_lon = ""
        self.fo_stop_lat = ""
        self.fo_stop_lon = ""
        self.fishing_distance = ""
        self.country = ""
        self.area_national = ""
        self.fao_area = ""
        self.rectangle = ""

    def input(self, year_, quarter_, month_, haul_, fo_start_date_, fo_start_time_, fo_end_date_, fo_end_time_,
              fishing_duration_, fo_start_lat_, fo_start_lon_, fo_stop_lat_, fo_stop_lon_, fishing_distance_,
              country_, area_national_, fao_area_, rectangle_):
            '''The function for getting the input numbers and data. '''
            self.year = year_
            self.quarter = quarter_
            self.month = month_
            self.haul = haul_
            self.fo_start_date = fo_start_date_
            self.fo_start_time = fo_start_time_
            self.fo_end_date = fo_end_date_
            self.fo_end_time = fo_end_time_
            self.fishing_duration = fishing_duration_
            self.fo_start_lat = fo_start_lat_
            self.fo_start_lon = fo_start_lon_
            self.fo_stop_lat = fo_stop_lat_
            self.fo_stop_lon = fo_stop_lon_
            self.fishing_distance = fishing_distance_
            self.country = country_
            self.area_national = area_national_
            self.fao_area = fao_area_
            self.rectangle = rectangle_

    def name2value(self, Name):
        '''
            The function returns the value of "Name".
        '''
        switcher = {
                "year":self.year,
                "quarter":self.quarter,
                "month":self.month,
                "haul":self.haul,
                "fo_start_date":self.fo_start_date,
                "fo_start_time":self.fo_start_time,
                "fo_end_date":self.fo_end_date,
                "fo_end_time":self.fo_end_time,
                "fishing_duration":self.fishing_duration,
                "fo_start_lat":self.fo_start_lat,
                "fo_start_lon":self.fo_start_lon,
                "fo_stop_lat":self.fo_stop_lat,
                "fo_stop_lon":self.fo_stop_lon,
                "fishing_distance":self.fishing_distance,
                "country":self.country,
                "area_national":self.area_national,
                "fao_area":self.fao_area,
                "rectangle":self.rectangle
        }
        return switcher.get(Name, "Invalid name")
class dataHAUL_GEARClass:
    '''
    The class for saving the input numbers.
    '''
    def __init__(self):
        self.fishing_depth_min = ""
        self.fishing_depth_max = ""
        self.water_depth = ""
        self.gear_national = ""
        self.metier_lvl_5 = ""
        self.metier_lvl_6 = ""
        self.gear = ""
        self.mesh_size_range = ""
        self.selection_device = ""
        self.selection_device_mesh = ""
        self.target_species_group = ""
        self.target_species = ""
        self.number_species = ""
        self.total_catch = ""
        self.gear_addition = ""
        self.mesh_size = ""
        self.codend_mesh_size = ""
        self.footrope = ""
        self.footrope_length = ""
        self.jager_length = ""
        self.net_board_dist = ""
        self.net_horizontal = ""
        self.net_vertical = ""
        self.net_girth = ""
        self.curl_line_length = ""
        self.roller_diameter = ""
        self.beam_length = ""
        self.beam_chains = ""
        self.setnet_number = ""
        self.setnet_length = ""
        self.setnet_height = ""
        self.setnet_total_length = ""
        self.pinger = ""
        self.pinger_type = ""
        self.hooks = ""
        self.traps = ""

    def input(self, fishing_depth_min_, fishing_depth_max_, water_depth_, gear_national_, metier_lvl_5_, metier_lvl_6_,
              gear_, mesh_size_range_, selection_device_, selection_device_mesh_, target_species_group_, target_species_,
              number_species_, total_catch_, gear_addition_, mesh_size_, codend_mesh_size_, footrope_, footrope_length_,
              jager_length_, net_board_dist_, net_horizontal_, net_vertical_, net_girth_, curl_line_length_, roller_diameter_,
              beam_length_, beam_chains_, setnet_number_, setnet_length_, setnet_height_, setnet_total_length_, pinger_,
              pinger_type_, hooks_, traps_):
            '''The function for getting the input numbers. '''
            self.fishing_depth_min = fishing_depth_min_
            self.fishing_depth_max = fishing_depth_max_
            self.water_depth = water_depth_
            self.gear_national = gear_national_
            self.metier_lvl_5 = metier_lvl_5_
            self.metier_lvl_6 = metier_lvl_6_
            self.gear = gear_
            self.mesh_size_range = mesh_size_range_
            self.selection_device = selection_device_
            self.selection_device_mesh = selection_device_mesh_
            self.target_species_group = target_species_group_
            self.target_species = target_species_
            self.number_species = number_species_
            self.total_catch = total_catch_
            self.gear_addition = gear_addition_
            self.mesh_size = mesh_size_
            self.codend_mesh_size = codend_mesh_size_
            self.footrope = footrope_
            self.footrope_length = footrope_length_
            self.jager_length = jager_length_
            self.net_board_dist = net_board_dist_
            self.net_horizontal = net_horizontal_
            self.net_vertical = net_vertical_
            self.net_girth = net_girth_
            self.curl_line_length = curl_line_length_
            self.roller_diameter = roller_diameter_
            self.beam_length = beam_length_
            self.beam_chains = beam_chains_
            self.setnet_number = setnet_number_
            self.setnet_length = setnet_length_
            self.setnet_height = setnet_height_
            self.setnet_total_length = setnet_total_length_
            self.pinger = pinger_
            self.pinger_type = pinger_type_
            self.hooks = hooks_
            self.traps = traps_

    def name2value(self, Name):
        '''
            The function returns the value of "Name".
        '''
        switcher = {
            "fishing_depth_min": self.fishing_depth_min,
            "fishing_depth_max": self.fishing_depth_max,
            "water_depth": self.water_depth,
            "gear_national": self.gear_national,
            "metier_lvl_5": self.metier_lvl_5,
            "metier_lvl_6": self.metier_lvl_6,
            "gear": self.gear,
            "mesh_size_range": self.mesh_size_range,
            "selection_device": self.selection_device,
            "selection_device_mesh": self.selection_device_mesh,
            "target_species_group": self.target_species_group,
            "target_species": self.target_species,
            "number_species": self.number_species,
            "total_catch": self.total_catch,
            "gear_addition": self.gear_addition,
            "mesh_size": self.mesh_size,
            "codend_mesh_size": self.codend_mesh_size,
            "footrope": self.footrope,
            "footrope_length": self.footrope_length,
            "jager_length": self.jager_length,
            "net_board_dist": self.net_board_dist,
            "net_horizontal": self.net_horizontal,
            "net_vertical": self.net_vertical,
            "net_girth": self.net_girth,
            "curl_line_length": self.curl_line_length,
            "roller_diameter": self.roller_diameter,
            "beam_length": self.beam_length,
            "beam_chains": self.beam_chains,
            "setnet_number": self.setnet_number,
            "setnet_length": self.setnet_length,
            "setnet_height": self.setnet_height,
            "setnet_total_length": self.setnet_total_length,
            "pinger": self.pinger,
            "pinger_type": self.pinger_type,
            "hooks": self.hooks,
            "traps": self.traps

        }
        return switcher.get(Name, "Invalid name")
class dataHAUL_ENVIRClass:
    '''
    The class for saving the input numbers.
    '''
    def __init__(self):
            self.wind_speed = ""
            self.wind_direction = ""
            self.cloud_cover = ""
            self.temperature_air = ""
            self.temperature_water = ""
            self.weather = ""
            self.light = ""
            self.currents = ""
            self.comments = ""

    def input(self, wind_speed_, wind_direction_, cloud_cover_, temperature_air_, temperature_water_, weather_, light_,
              currents_, comments_):
            '''The function for getting the input numbers. '''
            self.wind_speed = wind_speed_
            self.wind_direction = wind_direction_
            self.cloud_cover = cloud_cover_
            self.temperature_air = temperature_air_
            self.temperature_water = temperature_water_
            self.weather = weather_
            self.light = light_
            self.currents = currents_
            self.comments = comments_

    def name2value(self, Name):
        '''
            The function returns the value of "Name".
        '''
        switcher = {
                "wind_speed": self.wind_speed,
                "wind_direction": self.wind_direction,
                "cloud_cover": self.cloud_cover,
                "temperature_air": self.temperature_air,
                "temperature_water": self.temperature_water,
                "weather": self.weather,
                "light": self.light,
                "currents": self.currents,
                "comments": self.comments
            }
        return switcher.get(Name, "Invalid name")

class dateClass:
    '''The class for checking and saving a date.'''
    def __init__(self,mydate):
        self.Date=mydate
        self.day=0
        self.month=0
        self.year=0
    def returnDateString(self):
        '''
        This function returns the date.
        For Example. 2020 1 12 to "20200112"
         '''
        if self.month>9:
            return str(self.year)+str(self.month)+str(self.day)
        else:
            return str(self.year) +"0"+str(self.month) + str(self.day)
    def checkFormat(self):
        '''
        This function checks the date format and converts the date to 3 integer numbers.
        For Example. "2020-01-12" returns True
                     "2020-01-12" is saved as  2020 01 12
         '''
        #if len(self.Date)!=10 or self.Date.count('-')!=2 or sum(c.isdigit() for c in self.Date)!=8:
        #    return False
        #if self.Date[4]!='-' or self.Date[7]!='-':
        #   return False
        #tempDate = date.fromisoformat(self.Date)
        self.day=self.Date.day
        self.month=self.Date.month
        self.year=self.Date.year
        return True
class timeClass:
    '''The class for checking and saving a time.'''
    def __init__(self, mytime):
        self.Time = mytime
        self.second = 0
        self.minute = 0
        self.hour = 0
        self.negative='+'
    def checkFormat24(self):
        '''
        This function checks the time format and converts the time to 3 integer numbers.
        For Example. "12:30:00" returns True
                     "12:30:00" is saved as  12 30 00
         '''
        if len(self.Time) != 8 or self.Time.count(':') != 2 or sum(c.isdigit() for c in self.Time) != 6:
            return False
        if self.Time[2] != ':' or self.Time[5] != ':':
            return False
        tempTime = time.fromisoformat(self.Time)
        self.second = tempTime.second
        self.minute = tempTime.minute
        self.hour = tempTime.hour
        return True
    def checkFormat(self):
        '''
        This function checks the time format and converts the time to 3 integer numbers.
        For Example. "-12:30:00" returns True
                     "-12:30:00" is saved as  - 12 30 00
        '''
        if self.Time != "" and self.Time[0] == '-':
            self.Time = self.Time[1:]
            self.negative = '-'
        if self.Time.count(':') != 2:
            return False
        if self.Time[2] != ':' or self.Time[5] != ':':
            return False
        tempTime = time.fromisoformat(self.Time)
        self.second = tempTime.second
        self.minute = tempTime.minute
        self.hour = tempTime.hour
        return True
class dataBaseConnection:
    '''This class is for reading the eu_register table.'''
    def __init__(self,Myconnection):
        self.Eu_registe=[]
        try:
            self.connection = psycopg2.connect(user=Myconnection.username,
                                               password=Myconnection.password,
                                               host=Myconnection.host,
                                               port=Myconnection.port,
                                               database=Myconnection.nameDataBase)
            self.connection.autocommit = Myconnection.autocommit
            self.cursor = self.connection.cursor()
            set_command = "SET search_path TO "+Myconnection.search_path+";"
            self.cursor.execute(set_command)
            # Print PostgreSQL Connection properties
            print (self.connection.get_dsn_parameters(), "\n")
            # Print PostgreSQL version
            self.cursor.execute("SELECT version();")
            record = self.cursor.fetchone()
            print("You are connected to - ", record, "\n")
        except:
            print("Cannot connect to datase")
    def readEu_registerTable(self):
        self.cursor.execute("SELECT * FROM public.eu_register;")
        record = self.cursor.fetchall()
        myData = []
        #listEu_register = []
        for row in record:
            myData.append(row)
        for index in range(myData.__len__()):
            self.Eu_registe.append(
                self.dataEu_register(myData[index][0],myData[index][1],myData[index][2],myData[index][3],myData[index][4],
                                myData[index][5],myData[index][6],myData[index][7],myData[index][8],myData[index][9],
                                myData[index][10],myData[index][11],myData[index][12],myData[index][13],myData[index][14],
                                myData[index][15],myData[index][16],myData[index][17],myData[index][18],myData[index][19],
                                myData[index][20],myData[index][21],myData[index][22],myData[index][23],myData[index][24],
                                myData[index][25],myData[index][26],myData[index][27],myData[index][28],myData[index][29],
                                myData[index][30],myData[index][31],myData[index][32],myData[index][33],myData[index][34],
                                myData[index][35] ))
    def findInCFR(self,myCFR):
        if myCFR == None or myCFR == "":
            return True
        for item in self.Eu_registe.__iter__():
            if item.isSameCFR(myCFR):
                return True
        return False

    class dataEu_register:
        '''This class is for saving the eu_register table.'''

        def __init__(self, Country_Code_, CFR_, Event_Code_, Event_Start_Date_, Event_End_Date_, License_Ind_,
                     Registration_Nbr_, Ext_Marking_, Vessel_Name_, Port_Code_, Port_Name_, IRCS_Code_, IRCS_,
                     Vms_Code_, Gear_Main_Code_, Gear_Sec_Code_, Loa_, Lbp_, Ton_Ref_, Ton_Gt_, Ton_Oth_, Ton_Gts_,
                     Power_Main_, Power_Aux_, Hull_Material_, Com_Year_, Com_Month_, Com_Day_, Segment_, Exp_Country_,
                     Exp_Type_, Public_Aid_Code_, Decision_Date_, Decision_Seg_Code_, Construction_Year_,
                     Construction_Place_):
            self.Country_Code = Country_Code_
            self.CFR = CFR_
            self.Event_Code = Event_Code_
            self.Event_Start_Date = Event_Start_Date_
            self.Event_End_Date = Event_End_Date_
            self.License_Ind = License_Ind_
            self.Registration_Nbr = Registration_Nbr_
            self.Ext_Marking = Ext_Marking_
            self.Vessel_Name = Vessel_Name_
            self.Port_Code = Port_Code_
            self.Port_Name = Port_Name_
            self.IRCS_Code = IRCS_Code_
            self.IRCS = IRCS_
            self.Vms_Code = Vms_Code_
            self.Gear_Main_Code = Gear_Main_Code_
            self.Gear_Sec_Code = Gear_Sec_Code_
            self.Loa = Loa_
            self.Lbp = Lbp_
            self.Ton_Ref = Ton_Ref_
            self.Ton_Gt = Ton_Gt_
            self.Ton_Oth = Ton_Oth_
            self.Ton_Gts = Ton_Gts_
            self.Power_Main = Power_Main_
            self.Power_Aux = Power_Aux_
            self.Hull_Material = Hull_Material_
            self.Com_Year = Com_Year_
            self.Com_Month = Com_Month_
            self.Com_Day = Com_Day_
            self.Segment = Segment_
            self.Exp_Country = Exp_Country_
            self.Exp_Type = Exp_Type_
            self.Public_Aid_Code = Public_Aid_Code_
            self.Decision_Date = Decision_Date_
            self.Decision_Seg_Code = Decision_Seg_Code_
            self.Construction_Year = Construction_Year_
            self.Construction_Place = Construction_Place_

        def isSameCFR(self, myCFR_):
            if myCFR_ == self.CFR:
                return True
            return False

    class connectionClass:
        '''
        This class is for reading the data connection of the PostgreSQL from the config.ini file.'''

        def __init__(self):
            file1 = open("config.ini", "r+")
            self.allData = file1.readlines()
            self.host = self.allData[2].rstrip()
            self.port = self.allData[4].rstrip()
            self.nameDataBase = self.allData[6].rstrip()
            self.username = self.allData[8].rstrip()
            self.password = self.allData[10].rstrip()
            self.autocommit = self.allData[12].rstrip()
            self.search_path = self.allData[14].rstrip()


def NULLCheck(myParameter,nameOfParameter,myMessege):
    '''
    This function checks the None values.
    None, '', and "" are all the same.
    :param myParameter: The value that we want to check.
    :param nameOfParameter: The name of variable in the form.
    :param myMessege: More description at the end of the "None" message.
    :return:
    '''
    if myParameter is None  or myParameter==""or myParameter=='':
        return "der Parameter " + nameOfParameter + " ist NULL oder nicht ausgefüllt. Dies ist unzulässig! " +myMessege
    return []
def rangeNumber(type,standard,myNumber,max,min,nameOfParameter,myMessege):
    '''
    This function checks the range.
    :param standard: The standard value comes from the protocols, such as -9 or 0.
    :param myNumber: The value that we want to check.
    :param max: The Maximum value of the range.
    :param min: The Minimum value of the range.
    :param nameOfParameter: The name of the variable in the form.
    :param myMessege: More description at the end of the "out of range" message.
    :return: It returns [] if the value is in the range or it returns 'out of range message + myMessege' if the value is out of the range.
    '''
    if myNumber is None or myNumber =='':
        return []
    if type=="date":
        dateTemp=dateClass(myNumber)
        if dateTemp.checkFormat():
            myNumber=dateTemp.returnDateString()
        else:
            return "Format fehlgeschlagen"
    if type=="time":
        timeTemp=timeClass(myNumber)
        if timeTemp.checkFormat24():
            return []
        else:
            return "Format fehlgeschlagen"
    if type=="duration":
        timeTemp=timeClass(myNumber)
        if timeTemp.checkFormat():
            return []
        else:
            return "Format fehlgeschlagen"
    if standard !="Nein":
        if float(myNumber)==float(standard):
            return []
    if min=='N' and max=='J':
        if myNumber=='N' or myNumber=='J':
            return []
        else:
            return "der Parameter " + nameOfParameter + " liegt außerhalb des erlaubten Bereichs.(" + str(min) + " <> " + str(myNumber) + " or " + str(max) + " <> " + str(myNumber) + ")." + myMessege

    if float(myNumber)>float(max) or float(myNumber)<float(min):
        return "der Parameter "+nameOfParameter+" liegt außerhalb des erlaubten Bereichs.("+str(min)+"<"+str(myNumber)+"<"+str(max)+")."+myMessege
    return []



def checkingRangeTRIP(year, trip_number, eunr, vessel_name, vessel_sign, start_date, end_date, start_loc, end_loc,
                      observer, trip_valid, trip_type):
    '''
    This function is the main function. The parameters are passed to the function as values, not lists.
    The function returns three lists.
    The first list: Includes the name of the value(s) which is/are either None or out of the range.
    The second list: Indicates the importance (fatal, severe, warning) of the value(s) of the first list, which is/are either None or out of the range.
    The third list: Includes the description message(s) for every "out of range" or "None" value(s).
    :param year: int
    :param trip_number: int
    :param eunr: varchar
    :param vessel_name: varchar
    :param vessel_sign: varchar
    :param start_date: date
    :param end_date: date
    :param start_loc: varchar
    :param end_loc: varchar
    :param observer: varchar
    :param trip_valid: varchar
    :param trip_type: varchar
    :return:
    '''
    RangeTRIP=RangClass('TRIP')
    dataTRIP=dataTRIPClass()
    dataTRIP.input(year, trip_number, eunr, vessel_name, vessel_sign, start_date, end_date, start_loc, end_loc, observer, trip_valid, trip_type)
    dataBaseConnection.readEu_registerTable(dataBaseConnection(dataBaseConnection.connectionClass()))
    listOutOfRange = []
    listErrorType=[]
    listNameParameter=[]

    result=[]

    for rangeItem in RangeTRIP.MyRangeData.__iter__():
        if rangeItem.mandatory == 'J':
            result = NULLCheck(dataTRIP.name2value(rangeItem.Name),rangeItem.Name, rangeItem.error_message1)
        if result!=[]:
            listOutOfRange.append(result)
            listErrorType.append(rangeItem.error_type)
            listNameParameter.append(rangeItem.Name)
            result = []

    for rangeItem in RangeTRIP.MyRangeData.__iter__():
        if rangeItem.Range == 'J':
            if rangeItem.Name=="eunr":
                if not dataBaseConnection.findInCFR(dataTRIP.name2value(rangeItem.Name)):
                    result = rangeItem.error_message2
            else:
                result = rangeNumber(rangeItem.Type,rangeItem._9, dataTRIP.name2value(rangeItem.Name), (rangeItem.Range_max),
                                     (rangeItem.Range_min), rangeItem.Name,rangeItem.error_message2)
        if result!=[]:
            listOutOfRange.append(result)
            listErrorType.append(rangeItem.error_type)
            listNameParameter.append(rangeItem.Name)
            result = []



    return [listNameParameter,listErrorType,listOutOfRange]

def checkingRangeHAUL_FO(year, quarter, month, haul, fo_start_date, fo_start_time, fo_end_date, fo_end_time,
                      fishing_duration, fo_start_lat, fo_start_lon, fo_stop_lat, fo_stop_lon, fishing_distance,
                      country, area_national, fao_area, rectangle):
    '''
        This function is the main function. The parameters are passed to the function as values, not lists.
    The function returns three lists.
    The first list: Includes the name of the value(s) which is/are either None or out of the range.
    The second list: Indicates the importance (fatal, severe, warning) of the value(s) of the first list, which is/are either None or out of the range.
    The third list: Includes the description message(s) for every "out of range" or "None" value(s).
    :param year:
    :param quarter:
    :param month:
    :param haul:
    :param fo_start_date:
    :param fo_start_time:
    :param fo_end_date:
    :param fo_end_time:
    :param fishing_duration:
    :param fo_start_lat:
    :param fo_start_lon:
    :param fo_stop_lat:
    :param fo_stop_lon:
    :param fishing_distance:
    :param country:
    :param area_national:
    :param fao_area:
    :param rectangle:
    :return:
    '''
    RangeHAUL_FO=RangClass('HAUL_FO')
    dataHAUL_FO=dataHAUL_FOClass()
    dataHAUL_FO.input(year, quarter, month, haul, fo_start_date, fo_start_time, fo_end_date, fo_end_time, fishing_duration,
                   fo_start_lat, fo_start_lon, fo_stop_lat, fo_stop_lon, fishing_distance, country, area_national,
                   fao_area, rectangle)
    dataBaseConnection.readEu_registerTable(dataBaseConnection(dataBaseConnection.connectionClass()))
    listOutOfRange = []
    listErrorType=[]
    listNameParameter=[]

    result=[]

    if dataHAUL_FO.name2value("rectangle") == None or dataHAUL_FO.name2value("rectangle") == "":
        if (dataHAUL_FO.name2value("fo_start_lat") == None or dataHAUL_FO.name2value("fo_start_lon") == "") and \
                (dataHAUL_FO.name2value("fo_stop_lat") == None or dataHAUL_FO.name2value("fo_stop_lat") == ""):
            for rangeItem in RangeHAUL_FO.MyRangeData.__iter__():
                if rangeItem.Name == "fo_start_lat":
                    rangeItem.mandatory = 'J'
                    rangeItem.error_type = ""
                if rangeItem.Name == "fo_start_lon":
                    rangeItem.mandatory = 'J'
                if rangeItem.Name == "fo_stop_lat":
                    rangeItem.mandatory = 'J'
                if rangeItem.Name == "fo_stop_lon":
                    rangeItem.mandatory = 'J'




    for rangeItem in RangeHAUL_FO.MyRangeData.__iter__():
        if rangeItem.mandatory == 'J':
            result = NULLCheck(dataHAUL_FO.name2value(rangeItem.Name),rangeItem.Name, rangeItem.error_message1)
        if result!=[]:
            listOutOfRange.append(result)
            listErrorType.append(rangeItem.error_type)
            listNameParameter.append(rangeItem.Name)
            result = []

    for rangeItem in RangeHAUL_FO.MyRangeData.__iter__():
        if rangeItem.Range == 'J':

            result = rangeNumber(rangeItem.Type,rangeItem._9, dataHAUL_FO.name2value(rangeItem.Name), (rangeItem.Range_max),
                                     (rangeItem.Range_min), rangeItem.Name,rangeItem.error_message2)
        if result != []:
            listOutOfRange.append(result)
            listErrorType.append(rangeItem.error_type)
            listNameParameter.append(rangeItem.Name)
            result = []

        if rangeItem.value=='J':
            if rangeItem.Name=="month" and rangeItem.value_allowed=="month_quarter":
               if dataHAUL_FO.name2value("quarter") == 1 and not dataHAUL_FO.name2value(rangeItem.Name) in [1, 2, 3]:
                   listOutOfRange.append("Out of range the quarter or the month")
                   listErrorType.append(rangeItem.error_type)
                   listNameParameter.append(rangeItem.Name)
               if dataHAUL_FO.name2value("quarter") == 2 and not dataHAUL_FO.name2value(rangeItem.Name) in [4, 5, 6]:
                   listOutOfRange.append("Out of range the quarter or the month")
                   listErrorType.append(rangeItem.error_type)
                   listNameParameter.append(rangeItem.Name)
               if dataHAUL_FO.name2value("quarter") == 3 and not dataHAUL_FO.name2value(rangeItem.Name) in [7, 8, 9]:
                   listOutOfRange.append("Out of range the quarter or the month")
                   listErrorType.append(rangeItem.error_type)
                   listNameParameter.append("quarter")
               if dataHAUL_FO.name2value(rangeItem.Name) == 4 and not dataHAUL_FO.name2value(rangeItem.Name) in [10, 11, 12]:
                   listOutOfRange.append("Out of range the quarter or the month")
                   listErrorType.append(rangeItem.error_type)
                   listNameParameter.append(rangeItem.Name)
            if rangeItem.Name == "country":
                if not (dataHAUL_FO.name2value(rangeItem.Name).find(',') == -1 and rangeItem.value_allowed.find(dataHAUL_FO.name2value(rangeItem.Name))!= -1):
                    listOutOfRange.append(rangeItem.error_message2)
                    listErrorType.append(rangeItem.error_type)
                    listNameParameter.append(rangeItem.Name)
                else:
                    if dataHAUL_FO.name2value(rangeItem.Name) != 'GFR':
                        listOutOfRange.append(rangeItem.error_message2)
                        listErrorType.append('warning')
                        listNameParameter.append(rangeItem.Name)

            if rangeItem.Name == "fao_area":
                if not (dataHAUL_FO.name2value(rangeItem.Name).find(';') == -1 and rangeItem.value_allowed.find(dataHAUL_FO.name2value(rangeItem.Name))!= -1):
                    listOutOfRange.append(rangeItem.error_message2)
                    listErrorType.append(rangeItem.error_type)
                    listNameParameter.append(rangeItem.Name)

            #if rangeItem.Name == "area_rectangle":
            #    flag = False
            #    for Item in RangeHAUL_FO.MyAreaRectangleData.__iter__():
            #        if dataHAUL_FO.name2value("fao_area") == Item.area_code:
            #            flag = True
            #            break
            #    if not flag:
            #        listOutOfRange.append(rangeItem.error_message2)
            #        listErrorType.append(rangeItem.error_type)
            #        listNameParameter.append(rangeItem.Name)

            if rangeItem.value_allowed == "area_rectangle":
                if dataHAUL_FO.name2value("fao_area") != None and dataHAUL_FO.name2value("fao_area") != "":
                    flag = False
                    for Item in RangeHAUL_FO.MyAreaRectangleData.__iter__():
                        if dataHAUL_FO.name2value("fao_area") == Item.area_code:
                            for ItemRec in Item.allowed_rectangle:
                                if ItemRec == dataHAUL_FO.name2value("rectangle"):
                                    flag = True
                                    break
                    if not flag:
                        listOutOfRange.append(rangeItem.error_message2)
                        listErrorType.append(rangeItem.error_type)
                        listNameParameter.append(rangeItem.Name)
    return [listNameParameter,listErrorType,listOutOfRange]

def checkingRangeHAUL_GEAR(fishing_depth_min, fishing_depth_max, water_depth, gear_national, metier_lvl_5, metier_lvl_6,
                         gear, mesh_size_range, selection_device, selection_device_mesh, target_species_group,
                         target_species, number_species, total_catch, gear_addition, mesh_size, codend_mesh_size,
                         footrope, footrope_length, jager_length, net_board_dist, net_horizontal, net_vertical,
                         net_girth, curl_line_length, roller_diameter, beam_length, beam_chains, setnet_number,
                         setnet_length, setnet_height, setnet_total_length, pinger, pinger_type, hooks, traps):
    '''
            This function is the main function. The parameters are passed to the function as values, not lists.
    The function returns three lists.
    The first list: Includes the name of the value(s) which is/are either None or out of the range.
    The second list: Indicates the importance (fatal, severe, warning) of the value(s) of the first list, which is/are either None or out of the range.
    The third list: Includes the description message(s) for every "out of range" or "None" value(s).

    :param fishing_depth_min:
    :param fishing_depth_max:
    :param water_depth:
    :param gear_national:
    :param metier_lvl_5:
    :param metier_lvl_6:
    :param gear:
    :param mesh_size_range:
    :param selection_device:
    :param selection_device_mesh:
    :param target_species_group:
    :param target_species:
    :param number_species:
    :param total_catch:
    :param gear_addition:
    :param mesh_size:
    :param codend_mesh_size:
    :param footrope:
    :param footrope_length:
    :param jager_length:
    :param net_board_dist:
    :param net_horizontal:
    :param net_vertical:
    :param net_girth:
    :param curl_line_length:
    :param roller_diameter:
    :param beam_length:
    :param beam_chains:
    :param setnet_number:
    :param setnet_length:
    :param setnet_height:
    :param setnet_total_length:
    :param pinger:
    :param pinger_type:
    :param hooks:
    :param traps:
    :return:
    '''
    RangeHAUL_GEAR=RangClass('HAUL_GEAR')
    dataHAUL_GEAR=dataHAUL_GEARClass()
    dataHAUL_GEAR.input(fishing_depth_min, fishing_depth_max, water_depth, gear_national, metier_lvl_5, metier_lvl_6,
                        gear, mesh_size_range, selection_device, selection_device_mesh, target_species_group,
                        target_species, number_species, total_catch, gear_addition, mesh_size, codend_mesh_size,
                        footrope, footrope_length, jager_length, net_board_dist, net_horizontal, net_vertical,
                        net_girth, curl_line_length, roller_diameter, beam_length, beam_chains, setnet_number,
                        setnet_length, setnet_height, setnet_total_length, pinger, pinger_type, hooks, traps)
    dataBaseConnection.readEu_registerTable(dataBaseConnection(dataBaseConnection.connectionClass()))
    listOutOfRange = []
    listErrorType=[]
    listNameParameter=[]

    result=[]

    for rangeItem in RangeHAUL_GEAR.MyRangeData.__iter__():
        if rangeItem.mandatory == 'J':
            result = NULLCheck(dataHAUL_GEAR.name2value(rangeItem.Name),rangeItem.Name, rangeItem.error_message1)
        if result!=[]:
            listOutOfRange.append(result)
            listErrorType.append(rangeItem.error_type)
            listNameParameter.append(rangeItem.Name)
            result = []

    for rangeItem in RangeHAUL_GEAR.MyRangeData.__iter__():
        if rangeItem.Range == 'J':

            result = rangeNumber(rangeItem.Type,rangeItem._9, dataHAUL_GEAR.name2value(rangeItem.Name), (rangeItem.Range_max),
                                     (rangeItem.Range_min), rangeItem.Name,rangeItem.error_message2)
        if result!=[]:
            listOutOfRange.append(result)
            listErrorType.append(rangeItem.error_type)
            listNameParameter.append(rangeItem.Name)
            result = []



    return [listNameParameter,listErrorType,listOutOfRange]

def checkingRangeHAUL_ENVIR(wind_speed, wind_direction, cloud_cover, temperature_air, temperature_water, weather, light,
                            currents, comments):
    '''
            This function is the main function. The parameters are passed to the function as values, not lists.
    The function returns three lists.
    The first list: Includes the name of the value(s) which is/are either None or out of the range.
    The second list: Indicates the importance (fatal, severe, warning) of the value(s) of the first list, which is/are either None or out of the range.
    The third list: Includes the description message(s) for every "out of range" or "None" value(s).
    :param wind_speed:
    :param wind_direction:
    :param cloud_cover:
    :param temperature_air:
    :param temperature_water:
    :param weather:
    :param light:
    :param currents:
    :param comments:
    :return:
    '''
    RangeHAUL_ENVIR=RangClass('HAUL_ENVIR')
    dataHAUL_ENVIR=dataHAUL_ENVIRClass()
    dataHAUL_ENVIR.input(wind_speed, wind_direction, cloud_cover, temperature_air, temperature_water, weather, light, currents, comments)
    dataBaseConnection.readEu_registerTable(dataBaseConnection(dataBaseConnection.connectionClass()))
    listOutOfRange = []
    listErrorType=[]
    listNameParameter=[]

    result=[]

    for rangeItem in RangeHAUL_ENVIR.MyRangeData.__iter__():
        if rangeItem.mandatory == 'J':
            result = NULLCheck(dataHAUL_ENVIR.name2value(rangeItem.Name),rangeItem.Name, rangeItem.error_message1)
        if result!=[]:
            listOutOfRange.append(result)
            listErrorType.append(rangeItem.error_type)
            listNameParameter.append(rangeItem.Name)
            result = []

    for rangeItem in RangeHAUL_ENVIR.MyRangeData.__iter__():
        if rangeItem.Range == 'J':

            result = rangeNumber(rangeItem.Type,rangeItem._9, dataHAUL_ENVIR.name2value(rangeItem.Name), (rangeItem.Range_max),
                                     (rangeItem.Range_min), rangeItem.Name,rangeItem.error_message2)
        if result!=[]:
            listOutOfRange.append(result)
            listErrorType.append(rangeItem.error_type)
            listNameParameter.append(rangeItem.Name)
            result = []



    return [listNameParameter,listErrorType,listOutOfRange]