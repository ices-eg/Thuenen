DROP TABLE IF EXISTS com_fishery_process.all_vessels;
CREATE TABLE com_fishery_process.all_vessels  AS
SELECT 
  an.EUNR,
  an.luea as LUEA,
  an.REISENR,
  an.unterbereich as Area,
  an.ZONE,
  an.rechteck as statistical_rectangle,
  an.jahr ,
  an.quarter,
  an."month",
  an.geraet,
  an.masche,
  an.species,
  an.harbour,
  an.vessel_length_class,
  NULL::float as sum_fangkg_per_month_ort,
  NULL::float as avg_trip_price,
  NULL::float as official_landings_value,
  ts.fischart as target_species,
  bm.metier as metier,
  an.BRZ,
  an.Kw,
  NULL::integer as days_at_sea,
  NULL::integer as fang_min_rgrm,
  NULL::integer as fangnumber_min_rgrm
FROM 
  (
      SELECT DISTINCT
        an.EUNR,
        COALESCE(eur."Loa",eur_ret."Loa") as luea,
        an.REISENR,
        CASE WHEN an.unterbereich = 'n' THEN 20
             WHEN an.unterbereich = 's' THEN 21
             ELSE an.unterbereich::integer
             END as unterbereich,
        an.zone,
        an.rechteck,
        an.jahr,
        extract(quarter from an.landdat) as quarter,
        extract(month from an.landdat) as "month",
        COALESCE(COALESCE(lb.geraet,eur."Gear Main Code"),eur_ret."Gear Main Code") as geraet,
        lb.masche,
        an.fischart as species,
        an.landort as harbour,
        CASE WHEN COALESCE(eur."Loa",eur_ret."Loa")  < 10 THEN '<10'
        WHEN COALESCE(eur."Loa",eur_ret."Loa")  >= 10 AND COALESCE(eur."Loa",eur_ret."Loa")  < 12 THEN '10-<12'
        WHEN COALESCE(eur."Loa",eur_ret."Loa")  >= 12 AND COALESCE(eur."Loa",eur_ret."Loa")  < 18 THEN '12-<18'
        WHEN COALESCE(eur."Loa",eur_ret."Loa")  >= 18 AND COALESCE(eur."Loa",eur_ret."Loa")  < 24 THEN '18-<24'
        WHEN COALESCE(eur."Loa",eur_ret."Loa")  >= 24 AND COALESCE(eur."Loa",eur_ret."Loa")  < 40 THEN '24-<40'
        WHEN COALESCE(eur."Loa",eur_ret."Loa")  >= 40 THEN '>=40' END AS vessel_length_class,
        COALESCE(eur."Ton Gts",eur_ret."Ton Gts") as BRZ,
        COALESCE(eur."Power Main",eur_ret."Power Main") as Kw
      FROM com_fishery_final.anlandung an 
      LEFT JOIN  com_fishery_final.logbuch lb
         ON an.JAHR = lb.JAHR AND
            an.REISENR = lb.REISENR AND
            an.EUNR = lb.EUNR AND
            an.fischart = lb.fischart
      LEFT JOIN com_fishery_final.eu_register eur ON an.eunr = eur."CFR" 
                                                      AND (an.jahr * 10000) + (extract(month from an.landdat) * 100)+extract(day from an.landdat) BETWEEN eur."Event Start Date" AND eur."Event End Date"
      LEFT JOIN com_fishery_final.eu_register eur_ret ON an.eunr = eur_ret."CFR" AND eur_ret."Event Code" = 'RET'
   ) an

LEFT JOIN com_fishery_process.target_species ts ON an.jahr = ts.jahr AND an.eunr = ts.eunr AND an.reisenr = ts.reisenr AND ts.ordnung = 1
LEFT JOIN com_parameter.baltic_metier bm ON an.jahr BETWEEN extract(year from bm.valid_from) AND extract(year from bm.valid_to) 
                                             AND an."month" BETWEEN extract(month FROM valid_from) AND extract(month from valid_to)
                                             AND an.geraet = bm.gear_code
                                             AND bm.target_species_list LIKE  '%' || ts.fischart   || '%'
                                             AND ((an.masche BETWEEN bm.mesh_open_min AND mesh_open_max) OR an.masche IS NULL)
                                             AND an.unterbereich BETWEEN area_min AND area_max;
