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

DROP TABLE IF EXISTS com_fishery_process.target_species;
CREATE TABLE com_fishery_process.target_species AS
SELECT 
  an.jahr,
  an.eunr,
  an.reisenr,
  an.unterbereich,
  an.fischart,
  an.geraet,
  an.masche,
  an.metier,
  an.fangkg,
  an.erloes,
  an.ranking,
  an.ordnung
FROM
(
    with an_ranked as 
    (
        SELECT DISTINCT
          an.jahr,
          an.landdat,
          an.unterbereich,
          an.eunr,
          COALESCE(COALESCE(lb.geraet,eur."Gear Main Code"),eur_ret."Gear Main Code") as geraet,
          lb.masche,
          an.reisenr,
          an.fischart,
          bm.metier,
          sum(an.fangkg) as fangkg,
          sum(an.erloes) as erloes,
          CASE WHEN bm.metier IS NOT NULL THEN 100000000000000 ELSE 0 END + sum(COALESCE(an.fangkg,0)) * 1000000 + sum(COALESCE(erloes,0)) as ranking
        FROM 
          com_fishery_final.anlandung an
        LEFT JOIN com_fishery_final.logbuch lb
        ON an.JAHR = lb.JAHR AND
                    an.REISENR = lb.REISENR AND
                    an.EUNR = lb.EUNR AND
                    an.fischart = lb.fischart
        LEFT JOIN com_fishery_final.eu_register eur ON an.eunr = eur."CFR" 
                                                        AND (an.jahr * 10000) + (extract(month from an.landdat) * 100)+extract(day from an.landdat) BETWEEN eur."Event Start Date" AND eur."Event End Date"
        LEFT JOIN com_fishery_final.eu_register eur_ret ON an.eunr = eur_ret."CFR" AND eur_ret."Event Code" = 'RET'
        LEFT JOIN com_parameter.baltic_metier bm 
                   ON an.landdat BETWEEN bm.valid_from AND valid_to
                   AND COALESCE(COALESCE(lb.geraet,eur."Gear Main Code"),eur_ret."Gear Main Code") = bm.gear_code
                   AND regexp_replace(an.fischart, '\s+$', '') IN (SELECT trim(unnest(string_to_array(bm.target_species_list,'.'))))
                   AND ((lb.masche BETWEEN bm.mesh_open_min AND bm.mesh_open_max) OR lb.masche IS NULL)
                   AND CASE WHEN an.unterbereich = 'n' THEN 20
                     WHEN an.unterbereich = 's' THEN 21
                     ELSE an.unterbereich::integer END
                     BETWEEN bm.area_min AND bm.area_max
        -- WHERE bm.metier is not null
        GROUP BY an.jahr,
          an.eunr,
          an.landdat,
          an.unterbereich,
          COALESCE(COALESCE(lb.geraet,eur."Gear Main Code"),eur_ret."Gear Main Code"),
          lb.masche,
          an.reisenr,
          an.fischart,
          bm.metier
        -- ORDER BY an.reisenr, CASE WHEN bm.metier IS NOT NULL THEN 100000000000000 ELSE 0 END + sum(an.fangkg) * 1000000 + sum(erloes) DESC
    ) 
    SELECT 
      an.*,
      row_number() OVER (PARTITION BY an.JAHR,an.EUNR,an.REISENR) as ordnung
    FROM an_ranked an 
    INNER JOIN
    (
        SELECT 
          jahr,
          eunr,
          reisenr,
          max(ranking) as max_ranking
        FROM an_ranked
        GROUP BY jahr,eunr,reisenr
    ) max_rank ON an.jahr = max_rank.jahr AND
                  an.eunr = max_rank.eunr AND
                  an.reisenr = max_rank.reisenr AND
                  an.ranking = max_rank.max_ranking
    ) an
    ORDER BY jahr,eunr,reisenr,ordnung
;
