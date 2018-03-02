DROP TABLE IF EXISTS com_fishframe.ce;
CREATE TABLE com_fishframe.ce AS
select
 -- CE Record
 'CE' as Record_type,
 'DEU' as Vessel_flag_country,
 fce.jahr,
 ceiling(fce.Month/3) as Quarter,
 fce.Month,
 fce.Area,
 fce.Statistical_rectangle,
 '' as Sub_polygon,
 '' as FAC_National,
 '' as FAC_EC_lvl5,
 fce.metier as FAC_EC_lvl6,
 fce.Harbour,
 fce.Vessel_length_class as Vessel_length_cat,
 count(REISENR) as Number_of_trips,
 sum(fangnumber_min_rgrm) as Number_of_sets_hols,
 sum(fangmin_rgrm) as Fishing_time_soaking_time,

 sum(Kw*days_at_sea_je_mm) as  kW_days,
 sum(GT*days_at_sea_je_mm) as GT_days,
 sum(days_at_sea_je_mm)as Days_at_sea

from
(
    SELECT
      us.*,
      us.brz as GT,
      us.kw as kw_km,
      case when us.fangmin_rgrm > 0 then us.fangmin_rgrm*us.days_at_sea/sa.aufwand_je_mm
          when us.fangmin_rgrm is null or us.fangmin_rgrm = 0 then us.fangkg_pro_strata*us.days_at_sea/sa.fangkg_je_mm
          else us.days_at_sea
          end as days_at_sea_je_mm
    FROM
    (
        -- fangkg pro reise,monat,hafen
        SELECT
          eunr,
          luea,
          reisenr,
          area,
          zone,
          statistical_rectangle,
          jahr,
          month,
          harbour,
          vessel_length_class,
          sum(sum_fangkg_per_month_ort) as fangkg_pro_strata,
          target_species,
          metier,
          BRZ,
          Kw,
          days_at_sea,
          fangmin_rgrm,
          fangnumber_min_rgrm  
        FROM com_fishery_process.all_vessels av
        GROUP BY
        eunr,luea,reisenr,area,zone,statistical_rectangle,jahr,month,harbour,vessel_length_class,target_species,metier,BRZ,Kw,days_at_sea,fangmin_rgrm,fangnumber_min_rgrm 
    ) us
    LEFT JOIN
    (
        -- fangkg und aufwand (fishing_time) auf reise aufsummiert
        SELECT
          reisenr,
          jahr,
          brz,
          Kw,
          days_at_sea,
          sum(sum_fangkg_per_month_ort) as fangkg_je_mm,
          sum(fangmin_rgrm) as aufwand_je_mm
        FROM com_fishery_process.all_vessels av
        GROUP BY reisenr,jahr,brz,Kw,days_at_sea
    ) sa
    on
     us.REISENR = sa.REISENR
    and
     us.jahr = sa.jahr
) fce
WHERE days_at_sea IS NOT NULL AND days_at_sea > 0
GROUP BY fce.jahr, ceiling(fce.Month/3), fce.Month, fce.Area, fce.Statistical_rectangle, fce.metier, fce.Harbour, fce.Vessel_length_class
;
