-- create FishFrame tables 
-- TR, HH, SL, HL and CA 


-- TR: Trip overview and vessel information
-- missing values in harbour and landing country occur in those entries not having a BLE number in cruisematch 

drop table if exists com_fishframe.tr ;

CREATE TABLE IF NOT EXISTS com_fishframe.tr

 'TR' as `Record_type`,
  'S' as `Sampling_type`,
  (case when (left(re.RUECKORT,2)='DE') then ('DEU')
			when (left(re.RUECKORT,2)='DK') then ('DNK')
			when (left(re.RUECKORT,2)='SE') then ('SWE')
			when (left(re.RUECKORT,2)='PL') then ('POL')
   end)  as `Landing_country`,
  'DEU' as `Vessel_flag_country`,
  ts.this_year as `Year`,
  'DCF-OF' as `Project`,
  cm.osf_reise as `Trip_number`,
  vt.`length` as `Vessel_length`,
  vt.`power` as `Vessel_power`,
  vt.gross as `Vessel_size`,
  vt.type_name as `Vessel_type`,
  re.RUECKORT as `Harbour`,
  count(sf.STATION) as `No_SetsHauls_on_trip`,
  cm.osf_days_at_sea+1 as `Days_at_sea`,
  vt.vessel_crypt as `Vessel_identifier`,
  'DEU' as `Sampling_country`,
  ts.sampling as `Sampling_method`


FROM
  commercial_sample_process.cruisematch_2019 cm

LEFT JOIN 
  commercial_sample_process.treat_sample_2019 ts
ON
  cm.osf_reise = ts.cruise
AND
  cm.jahr = ts.this_year 
    
  
LEFT JOIN
 commercial_fishery_final.REISE_FIT re
on
 cm.ble_reise = re.reisenr
   
  
LEFT JOIN
  commercial_sample_persist.vessel_type vt
on
  cm.eunr = vt.vessel_id
  
left join   
  commercial_sample_final.StatFi sf
ON
 cm.osf_reise = sf.REISENR 
and 
 cm.jahr = sf.JAHR   
  
  
  
  
  
WHERE
  vt.gueltig_bis = 2099
and year(vt.gueltig_bis_n) = 2018  

group by 
`Record_type`, `Sampling_type`, `Landing_country`, `Vessel_flag_country`, `Year`,  `Project`,  `Trip_number`,  `Vessel_length`, `Vessel_power`,  `Vessel_size`, `Vessel_type`,  `Harbour`, `Days_at_sea`,  `Vessel_identifier`,`Sampling_country`,`Sampling_method`


#########################################
#############################################
 
 
insert into tr_2019 SELECT 
  'TR' as `Record_type`,
  'S' as `Sampling_type`,
  (case when (left(re.RUECKORT,2)='DE') then ('DEU')
			when (left(re.RUECKORT,2)='DK') then ('DNK')
			when (left(re.RUECKORT,2)='SE') then ('SWE')
			when (left(re.RUECKORT,2)='PL') then ('POL')
   end)  as `Landing_country`,
  'DEU' as `Vessel_flag_country`,
  ts.this_year as `Year`,
  'DCF-OF' as `Project`,
  cm.osf_reise as `Trip_number`,
  round(vt.`luea`/100,2) as `Vessel_length`,
  vt.`kw` as `Vessel_power`,
  vt.brz as `Vessel_size`,
  vt.type_name as `Vessel_type`,
  re.RUECKORT as `Harbour`,
  count(sf.STATION) as `No_SetsHauls_on_trip`,
  cm.osf_days_at_sea+1 as `Days_at_sea`,
  vt.vessel_crypt as `Vessel_identifier`,
  'DEU' as `Sampling_country`,
  ts.sampling as `Sampling_method`


FROM
  commercial_sample_process.cruisematch_2019 cm

LEFT JOIN 
  commercial_sample_process.treat_sample_2019 ts
ON
  cm.osf_reise = ts.cruise
AND
  cm.jahr = ts.this_year 
    
  
LEFT JOIN
 commercial_fishery_final.REISE_FIT re
