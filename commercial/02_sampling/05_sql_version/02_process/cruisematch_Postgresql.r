cm <- dbGetQuery(conn, "SELECT
  
  b.\"JAHR\" as jahr, 
  b.\"SCHIFF\" as schiff, 
  b.\"EU_NR\" as eunr, 
  
  (case 
  when(
        (select a.\"Loa\" from eu_register a where a.\"CFR\" = b.\"EU_NR\" and a.\"Event End Date\">21000000) >8.00) 
  then ('big')
  else ('small')
  end) as vessel_class,
  b.\"REISENR\" as osf_reise, 
  to_date(to_char(b.\"REISE_VON\", '99999999'), 'YYYYMMDD') as osf_reise_von, 
  to_date(to_char(b.\"REISE_BIS\", '99999999'), 'YYYYMMDD') as osf_reise_bis,
  to_date(to_char(b.\"REISE_BIS\", '99999999'), 'YYYYMMDD') - to_date(to_char(b.\"REISE_VON\", '99999999'), 'YYYYMMDD') as osf_days_at_sea,
 (select c.\"reisenr\" 
		from reise c 
                 where b.\"EU_NR\" = c.\"eunr\" 
                 and 
                 to_date(to_char(b.\"REISE_VON\", '99999999'), 'YYYYMMDD') between to_date(left(c.\"fahrdat\", 8), 'YYYYMMDD') and to_date(left(c.\"rueckdat\", 8), 'YYYYMMDD')
                 and 
                 to_date(to_char(b.\"REISE_BIS\", '99999999'), 'YYYYMMDD') between to_date(left(c.\"fahrdat\", 8), 'YYYYMMDD') and to_date(left(c.\"rueckdat\", 8), 'YYYYMMDD')) as ble_reise
  FROM 
  com_fishery_sample_process.\"Reise\" b
  ")
  
  cm
  
  
  #######################################################################
  
  cm <- dbGetQuery(conn, 
  
 "SELECT
  b.\"JAHR\" as jahr, 
  b.\"SCHIFF\" as schiff, 
  b.\"EU_NR\" as eunr, 
  
  (case 
  when(
        (select a.\"Loa\" from com_fishery_original.\"eu_register\" a where a.\"CFR\" = b.\"EU_NR\" and a.\"Event End Date\">21000000) >8.00) 
  then ('big')
  else ('small')
  end) as vessel_class,
  b.\"REISENR\" as osf_reise, 
  to_date(to_char(b.\"REISE_VON\", '99999999'), 'YYYYMMDD') as osf_reise_von, 
  to_date(to_char(b.\"REISE_BIS\", '99999999'), 'YYYYMMDD') as osf_reise_bis,
  to_date(to_char(b.\"REISE_BIS\", '99999999'), 'YYYYMMDD') - to_date(to_char(b.\"REISE_VON\", '99999999'), 'YYYYMMDD') as osf_days_at_sea,
-- (select c.\"reisenr\" 
--		from com_fishery_sample_process.\"reise\" c 
--               where b.\"EU_NR\" = c.\"eunr\" 
--                 and 
--                 to_date(to_char(b.\"REISE_VON\", '99999999'), 'YYYYMMDD') between to_date(left(c.\"fahrdat\", 8), 'YYYYMMDD') and to_date(left(c.\"rueckdat\", 8), 'YYYYMMDD')
--                 and 
--                 to_date(to_char(b.\"REISE_BIS\", '99999999'), 'YYYYMMDD') between to_date(left(c.\"fahrdat\", 8), 'YYYYMMDD') and to_date(left(c.\"rueckdat\", 8), 'YYYYMMDD')) as ble_reise,
 

(select 	c.\"ble_reise\" 
		from( select 
					a.`JAHR`, 
					a.`EUNR`, 
					a.`REISENR` as ble_reise, 
					date(a.`FAHRDAT`) as ble_reise_von, 
					date(a.`RUECKDAT`) as ble_reise_bis,
					b.REISENR as osf_reise,
--					date(b.REISE_VON) as osf_reise_von,
--					date(b.REISE_BIS) as osf_reise_bis,
					(abs(date(a.`FAHRDAT`) - date(b.REISE_VON)) + abs(date(a.`RUECKDAT`) - date(b.REISE_BIS))) as delta_all,
					mind.*
				FROM 
					commercial_fishery_final.`REISE` a 
				left join 
					commercial_sample_final.Reise b 
				on 
					a.EUNR = b.EU_NR
				left join 
					(select 	
						b.REISENR as osf_reise_nr,
						MIN((abs(date(a.`FAHRDAT`) - date(b.REISE_VON)) + abs(date(a.`RUECKDAT`) - date(b.REISE_BIS)))) as delta
					FROM 
						commercial_fishery_final.`REISE` a 
					left join 
						commercial_sample_final.Reise b 
					on 
						a.EUNR = b.EU_NR
					where 
						date(a.FAHRDAT) < date(b.REISE_BIS)+1
					group by 
						b.REISENR
					) mind

				on 
					mind.osf_reise_nr = b.REISENR
				where 
					(abs(date(a.`FAHRDAT`) - date(b.REISE_VON)) + abs(date(a.`RUECKDAT`) - date(b.REISE_BIS))) = mind.delta
				group by 
					a.JAHR, a.EUNR, b.REISENR 
				)c) as ble_reise,
				
		
 
 FROM 
  com_fishery_sample_process.\"Reise\" b
  
  ")
  