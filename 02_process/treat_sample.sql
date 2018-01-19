
select distinct 
 obs.code as observer, 
 mid(sv.REISENR,2,2) as observer_code,
 sv.REISENR as cruise,
 sv.STATION as station,
-- nf.NETZ as net,
 '1' as net,
 sv.JAHR as this_year, 
 sc2.bfa as target_species_code,
 (select rn.FISCHART from 
   (select cm.osf_reise, ts.REISENR, ts.FISCHART 
     from commercial_sample_process.cruisematch cm 
	   left join commercial_fishery_final.target_species ts
	     on cm.ble_reise = ts.REISENR and cm.jahr = ts.JAHR)rn
		  where rn.osf_reise = sv.REISENR group by sv.REISENR) as target_species,

 sv.FISH as species_code,
 sc.a3_asfis as species,
 'U' as sex,
  (case
						when (sv.FISH = 293) then (350) ### 380 vor 2015!!!
						when (sv.FISH = 468) then (350)
						when (sv.FISH = 604) then (250)
						when (sv.FISH = 630) then (300)
						when (sv.FISH = 465) then (350)
						when (sv.FISH = 690) then (300)
						when (sv.FISH = 607) then (260)
						when (sv.FISH = 407) then (250)
						else (9999) end) as split_length_class,
 sv.sample_valid as sample_valid,
 
 
 ###### manuell auszufüllen ##############
 
 '' as treat_discard_frequency,
 '' as raising_mode,
 '' as raising_species_code,
 '' as raising_species,
 '' as sampling_factor,
 '' as treat_landing_sample,
 '' as treat_landing_frequency,
 
##################################### 
 
 pl.Kutter_1 as vessel,
 pl.Kutter_2 as pair_vessel,
 (case 
 when mid(sv.REISENR,2,2) = '03' then ('LAB') 
 when mid(sv.REISENR,2,2) = '14' then ('MUK')
 when mid(sv.REISENR,2,2) = '15' then ('BMS')
		else ('SEA') 
 end) as sample_type,
 
 pl.Beprobungsart as sampling,

 pl.Metier as metier,
 
 left(pl.Metier, 3) as gear,
 mid(pl.Metier,5,3) as target,
 '' as mesh_open,
 '' as selection,
 '' as select_mesh_open

 from
	commercial_sample_process.sample_valid sv

### Metier, Schiff und Beprobungsart ########	
 left join 
	commercial_sample_persist.Probenliste_OF pl
on 
	pl.JAHR = sv.JAHR
and
	pl.REISENR = sv.REISENR 
 
 ### Observer Codes dazu ################
 left join
	commercial_parameter.observer obs
 on 
	mid(sv.REISENR,2,2) = obs.nummer
 
### Übersetzung der FISH codes (293 -> COD) ######## 
 left join
	commercial_parameter.species_code sc
on
	sv.FISH = sc.bfa
	
left join
	commercial_parameter.species_code sc2
on
 sc2.a3_asfis =  (select rn.FISCHART from 
   (select cm.osf_reise, ts.REISENR, ts.FISCHART 
     from commercial_sample_process.cruisematch cm 
	   left join commercial_fishery_final.target_species ts
	     on cm.ble_reise = ts.REISENR and cm.jahr = ts.JAHR)rn
		  where rn.osf_reise = sv.REISENR group by sv.REISENR)	
 
 
group by 
 sv.JAHR, sv.REISENR, sv.STATION, sv.FISH, sv.sample_valid 
 