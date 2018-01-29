SELECT
  
  b."JAHR" as jahr, 
  b."SCHIFF" as schiff, 
  b."EU_NR" as eunr, 
  
  (case 
  when(
        (select a."Loa" from com_fishery_original."eu_register" a where a."CFR" = b."EU_NR" and a."Event End Date">21000000) >8.00) 
  then ('big')
  else ('small')
  end) as vessel_class,
  b."REISENR" as osf_reise, 
  to_date(to_char(b."REISE_VON", '99999999'), 'YYYYMMDD') as osf_reise_von, 
  to_date(to_char(b."REISE_BIS", '99999999'), 'YYYYMMDD') as osf_reise_bis,
  to_date(to_char(b."REISE_BIS", '99999999'), 'YYYYMMDD') - to_date(to_char(b."REISE_VON", '99999999'), 'YYYYMMDD') as osf_days_at_sea,
 (select c."reisenr" 
		from com_fishery_original."reise" c 
                 where b."EU_NR" = c."eunr" 
                 and 
                 to_date(to_char(b."REISE_VON", '99999999'), 'YYYYMMDD') between to_date(left(c."fahrdat", 8), 'YYYYMMDD') and to_date(left(c."rueckdat", 8), 'YYYYMMDD')
                 and 
                 to_date(to_char(b."REISE_BIS", '99999999'), 'YYYYMMDD') between to_date(left(c."fahrdat", 8), 'YYYYMMDD') and to_date(left(c."rueckdat", 8), 'YYYYMMDD')) as ble_reise
  FROM 
  com_fishery_sample_process."Reise" b;

SELECT
  b.JAHR as jahr, 
  b.SCHIFF as schiff, 
  b.EU_NR as eunr,
  CASE WHEN eu."Loa" > 8.00
       THEN 'big'
       ELSE 'small'
  END as vessel_class,
  b.reisenr as osf_reise,
  ble.reisenr as ble_reise,
  to_date(to_char(b.REISE_VON, '99999999'), 'YYYYMMDD') as osf_reise_von, 
  to_date(to_char(b.REISE_BIS, '99999999'), 'YYYYMMDD') as osf_reise_bis,
  to_date(to_char(b.REISE_BIS, '99999999'), 'YYYYMMDD') - to_date(to_char(b.REISE_VON, '99999999'), 'YYYYMMDD') as osf_days_at_sea,
  to_date(to_char(ble.fahrdat, '99999999'), 'YYYYMMDD') as ble_reise_von, 
  to_date(to_char(ble.rueckdat, '99999999'), 'YYYYMMDD') as ble_reise_bis,
  to_date(to_char(ble.fahrdat, '99999999'), 'YYYYMMDD') - to_date(to_char(b.rueckdat, '99999999'), 'YYYYMMDD') as ble_days_at_sea
  
FROM com_sample_final.reise b
LEFT JOIN com_fishery_final.eu_register eu
     ON eu."CFR" = b.EU_NR AND eu."Event End Date" > 21000000
LEFT JOIN
(
  SELECT
    *
  FROM com_fishery_original.reise
) ble ON b.EU_NR = ble.eunr
         AND to_date(to_char(b.REISE_VON, '99999999'), 'YYYYMMDD') between to_date(left(ble.fahrdat, 8), 'YYYYMMDD') and to_date(left(ble.rueckdat, 8), 'YYYYMMDD')
	 AND to_date(to_char(b.REISE_BIS, '99999999'), 'YYYYMMDD') between to_date(left(ble.fahrdat, 8), 'YYYYMMDD') and to_date(left(ble.rueckdat, 8), 'YYYYMMDD')
ORDER BY b.reisenr	 
;
