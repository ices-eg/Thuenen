##### die beiden all_vessel Tabellen zusammenführen, Metiers berechnen und effort korrigieren.
drop table if exists all_vessel_ce_cl_join;
create table if not exists all_vessel_ce_cl_join

select * from commercial_sample_process.small_vessel_ce_cl union select * from commercial_sample_process.large_vessel_ce_cl;


ALTER TABLE `all_vessel_ce_cl_join` ADD `metier_correct` VARCHAR(25) NOT NULL AFTER `metier`;
ALTER TABLE `all_vessel_ce_cl_join` ADD INDEX `index` (jahr, eunr, reisenr, fangnr, landnr, fao_gebiet, fischart);

#######################################
### Metier laut Baltic_metier Richtlinien einfügen


update commercial_fishery_process.all_vessel_ce_cl_join a set a.metier_correct = (SELECT b.metier 

from commercial_parameter.baltic_metier b 

where  a.geraet = b.gear_code
and a.target_assemblage = b.target_assemblage
and right(a.fao_gebiet, 2) between b.area_min and b.area_max
and a.masche between b.mesh_open_min and b.mesh_open_max
and b.valid_to = '2099-12-31');

##### Metier für Area 28.2 ergänzen 

update commercial_fishery_process.all_vessel_ce_cl_join a set a.metier_correct = (SELECT b.metier 

from commercial_parameter.baltic_metier b 

where  a.geraet = b.gear_code
and a.target_assemblage = b.target_assemblage
and mid(a.fao_gebiet,8, 2) between b.area_min and b.area_max
and a.masche between b.mesh_open_min and b.mesh_open_max
and b.valid_to = '2099-12-31')

where a.fao_gebiet = '27.3.d.28.2';


######################################
### die übrigen Metier korrekt übersetzen

update all_vessel_ce_cl_join a set a.metier_correct = 'GNS_ANA_>=157_0_0'
				where a.metier = 'GNS_ANA_>=157_0_0' and a.metier_correct = '' ;

update all_vessel_ce_cl_join a set a.metier_correct = 'GNS_CAT_>0_0_0'
				where a.metier = 'GNS_CAT_>0_0_0' and a.metier_correct = '' ;

update all_vessel_ce_cl_join a set a.metier_correct = 'GNS_FWS_>0_0_0'
				where a.metier = 'GNS_FWS_>0_0_0' and a.metier_correct = '' ;

update all_vessel_ce_cl_join a set a.metier_correct = 'GNS_DEF_110-156_0_0'
				where a.metier = 'GNS_DEF_110-156_0_0' and a.metier_correct = '' ;
				
update all_vessel_ce_cl_join a set a.metier_correct = 'FPO_SPF_>0_0_0'
				where a.metier = 'FPO_SPF_>0_0_0' and a.metier_correct = '' ;
				
update all_vessel_ce_cl_join a set a.metier_correct = 'FPO_CAT_>0_0_0'
				where a.metier = 'FPO_CAT_>0_0_0' and a.metier_correct = '' ;

update all_vessel_ce_cl_join a set a.metier_correct = 'FPO_FWS_>0_0_0'
				where a.metier = 'FPO_FWS_>0_0_0' and a.metier_correct = '' ;
				
update all_vessel_ce_cl_join a set a.metier_correct = 'FPO_DEF_>0_0_0'
				where a.metier = 'FPO_DEF_>0_0_0' and a.metier_correct = '' ;

update all_vessel_ce_cl_join a set a.metier_correct = 'FPO_ANA_>0_0_0'
				where a.metier = 'FPO_ANA_>0_0_0' and a.metier_correct = '' ;

update all_vessel_ce_cl_join a set a.metier_correct = 'GNS_SPF_32-109_0_0'
				where a.metier = 'GNS_SPF_32-109_0_0' and a.metier_correct = '' ;				
				
###############################################
### die 'FIF' Metiers zuordnen


