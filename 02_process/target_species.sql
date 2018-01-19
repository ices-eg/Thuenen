######################################################################################################
######## Landing species for all sampled trips (as listed in the cruisematch - ble_reisenr is needed) ########################

select
cm.osf_reise,
an3.JAHR,
an3.EUNR,
an3.REISENR,
an3.FISCHART,
an3.LANDKG

from
commercial_sample_process.cruisematch cm 
left join
(select
 an.JAHR,
 an.EUNR,
 an.REISENR,
 an.FISCHART,
 an2.LANDKG
                    
from `commercial_fishery_final`.`ANLANDUNG` an
					
inner join 
    (select JAHR, EUNR, REISENR, FISCHART, max(LANDKG) as LANDKG 
	from `commercial_fishery_final`.`ANLANDUNG`
	group by JAHR, EUNR, REISENR
    )an2

on  an.JAHR = an2.JAHR
and an.EUNR = an2.EUNR 
and an.REISENR = an2.REISENR

and an.LANDKG = an2.LANDKG) an3
	
on
 cm.ble_reise = an3.REISENR
and
 cm.eunr = an3.EUNR	

 ######################################################################
 ########## Landing species per trip (all trips, not only sampled ones) ##############
 
 select
cm.JAHR,
cm.EUNR,
cm.REISENR,
an3.FISCHART,
an3.FANGKG

from
`commercial_fishery_final`.`ANLANDUNG` cm 
left join
(select
 an.JAHR,
 an.EUNR,
 an.REISENR,
 an.FISCHART,
 an2.FANGKG
                    
from `commercial_fishery_final`.`ANLANDUNG` an
					
inner join 
    (select JAHR, EUNR, REISENR, FISCHART, max(FANGKG) as FANGKG 
	from `commercial_fishery_final`.`ANLANDUNG`
	group by JAHR, EUNR, REISENR
    )an2

on  an.JAHR = an2.JAHR
and an.EUNR = an2.EUNR 
and an.REISENR = an2.REISENR

and an.FANGKG = an2.FANGKG) an3
	
on
 cm.REISENR = an3.REISENR
and
 cm.EUNR = an3.EUNR
 
 group by cm.REISENR, cm.EUNR, an3.FISCHART, an3.FANGKG