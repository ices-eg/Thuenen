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
  sum_fangkg.sum_fangkg as sum_fangkg_per_month_ort,
  btp.avg_trip_price as avg_trip_price,
  sum_fangkg.sum_fangkg * btp.avg_trip_price as official_landings_value,
  ts.fischart as target_species,
  ts.metier as metier,
  an.BRZ,
  an.Kw,
  das.days_at_sea as days_at_sea,
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
LEFT JOIN
(
    SELECT reisenr,landort,fischart,avg(avg_price) as avg_trip_price FROM com_fishery_process.best_price bp GROUP BY reisenr,landort,fischart
) btp
ON an.reisenr = btp.reisenr AND
   an.harbour = btp.landort AND
   an.species = btp.fischart
LEFT JOIN
(
SELECT 
  reisenr,
  landort,
  fischart,
  CASE WHEN unterbereich = 'n' THEN 20
       WHEN unterbereich = 's' THEN 21
       ELSE unterbereich::integer
  END as area,
  rechteck as statistical_rectangle,
  jahr,
  extract(quarter from landdat) as quarter,
  extract(month from landdat) as month,
  sum(fangkg) as sum_fangkg
FROM com_fishery_final.anlandung
GROUP BY
reisenr,
  landort,
  fischart,
  CASE WHEN unterbereich = 'n' THEN 20
       WHEN unterbereich = 's' THEN 21
       ELSE unterbereich::integer
  END,
  rechteck,
  jahr,
  extract(quarter from landdat),
  extract(month from landdat)
) sum_fangkg
ON 
  an.reisenr = sum_fangkg.reisenr AND
  an.harbour = sum_fangkg.landort AND
  an.species = sum_fangkg.fischart AND
  an.unterbereich = sum_fangkg.area AND
  an.rechteck =sum_fangkg.statistical_rectangle AND
  an.jahr = sum_fangkg.jahr AND
  an.quarter = sum_fangkg.quarter AND
  an."month" = sum_fangkg."month"
  LEFT JOIN
  (  
      SELECT 
        reisenr,
        date_part('day',rueckdat-fahrdat)+1 as days_at_sea
      FROM com_fishery_final.reise
  ) das ON an.reisenr = das.reisenr;