on
 cm.ble_reise = re.reisenr
   
  
LEFT JOIN
  commercial_fishframe.FIFAAKTIV_FIT_VT vt
on
  cm.eunr = vt.eunr
and cm.jahr = vt.JAHR  
  
left join   
  commercial_sample_final.StatFi sf
ON
 cm.osf_reise = sf.REISENR 
and 
 cm.jahr = sf.JAHR   
  
  
  

group by 
`Record_type`, `Sampling_type`, `Landing_country`, `Vessel_flag_country`, `Year`,  `Project`,  `Trip_number`,  `Vessel_length`, `Vessel_power`,  `Vessel_size`, `Vessel_type`,  `Harbour`, `Days_at_sea`,  `Vessel_identifier`,`Sampling_country`,`Sampling_method`

order by Trip_number

###################################



 
  
-- HH


drop table if exists hh_2019;
create table hh_2019 
SELECT 
 'HH' as `Record_type`,
  'S' as `Sampling_type`,
  tr.Landing_country,
  'DEU' as `Vessel_flag_country`,
  ts.this_year as `Year`,
  'DCF-OF' as `Project`,
  nf.REISENR as `Trip_number`,
  nf.STATION as`Station_number`,
  'V' as `Fishing_validity`,
  'H' as `Aggregation_level`,
  'All' as `Catch_registration`,
  'All' as `Species_registration`,
  nf.STATDATUM as `Date`,
  nf.SZANF as `Time`,
  nf.SCHLDAUER as `Fishing_duration`,
  round((mid(`GBFANGB`*1,5,2)/60+mid(`GBFANGB`*1,3,2)/60)+left(`GBFANGB`*1,2),5) as `Pos_Start_Lat_dec`,
  round((right(`GLFANGB`*1,2)/60+mid(`GLFANGB`*1,3,2)/60)+left(`GLFANGB`*1,2),5) as `Pos_Start_Lon_dec`,
  round((right(`GBHIEV`*1,2)/60+mid(`GBHIEV`*1,3,2)/60)+left(`GBHIEV`*1,2),5) as `Pos_Stop_Lat_dec`,
  round((right(`GLHIEV`*1,2)/60+mid(`GLHIEV`*1,3,2)/60)+left(`GLHIEV`*1,2),5) as `Pos_Stop_Lon_dec`,
  sf.SUBDIV as `Area`,
  sf.RECTANGLE as `Statistical_rectangle`,
  '' as `Sub_polygon`,
  nf.FTMAX as `Main_fishing_depth`,
  nf.TIEFEMAX as `Main_water_depth`,
  '' as `FAC_National`,
  '' as `FAC_EC_lvl5`,
  ts.metier as `FAC_EC_lvl6` ,
  ts.gear as `gear_type`,
  ts.mesh_open as `Mesh_size`,
  ts.selection as `Selection_device`,
  ts.select_mesh_open as `Mesh_size_selection_device`

FROM
  commercial_sample_final.NetzFi nf
  
LEFT JOIN 
  commercial_sample_process.treat_sample_2019  ts
on
  nf.JAHR = ts.this_year
and  
 nf.REISENR = ts.cruise 
and
 nf.STATION = ts.station 
  
LEFT JOIN 
 commercial_fishframe.tr_2019 tr
on
 tr.Trip_number = nf.REISENR
 
 
left join commercial_sample_final.StatFi sf
on nf.JAHR = sf.JAHR 
and nf.REISENR = sf.REISENR
and nf.STATION = sf.STATION

group by 

Landing_country,`Year`,`Trip_number`,`Station_number`
  

###########################################################
############ SL 

drop table if exists sl_2019;
create table sl_2019 
-- vt.vessel_id,
 'SL' as Record_type,
 'S' as Sampling_type,
 'DEU' as Landing_country,
 'DEU' as Vessel_flag_country,
 dm.Year,
 'DCF-OF' as Project,
 dm.cruise,
 dm.station,
 
-- nur zu pruefung
 dm.species,

 dm.latin_name as Species,
 dm.catch_category,
 "HUC" as Landing_category,
 '' as Comm_size_cat_scale,
 0 as Comm_size_cat,
 '' as Subsampling_category,
 '' as Sex,
