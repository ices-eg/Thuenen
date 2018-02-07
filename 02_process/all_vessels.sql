DROP TABLE IF EXISTS com_fishery_process.all_vessels;
CREATE TABLE com_fishery_process.all_vessels  AS
SELECT 
  an.EUNR,
  eur."Loa" as LUEA,
  an.REISENR,
  an.unterbereich as Area,
  an.ZONE,
  an.rechteck as statistical_rectangle,
  an.jahr ,
  an.quarter,
  an."month",
  COALESCE(an.geraet,eur."Gear Main Code") as geraet,
  an.masche,
  an.species,
  an.harbour,
  CASE WHEN eur."Loa" < 10 THEN '<10'
        WHEN eur."Loa" >= 10 AND eur."Loa" < 12 THEN '10-<12'
        WHEN eur."Loa" >= 12 AND eur."Loa" < 18 THEN '12-<18'
        WHEN eur."Loa" >= 18 AND eur."Loa" < 24 THEN '18-<24'
        WHEN eur."Loa" >= 24 AND eur."Loa" < 40 THEN '24-<40'
        WHEN eur."Loa" >= 40 THEN '>=40' END AS vessel_length_class,
  NULL::float as sum_fangkg_per_month_ort,
  NULL::float as avg_trip_price,
  NULL::float as official_landings_value,
  ts.fischart as target_species,
  bm.metier as metier,
  eur."Ton Gts" as BRZ,
  eur."Power Main" as Kw,
  NULL::integer as days_at_sea,
  NULL::integer as fang_min_rgrm,
  NULL::integer as fangnumber_min_rgrm
FROM 
  (
      SELECT DISTINCT
        an.EUNR,
        an.REISENR,
        an.unterbereich,
        an.zone,
        an.rechteck,
        an.jahr,
        extract(quarter from an.landdat) as quarter,
        extract(month from an.landdat) as "month",
        lb.geraet,
        lb.masche,
        an.fischart as species,
        an.landort as harbour
      FROM com_fishery_final.anlandung an 
      LEFT JOIN  com_fishery_final.logbuch lb
         ON an.JAHR = lb.JAHR AND
            an.REISENR = lb.REISENR AND
            an.EUNR = lb.EUNR AND
            an.fischart = lb.fischart
      
   ) an
LEFT JOIN com_fishery_final.eu_register eur ON an.eunr = eur."CFR" AND eur."Event End Date" > 21000000
LEFT JOIN com_fishery_process.target_species ts ON an.jahr = ts.jahr AND an.eunr = ts.eunr AND an.reisenr = ts.reisenr AND ts.ordnung = 1
LEFT JOIN com_parameter.baltic_metier bm ON an.jahr BETWEEN extract(year from bm.valid_from) AND extract(year from bm.valid_to) 
                                             AND an."month" BETWEEN extract(month FROM valid_from) AND extract(month from valid_to)
                                             AND COALESCE(an.geraet,eur."Gear Main Code") = bm.gear_code
                                             AND bm.target_species_list LIKE  '%' || ts.fischart   || '%'
                                             AND an.masche BETWEEN bm.mesh_open_min AND mesh_open_max
                                             AND an.unterbereich BETWEEN area_min AND area_max;
