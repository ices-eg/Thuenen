DROP TABLE IF EXISTS com_sample_process.treat_sample;
CREATE TABLE com_sample_process.treat_sample AS
SELECT
  obs.code as observer,
  substring(sv.REISENR,2,2) as observer_code,
  sv.REISENR as cruise,
  sv.STATION as station,
  '1' as net,
  sv.JAHR as this_year,
  tsc.bfa as target_species_code,
  ts.fischart as target_species,
  sv.FISH as species_code,
  sc.a3_asfis as species,
  'U' as sex,
  case
						when (sv.FISH = 293) then (350) --- 380 vor 2015!!!
						when (sv.FISH = 468) then (350)
						when (sv.FISH = 604) then (250)
						when (sv.FISH = 630) then (300)
						when (sv.FISH = 465) then (350)
						when (sv.FISH = 690) then (300)
						when (sv.FISH = 607) then (260)
						when (sv.FISH = 407) then (250)
						else (9999) end as split_length_class,
  sv.sample_valid as sample_valid,
  '' as treat_discard_frequency,
  '' as raising_mode,
  '' as raising_species_code,
  '' as raising_species,
  '' as sampling_factor,
  '' as treat_landing_sample,
  '' as treat_landing_frequency,
  pl.kutter_1 as vessel,
  pl.kutter_2 as pair_vessel,
  case 
    when substring(sv.REISENR,2,2) = '03' then ('LAB') 
    when substring(sv.REISENR,2,2) = '14' then ('MUK')
    when substring(sv.REISENR,2,2) = '15' then ('BMS')
	else ('SEA') 
  end as sample_type,
  pl.Beprobungsart as sampling,
  pl.Metier as metier,
  left(pl.Metier, 3) as gear,
  substring(pl.Metier,5,3) as target,
  '' as mesh_open,
  '' as selection,
  '' as select_mesh_open
FROM
  (
   SELECT 
      REISENR,
      STATION,
      JAHR,
      FISH,
      max(sample_valid) as sample_valid
   FROM
      com_sample_process.sample_valid 
   GROUP BY REISENR,STATION,JAHR,FISH
  ) sv
LEFT JOIN
  com_sample_process.cruise_match cm ON sv.jahr = cm.jahr AND sv.reisenr = cm.osf_reise
LEFT JOIN
  com_fishery_process.target_species ts ON sv.jahr = ts.jahr AND cm.ble_reise = ts.reisenr AND ts.ordnung = 1
LEFT JOIN
  com_parameter.species_code tsc ON ts.fischart = tsc.a3_asfis
LEFT JOIN
  com_parameter.species_code sc ON sv.fish = sc.bfa::integer 
LEFT JOIN
  com_parameter.observer obs ON  substring(sv.REISENR,2,2)::integer = obs.nummer
LEFT JOIN
  com_fishery_sample_process.Probenliste_OF pl ON pl.JAHR = sv.JAHR
                                                  AND pl.REISENR = sv.REISENR::integer
;