-- there is no sex sample mass entry
 round(dm.total_weight * 1000, 0) as Weight,
 round(dm.sample_weight * 1000, 0) as Subsample_weight,
     
-- !!! aufpassen, wenn andere Fischarten dazukommen mit 0.5 cm genauigkeit sollen die in  "in(....)" eingetragen werden
 if(dm.species in (181,732), "scm","cm") as Length_code 

from	   
 (select *
	from
	( select 
	-- d.EU_NR as vessel_id,
       d.JAHR as Year,
	   trim(d.cruise) as cruise,
	   d.station,
	   d.species,
	   d.total_weight,
	   d.sample_weight,
	   'DIS' as Catch_category
     from
       commercial_sample_process.DiscFi_split d

    union
	 select 
    -- m.EU_NR as vessel_id,
       m.JAHR as Year,
	   trim(m.cruise) as cruise,
	   m.station,
	   m.species,
	   m.total_weight,
	   m.sample_weight,
       'LAN'as Catch_category
     from
  	   commercial_sample_process.MrktFi_split m 
    ) d

  left join
   commercial_parameter.species_code sc 
  on
   d.species = sc.bfa
 ) dm 
 
where
 dm.Year = 2019
order by 
 dm.species
 
 
 ######################################################
 ############## HL

create table hl_2019
select
-- vt.vessel_id,
 'HL' as Record_type,
 'S' as Sampling_type,
 'DEU' as Landing_country,
 'DEU' as Vessel_flag_country,
 dm.Year,
 'DCF-OF' as Project,
 dm.Trip_number,
 dm.station as Station_number,
 dm.latin_name as Species,
 dm.catch_category,
-- there is no sex sample mass entry
 "HUC" as Landing_category,
 '' as Comm_size_cat_scale,
 0 as Comm_size_cat,
 '' as Subsampling_category,
 '' as Sex,
 '' as Individual_sex,
 dm.length_class * 10 - if(dm.species in (181,732), 2.5,5) as Length_class,
 dm.length_total as Number_at_length 

from	   
 (select *
	from
	(select 
    -- d.EU_NR as vessel_id,
       d.JAHR as Year,
	   trim(d.cruise) as Trip_number,
	   d.station,
	   d.species,
	   d.length_class,
	   d.length_total,
	   d.catch_category
	 from
	  commercial_sample_process.split_length_total d
	
	)ll
  left join
    commercial_parameter.species_code sc 
  on 
    ll.species = sc.bfa
 ) dm 
 
where
 dm.Year = 2019
 ;

 
 
######################################################
############## CA
 
 
 insert into [commercial]_[fishframe]_[2011].ca

-- create table [commercial]_[fishframe]_[2011].ca_1

select  
 'CA' as Record_type,
 'S' as Sampling_type,
 'DEU' as Landing_country,
 'DEU' as Vessel_flag_country,
 tt.JAHR as Year,
 'DCF-OF' as Project,
 tt.REISENR as Trip_number,
 tt.STATION as Station_number,
 tt.QUARTAL as Quarter,
 tt.MONAT as Month,
 sc.latin_name as Species,
 if(tt.SEX <> "U", tt.SEX, '') as Sex, 
 (case when (a.landing_length_total >0) then ('LAN') 
      when (a.discard_length_total >0) then ('DIS')
 end) as Catch_category, 
 'HUC' as Landing_category, 
 '' as Comm_size_cat_scale,
 0 as Comm_size_cat, 
 stc.stock_code as Stock, 
 sf.SUBDIV as Area,
 sf.RECTANGLE as Statistical_rectangle, 
 '' as Sub_polygon,
 tt.LAENGE * 10 - if(tt.FISH in (181,732), 2.5,5) as Length_class, 
 
 tt.ALTER  as Age,
 tt.IDENTNR as Single_fish_number, 
 if(tt.FISH in (181,732),"scm", "cm") as Length_code, 

 '' as Aging_method, 
 '-' as Age_plus_group, 
 null as Otolith_weight, 
 null as Otolith_side, 
 if(tt.TOTALGEW > 0, tt.TOTALGEW, null) as Weight, 
 'Visual' as Maturity_staging_method,
 'Cod (1-5)' as Maturity_scale, 
 mc.destination_code as Maturity_stage
        
           
