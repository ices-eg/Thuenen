import checking_ranges
from datetime import date


year=2012
trip_number=10000
eunr="DEU0000XXXXX"
vessel_name="XX–XX"
vessel_sign="FXX3"
start_date=date.fromisoformat("2018-09-10")
end_date=date.fromisoformat("2018-09-11")
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


year=2018
quarter=3
month=9
haul=1
fo_start_date=date.fromisoformat("2018-09-10")
fo_start_time="12:00:00"
fo_end_date=date.fromisoformat("2018-09-11")
fo_end_time="12:00:00"
fishing_duration="24:00:00"
fo_start_lat="541500"
fo_start_lon="0135690"
fo_stop_lat="541520"
fo_stop_lon="0135840"
fishing_distance=1
country="GFR"
area_national="OSTSEE"
fao_area="27.3.d.24"
rectangle="37G3"

listNameParameter,listErrorType,listOutOfRange = checking_ranges.checkingRangeHAUL_FO(year, quarter, month, haul,
                                                                                      fo_start_date, fo_start_time,
                                                                                      fo_end_date, fo_end_time,
                                                                                      fishing_duration, fo_start_lat,
                                                                                      fo_start_lon, fo_stop_lat,
                                                                                      fo_stop_lon, fishing_distance,
                                                                                      country, area_national, fao_area,
                                                                                      rectangle)
print(listNameParameter)


fishing_depth_min=8
fishing_depth_max=10
water_depth=10
gear_national="EINWANDNETZ"
metier_lvl_5="GNS_SPF"
metier_lvl_6="GNS_SPF_32-109_0_0"
gear="GNS"
mesh_size_range="32-109"
selection_device=0
selection_device_mesh=0
target_species_group="SPF"
target_species="630"
number_species=1
total_catch=1100
gear_addition=""
mesh_size=70
codend_mesh_size=-9
footrope=""
footrope_length=-9
jager_length=-9
net_board_dist=-9
net_horizontal=None
net_vertical=None
net_girth=-9
curl_line_length=-9
roller_diameter=-9
beam_length=-9
beam_chains=-9
setnet_number=-9
setnet_length=86
setnet_height=2
setnet_total_length=None
pinger=''
pinger_type=""
hooks=-9
traps=-9

listNameParameter,listErrorType,listOutOfRange = checking_ranges.checkingRangeHAUL_GEAR(fishing_depth_min, fishing_depth_max, water_depth, gear_national, metier_lvl_5, metier_lvl_6, gear, mesh_size_range, selection_device, selection_device_mesh, target_species_group, target_species, number_species, total_catch, gear_addition, mesh_size, codend_mesh_size, footrope, footrope_length, jager_length, net_board_dist, net_horizontal, net_vertical, net_girth, curl_line_length, roller_diameter, beam_length, beam_chains, setnet_number, setnet_length, setnet_height, setnet_total_length, pinger, pinger_type, hooks, traps)



print(listNameParameter)


wind_speed=None
wind_direction=None
cloud_cover="9"
temperature_air=None
temperature_water=None
weather="9"
light="1"
currents="9"
comments=""

listNameParameter,listErrorType,listOutOfRange = checking_ranges.checkingRangeHAUL_ENVIR(wind_speed, wind_direction, cloud_cover, temperature_air, temperature_water, weather, light, currents, comments)

print(listNameParameter)