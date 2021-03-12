import checking_ranges


year=2012
trip_number=10329
eunr="DEU000020614"
vessel_name="MB–WE"
vessel_sign="FXX3"
start_date="2018-09-10"
end_date="2018-09-11"
start_loc=""
end_loc="FREXXX"
observer="XXX"
trip_valid='t'
trip_type=None



listNameParameter,listErrorType,listOutOfRange = checking_ranges.checkingRangeTRIP(year, trip_number, eunr, vessel_name,
                                                                                 vessel_sign, start_date, end_date,
                                                                                 start_loc, end_loc, observer,
                                                                                 trip_valid,trip_type)

print(listNameParameter)
print(listOutOfRange)