FROM commercial_sample_final.`SnglIOR` tt 

left join commercial_sample_process.split_length a 
 on a.JAHR = tt.JAHR
 and a.cruise = tt.REISENR 
 and a.station = tt.STATION
 and a.species = tt.FISH
 and a.length_class/10 = tt.LAENGE
		   
left join 
	    commercial_sample_final.StatFi sf 
	  on  tt.REISENR = sf.REISENR
      and tt.STATION = sf.STATION
      and tt.JAHR = sf.JAHR
	   
		   
left join
 commercial_parameter.species_code sc 
on
 tt.FISH = sc.bfa

left join 
 (select distinct
	bfa,
	source_code,
	destination_code
  from
	commercial_parameter.fishframe_maturity_code
 ) mc
on
 tt.FISH = mc.bfa
and
 tt.REIFE=mc.source_code

left join 
 commercial_parameter.stock_code stc
on  
 sc.a3_asfis = upper(trim(stc.species))
and
 sf.SUBDIV = upper(trim(stc.area))

	  where 
	  tt.JAHR = 2019

 #################################
 ########## CL 
 
 create table commercial_fishframe.cl_2019 SELECT
  'CL' as Record_type,
  left(av.Harbour,2) as Landing_country,
  'DEU' as Vessel_flag_country,
  av.year as Year,
  av.Quarter,
  av.Month,
  av.Area,
  av.Statistical_rectangle,
  '' as Sub_polygon,
  av.species,
  'HUC' as Landing_category,
  'EU' as Comm_size_cat_scale,
  0 as Comm_size_cat,
  '' as FAC_national,
  '' as FAC_EC_lvl5,
  av.metier as FAC_EC_lvl6,
  av.harbour,
  av.vessel_length_class as Vessel_length_cat,
  0 as Unallocated_catch_weight,
  0 as Area_misreported_catch_weight,
  round(sum(av.`sum_fangkg_fangnr_ort_monat`)) as official_Landings_weight,
  1 as Landings_multiplier,
  round(sum(av.`official_landings_value`)) as official_landings_value
FROM commercial_fishery_process.all_vessel_for_cl_2019 av
GROUP BY
  left(av.Harbour,2),av.year,av.Quarter,av.Month,av.Area,av.Statistical_rectangle,av.species,av.metier,av.harbour,av.vessel_length_class
 
 
#############################################################################
######### CE


DROP TABLE IF EXISTS com_fishframe.ce;
CREATE TABLE com_fishframe.ce AS


select
 'CE' as Record_type,
 'DEU' as Vessel_flag_country,
 fce.year as Year,
 fce.quarter as Quarter,
 fce.month as Month,
 fce.area as Area,
 fce.statistical_rectangle as Statistical_rectangle,
 '' as Sub_polygon,
 '' as FAC_National,
 '' as FAC_EC_lvl5,
 fce.metier_correct as FAC_EC_lvl6,
 fce.Harbour,
 fce.Vessel_length_class as Vessel_length_cat,
 count(fce.reisenr) as Number_of_trips,
 sum(fce.number_hauls) as Number_of_sets_hols,
 sum(fce.fangzeit) as Fishing_time_soaking_time,

 sum(KW*days_at_sea) as  kW_days,
 sum(BRZ*days_at_sea) as GT_days,
 sum(days_at_sea)as Days_at_sea

 FROM commercial_fishery_process.all_vessel_for_ce_2019 fce

WHERE days_at_sea IS NOT NULL AND days_at_sea > 0
GROUP BY fce.year, ceiling(fce.Month/3), fce.Month, fce.Area, fce.Statistical_rectangle, fce.metier_correct, fce.Harbour, fce.Vessel_length_class
;
 
 
 
 
 
 
 
 
 
 
 
 
 