import xlrd
import psycopg2
from datetime import date


class RangClass:
    '''The class for saving the range values.'''
    def __init__(self):
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
        for x in range(1, 13):
            self.MyRangeData.append(self.dataRangeClass(sheet.cell_value(x, 1), sheet.cell_value(x, 2), sheet.cell_value(x, 3),
                                              sheet.cell_value(x, 4), sheet.cell_value(x, 5), sheet.cell_value(x, 6),
                                              sheet.cell_value(x, 7), sheet.cell_value(x, 8), sheet.cell_value(x, 9),
                                              sheet.cell_value(x, 10), sheet.cell_value(x, 11), sheet.cell_value(x, 12),
                                              sheet.cell_value(x, 13)))

    class dataRangeClass:
        '''The class for saving the range values.'''

        def __init__(self, Name_, Type_, mandatory_, Null_, _9_, Range_, Range_min_, Range_max_, error_type_,
                     error_message1_, error2_, error_message2_, comments_):
            self.Name = Name_
            self.Type = Type_
            self.mandatory = mandatory_
            self.Null = Null_
            self._9 = _9_
            self.Range = Range_
            self.Range_min = Range_min_
            self.Range_max = Range_max_
            self.error_type = error_type_
            self.error_message1 = error_message1_
            self.error2 = error2_
            self.error_message2 = error_message2_
            self.comments = comments_
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
        if len(self.Date)!=10 or self.Date.count('-')!=2 or sum(c.isdigit() for c in self.Date)!=8:
            return False
        if self.Date[4]!='-' or self.Date[7]!='-':
            return False
        tempDate = date.fromisoformat(self.Date)
        self.day=tempDate.day
        self.month=tempDate.month
        self.year=tempDate.year
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
def checkingRangeTRIP(year, trip_number, eunr, vessel_name, vessel_sign, start_date, end_date, start_loc, end_loc, observer, trip_valid, trip_type):
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
    RangeTRIP=RangClass()
    dataTRIP=dataTRIPClass()
    dataTRIP.input(year, trip_number, eunr, vessel_name, vessel_sign, start_date, end_date, start_loc, end_loc, observer, trip_valid, trip_type)
    dataBaseConnection.readEu_registerTable(dataBaseConnection(dataBaseConnection.connectionClass()))
    listOutOfRange = []
    listErrorType=[]
    listNameParameter=[]

    result=[]

    for rangeTRIPItem in RangeTRIP.MyRangeData.__iter__():
        result = NULLCheck(dataTRIP.name2value(rangeTRIPItem.Name),rangeTRIPItem.Name, rangeTRIPItem.error_message1)
        if result!=[]:
            listOutOfRange.append(result)
            listErrorType.append(rangeTRIPItem.error_type)
            listNameParameter.append(rangeTRIPItem.Name)
            result = []

    for rangeTRIPItem in RangeTRIP.MyRangeData.__iter__():
        if rangeTRIPItem.Range == 'J':
            if rangeTRIPItem.Name=="eunr":
                if not dataBaseConnection.findInCFR(dataTRIP.name2value(rangeTRIPItem.Name)):
                    result = rangeTRIPItem.error_message2
            else:
                result = rangeNumber(rangeTRIPItem.Type,rangeTRIPItem._9, dataTRIP.name2value(rangeTRIPItem.Name), (rangeTRIPItem.Range_max),
                                     (rangeTRIPItem.Range_min), rangeTRIPItem.Name,rangeTRIPItem.error_message2)
        if result!=[]:
            listOutOfRange.append(result)
            listErrorType.append(rangeTRIPItem.error_type)
            listNameParameter.append(rangeTRIPItem.Name)
            result = []



    return [listNameParameter,listErrorType,listOutOfRange]