update all_vessel_ce_cl_join set `metier_correct` = 
concat
  (geraet_register, '_', target_assemblage,'_',
  
 
 (case when(left(metier,7) = 'GNS_FIF' AND target_assemblage = 'DEF') then ('110-156_0_0') 
       when(left(metier,7) = 'GTR_FIF' AND target_assemblage = 'DEF') then ('110-156_0_0') 
       when(left(metier,7) = 'GNS_FIF' AND target_assemblage = 'SPF') then ('32-109_0_0') 
       when(left(metier,7) = 'GNS_FIF' AND target_assemblage = 'ANA') then ('>=157_0_0')
       when(left(metier,7) = 'GNS_FIF' AND target_assemblage = 'FWS') then ('>0_0_0')  
       
       when(left(metier,7) = 'OTB_FIF' AND target_assemblage = 'DEF' AND masche >100) then ('>=105_1_120')
       when(left(metier,7) = 'OTB_FIF' AND target_assemblage = 'DEF' AND masche <100) then ('90-104_0_0')
       when(left(metier,7) = 'OTB_FIF' AND target_assemblage = 'SPF' AND masche >32) then ('32-104_0_0')
       when(left(metier,7) = 'OTB_FIF' AND target_assemblage = 'SPF' AND masche <32) then ('16-31_0_0')
  
       when(left(metier,7) = 'PTB_FIF' AND target_assemblage = 'DEF' AND masche >100) then ('>=105_1_120')
       when(left(metier,7) = 'PTB_FIF' AND target_assemblage = 'DEF' AND masche <100) then ('90-104_0_0')
  
       when(left(metier,7) = 'PTM_FIF' AND target_assemblage = 'DEF' AND masche >100) then ('>=105_1_120')
       when(left(metier,7) = 'PTM_FIF' AND target_assemblage = 'DEF' AND masche <100) then ('90-104_0_0')

       when(left(metier,7) = 'SSC_FIF' AND target_assemblage = 'DEF' AND masche >100) then ('>=105_1_120')
       when(left(metier,7) = 'SSC_FIF' AND target_assemblage = 'DEF' AND masche <100) then ('90-104_0_0')
  
       when(left(metier,7) = 'FPO_FIF') then ('>0_0_0')
       when(left(metier,7) = 'FIX_FIF') then ('>0_0_0')
   
       else('>0_0_0') end
   )) 
   
   WHERE `metier_correct` = ''  and mid(metier,5,3) = 'FIF';
   
 ### Abgleich am Ende, zur Vorsicht 
update `all_vessel_ce_cl_join` set metier_correct = metier WHERE metier_correct = '' 
				


####################
### Spalten umbenennen

ALTER TABLE all_vessel_ce_cl_join CHANGE `land_quartal` `quartal` int(1);
ALTER TABLE all_vessel_ce_cl_join CHANGE `land_monat` `monat` int(2);
ALTER TABLE all_vessel_ce_cl_join CHANGE `geraet_register` `geraet` varchar(10);

####################
#### letzte Felder updaten

update `all_vessel_ce_cl_join` b 
   set b.anzahl_hols_reise = (select a.anzahl 
													from (SELECT reisenr, count(distinct fangnr) as anzahl FROM `all_vessel_ce_cl_join` group by reisenr) a  
													   where a.reisenr = b.reisenr);






#####################													   
###  bms und dis aus dem logbuch ergänzen 
													   
		update all_vessel_ce_cl_join a set a.bms = (select sum(b.bms) from commercial_fishery_final.LOGBUCH_FIT b where a.jahr = b.jahr 
and a.reisenr = b.reisenr 
and a.fangnr = b.fangnr 
and a.fischart = b.fischart group by a.jahr, a.reisenr, a.fangnr, b.fischart);											   
													   
update all_vessel_ce_cl_join a set a.dis = (select sum(b.dis) from commercial_fishery_final.LOGBUCH_FIT b where a.jahr = b.jahr 
and a.reisenr = b.reisenr 
and a.fangnr = b.fangnr 
and a.fischart = b.fischart group by a.jahr, a.reisenr, a.fangnr, b.fischart);


########
update `all_vessel_ce_cl_join` set metier_correct = 'GNS_DEF_>=157_0_0' WHERE metier_correct = 'GNS_DEF_110-156_0_0' and masche >157;

update `all_vessel_ce_cl_join` set metier_correct = 'GTR_DEF_>=157_0_0' WHERE metier_correct = 'GTR_DEF_110-156_0_0' and masche >157;



SELECT geraet, sum(lsc)/1000, sum(bms)/1000, sum(`dis`)/1000 FROM `LOGBUCH_FIT` WHERE fischart = 'COD' and fao_gebiet = '27.3.d.24' and quarter(`fangdatb`) = 4 and geraet in ('OTB', 'PTB') group by geraet


















