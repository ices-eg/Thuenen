SELECT
  b.JAHR as jahr, 
  b.SCHIFF as schiff, 
  b.EU_NR as eunr, 
  (case when ((select a.`Loa` from commercial_fishery_final.EU_REGISTER a where a.`CFR` = b.EU_NR and a.`Event End Date`>21000000) >8.00 )
       then ('big')
       else ('small')
  end) as vessel_class,
  b.REISENR as osf_reise, 
  b.REISE_VON as osf_reise_von, 
  b.REISE_BIS as osf_reise_bis,
  b.REISE_BIS - b.REISE_VON as osf_days_at_sea,
  (select
     min(c.ble_reise) as ble_reise 
   
   from (
     select 
       a.JAHR, 
       a.EUNR, 
       a.REISENR as ble_reise, 
       date(a.FAHRDAT) as ble_reise_von, 
       date(a.RUECKDAT) as ble_reise_bis,
       b.REISENR as osf_reise,
       (abs(date(a.FAHRDAT) - date(b.REISE_VON)) + abs(date(a.RUECKDAT) - date(b.REISE_BIS))) as delta_all,
       mind.*
     FROM 
       commercial_fishery_final.REISE_FIT a 
     left join 
        commercial_sample_final.Reise b 
     on 
       a.EUNR = b.EU_NR
     left join 
       (
         select 	
	   b.REISENR as osf_reise_nr,
	   MIN((abs(date(a.FAHRDAT) - date(b.REISE_VON)) + abs(date(a.RUECKDAT) - date(b.REISE_BIS)))) as delta
	 FROM 
	   commercial_fishery_final.REISE_FIT a 
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
         (abs(date(a.FAHRDAT) - date(b.REISE_VON)) + abs(date(a.RUECKDAT) - date(b.REISE_BIS))) = mind.delta
    ) c WHERE c.jahr = b.jahr AND c.osf_reise = b.reisenr) as ble_reise 
 FROM 
      commercial_sample_final.Reise b
	  
	  
##########

ALTER TABLE `cruisematch_2019` ADD `target_species` VARCHAR(4) NOT NULL AFTER `target_species`;
update cruisematch_2019 a set target_assemblage = (select b.target_species FROM commercial_fishery_final.large_vessel_ce_cl b where a.JAHR = b.JAHR and a.ble_reise = b.REISENR group by `jahr`, `schiff`, `eunr`, `vessel_class`, `osf_reise`, `osf_reise_von`, `osf_reise_bis`, `osf_days_at_sea`, `ble_reise`)	  ;



ALTER TABLE `cruisematch_2019` ADD `target_assemblage` VARCHAR(4) NOT NULL AFTER `target_species`;
update cruisematch_2019 a set target_assemblage = (select b.target_assemblage FROM commercial_fishery_final.large_vessel_ce_cl b where a.JAHR = b.JAHR and a.ble_reise = b.REISENR group by `jahr`, `schiff`, `eunr`, `vessel_class`, `osf_reise`, `osf_reise_von`, `osf_reise_bis`, `osf_days_at_sea`, `ble_reise`)	;  
	  
	  
	  