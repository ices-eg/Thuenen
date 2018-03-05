DROP TABLE IF EXISTS com_fishframe.cl;
CREATE TABLE com_fishframe.cl AS
SELECT
  'CL' as Record_type,
  left(av.Harbour,2) as Landing_country,
  'DEU' as Vessel_flag_country,
  av.jahr as Year,
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
  round(sum(av.sum_fangkg_per_month_ort)) as official_Landings_weight,
  1 as Landings_multiplier,
  round(sum(av.Official_landings_value)) as official_landings_value
FROM com_fishery_process.all_vessels av
GROUP BY
  left(av.Harbour,2),av.jahr,av.Quarter,av.Month,av.Area,av.Statistical_rectangle,av.species,av.metier,av.harbour,av.vessel_length_class
;
