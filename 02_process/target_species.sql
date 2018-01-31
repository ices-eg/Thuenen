-- ------------------------------------------------------------------------------------------------------------------------------
-- -------- Landing species for all sampled trips (as listed in the cruisematch - ble_reisenr is needed) ------------------------

select
  cm.osf_reise,
  an3.JAHR,
  an3.EUNR,
  an3.REISENR,
  an3.FISCHART,
  an3.LANDKG
from
  com_sample_process.cruise_match cm 
left join
(select
   an.JAHR,
   an.EUNR,
   an.REISENR,
   an.FISCHART,
   an2.LANDKG
                    
 from com_fishery_final.ANLANDUNG an					
 inner join 
    (select JAHR, EUNR, REISENR, FISCHART, max(LANDKG) as LANDKG 
     from `commercial_fishery_final`.`ANLANDUNG`
     group by JAHR, EUNR, REISENR
    ) an2
 on  an.JAHR = an2.JAHR
     and an.EUNR = an2.EUNR 
     and an.REISENR = an2.REISENR

     and an.LANDKG = an2.LANDKG
) an3
on
  cm.ble_reise = an3.REISENR
  and cm.eunr = an3.EUNR	

 -- ----------------------------------------------------------------------------------
 -- ------- Landing species per trip (all trips, not only sampled ones) --------------

-- There is a possibility to get more than one target species for 1 cruise
-- has to be taken in account for e.g. all_vessels_for_cl !!

-- workaround by U. Berth Updating with all records -> last one wins

CREATE TABLE com_fishery_process.target_species AS
SELECT
  an.JAHR,
  an.EUNR,
  an.REISENR,
  an.FISCHART,
  an.FANGKG,
  an.ERLOES,
  an.FANGKG * 1000000 + COALESCE(an.ERLOES,0) as ranking
FROM
  com_fishery_final.anlandung an
LEFT JOIN
(
    SELECT
      JAHR,
      EUNR,
      REISENR,  
      max(FANGKG * 1000000 + COALESCE(ERLOES,0)) as ranking
    FROM com_fishery_final.anlandung
    GROUP BY JAHR,EUNR,REISENR
) max_an ON an.JAHR = max_an.JAHR AND
            an.EUNR = max_an.EUNR AND
            an.REISENR = max_an.REISENR AND
            an.FANGKG * 1000000 + COALESCE(an.ERLOES,0) = max_an.ranking
WHERE max_an IS NOT NULL;

