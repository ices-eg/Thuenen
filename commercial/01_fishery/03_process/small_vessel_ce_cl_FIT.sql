## small vessel 

### 

 drop table if exists commercial_fishery_process.small_vessel_ce_cl;
 create table commercial_fishery_process.small_vessel_ce_cl


SELECT 
a.`jahr`,
 a.`eunr`, 
  round(vl.luea/100,2) as luea,
 (case when (vl.luea <800) then ('small')
  else ('large') end) as klasse,
 a.`reisenr`, 
 a.landnr,
 a.landort,
 a. landdat as land_datum,
 quarter(a. landdat) as land_quartal,
 month(a. landdat) as land_monat,
 
'1'  as days_at_sea,
   
 (datediff(date(f.`rueckdat`),date(f.`fahrdat`))+1) as days_at_sea_reise_tabelle,  
 
 '' as schleppzeit,
 '' as anzahl_hols_reise,
 
 a.fao_gebiet,
 a.zone,
 a.rechteck,

 vl.fg1 as geraet_register,
 '' as `masche`, 
 '' as`haken`, 
 '' as `gegros`, 
 
 a.fischart,
 b.target_species_assemblage_code as assemblage,
 e.fischart as target,
 'nnn' as target_assemblage,
  
 sum(a.`fangkg`) as fangkg, 
 sum(a.erloes) as erloes,
 round(sum(a.erloes)/sum(a.fangkg),2) as avg_price_kg,
round((sum(a.fangkg)/c.catch),3)  as anteil_landnr,
'' as metier

 
FROM commercial_fishery_final.`ANLANDUNG_FIT`a

left join commercial_parameter.species_class b

on a.fischart = b.species_code


left join (select jahr, eunr, reisenr, landnr,sum(fangkg) as catch from commercial_fishery_final.ANLANDUNG_FIT group by jahr, eunr, reisenr, landnr) c

on a.jahr = c.jahr 
and a.eunr = c.eunr
and a.reisenr = c.reisenr
and a.landnr = c.landnr


left join (select `jahr`, `eunr`, `reisenr`, `landnr`, `fischart` from commercial_fishery_final.ANLANDUNG_FIT 
					where (jahr,eunr,reisenr,landnr,fangkg) in (select jahr,eunr,reisenr,landnr,max(fangkg) from commercial_fishery_final.ANLANDUNG_FIT group by jahr,eunr,reisenr,landnr)
					group by jahr, eunr, reisenr, landnr
			    ) e
on a.jahr = e.jahr 
and a.eunr = e.eunr
and a.reisenr = e.reisenr
and a.landnr = e.landnr


left join commercial_fishery_final.REISE_FIT f 
on a.jahr = f.jahr
and a.eunr = f.eunr
and a.reisenr = f.reisenr


left join commercial_fishery_final.FIFAAKTIV_FIT vl
on a.eunr = vl.eunr


# kleiner 8m
-- where a.reisenr = 18000034

where vl.luea <800

group by `jahr`, `eunr`, `reisenr`,  landort,`landnr`, assemblage, fischart, rechteck 

#########################################################################################################
#########################################################################################################

##### fehlende target species ergänzen (passiert z.B. wenn eine landnr sich in mehrere landnr aufteilt oder die fänge 50/50 sind)

update commercial_fishery_process.small_vessel_ce_cl a set a.target = (

select b.fischart

from 
(select `jahr`, `eunr`, `reisenr`, `landnr`, `fischart` 
 from commercial_fishery_final.ANLANDUNG_FIT 
   where (jahr,eunr,reisenr,landnr,fangkg) in (select jahr,eunr,reisenr,landnr,max(fangkg) 
                                                from commercial_fishery_final.ANLANDUNG_FIT 
                                                   group by jahr,eunr,reisenr,landnr) group by jahr, eunr, reisenr, landnr) b

 where a.jahr = b.jahr 
 and a.reisenr = b.reisenr 
 and a.landnr = b.landnr)
 
 where a.target is NULL;

##### target assemblage updaten (assemblage pro landnr >60% Anteil)

update `small_vessel_ce_cl` a set a. target_assemblage = (select b.assemblage from 

(select jahr, eunr, reisenr, landnr, assemblage, sum(`anteil_landnr`) as anteil from `small_vessel_ce_cl`  group by jahr, eunr, reisenr, landnr, assemblage) b  

where a.jahr = b.jahr 
and a.eunr = b.eunr 
and a.reisenr = b.reisenr
and a.landnr = b.landnr
and b.anteil >=0.6

group by a.jahr, a.eunr, a.reisenr, a.landnr)


#### Update leerer felder (herabsetzen der assemblage grenze)

update `small_vessel_ce_cl` a set a. target_assemblage = (select b.assemblage from 

(select jahr, eunr, reisenr, landnr, assemblage, sum(`anteil_landnr`) as anteil from `small_vessel_ce_cl`  group by jahr, eunr, reisenr, landnr, assemblage) b  

where a.jahr = b.jahr 
and a.eunr = b.eunr 
and a.reisenr = b.reisenr
and a.landnr = b.landnr
and b.anteil >=0.51)

where a.target_assemblage = ''


##### update der letzten freien target_assemblages (nun wird nur noch der maximale fang je landnr verwendet)

update `small_vessel_ce_cl` a set a.target_assemblage = (select

b.assemblage
   from
   
   (select  jahr, eunr, reisenr, landnr, assemblage, sum(`anteil_landnr`) as anteil 
           from `small_vessel_ce_cl` 
             where (jahr,eunr,reisenr,landnr,anteil_landnr)in (select jahr,eunr,reisenr,landnr,max(anteil_landnr)
                                                                  from `small_vessel_ce_cl` 
                                                                    group by jahr,eunr,reisenr,landnr) 
         group by jahr, eunr, reisenr, landnr, assemblage) b  

where a.jahr = b.jahr 
and a.eunr = b.eunr 
and a.reisenr = b.reisenr
and a.landnr = b.landnr

group by a.eunr, a.reisenr, a.landnr, a.fischart, a.assemblage, a.target_assemblage)

where a.target_assemblage = ''



####### Netztypen aktualisieren 
update commercial_fishery_process.small_vessel_ce_cl set geraet_register = 'FPN' where geraet_register = 'FWR';
update commercial_fishery_process.small_vessel_ce_cl set geraet_register = 'FPO' where geraet_register = 'FIX';
update commercial_fishery_process.small_vessel_ce_cl set geraet_register = 'GNS' where geraet_register = 'GN';
update commercial_fishery_process.small_vessel_ce_cl set geraet_register = 'GNS' where geraet_register = 'MIS';
update commercial_fishery_process.small_vessel_ce_cl set geraet_register = 'OTB' where geraet_register = 'TTB';
update commercial_fishery_process.small_vessel_ce_cl set geraet_register = 'LLS' where geraet_register = 'LL';
update commercial_fishery_process.small_vessel_ce_cl set geraet_register = 'LLS' where geraet_register = 'LLD';
update commercial_fishery_process.small_vessel_ce_cl set geraet_register = 'OTB' where geraet_register = 'TBB';
update commercial_fishery_process.small_vessel_ce_cl set geraet_register = 'GNS' where geraet_register = 'GND';
update commercial_fishery_process.small_vessel_ce_cl set geraet_register = 'GNS' where geraet_register = 'GTN';
update commercial_fishery_process.small_vessel_ce_cl set geraet_register = 'OTB' where geraet_register = 'OTG';
update commercial_fishery_process.small_vessel_ce_cl set geraet_register = 'GNS' where geraet_register = 'GEN';
update commercial_fishery_process.small_vessel_ce_cl set geraet_register = 'OTB' where geraet_register = 'TB';

####### Metier ergänzen (erstmal die pasiven Geräte, da bei OTB versch. Maschenweiten vorkommen und diese mittels target species genauer definiert werden müssen)

update commercial_fishery_process.small_vessel_ce_cl a set a.metier = (SELECT b.metier 

from commercial_parameter.baltic_metier b 

where  a.geraet_register = b.gear_code
and a.target_assemblage = b.target_assemblage
and right(a.fao_gebiet, 2) between b.area_min and b.area_max
and b.valid_to = '2099-12-31' and a.geraet_register in ('GNS', 'LLS', 'FPO'))

where a.metier = ''

######### für OTB

update commercial_fishery_process.small_vessel_ce_cl a set a.metier = (SELECT b.metier 

from commercial_parameter.baltic_metier b 

where  a.geraet_register = b.gear_code
and a.target_assemblage = b.target_assemblage
and a.target = 'COD'
and b.target_species_list like '%COD%'                                                                     
                                                                       
and right(a.fao_gebiet, 2) between b.area_min and b.area_max
and b.valid_to = '2099-12-31' and a.geraet_register in ('OTB'))

where a.metier = ''

########
update commercial_fishery_process.small_vessel_ce_cl a set a.metier = (SELECT b.metier 

from commercial_parameter.baltic_metier b 

where  a.geraet_register = b.gear_code
and a.target_assemblage = b.target_assemblage
and a.target in ('FLE', 'PLE', 'DAB', 'TUR', 'BLL')													  # Achtung, je target_species ein Durchgang, sonst kreuzt es aus 
and b.target_species_list in('%FLE%' ,'%PLE%', '%DAB%', '%TUR%', '%BLL%')       # Achtung, je target_species ein Durchgang, sonst kreuzt es aus                                                                
                                                                       
and right(a.fao_gebiet, 2) between b.area_min and b.area_max
and b.valid_to = '2099-12-31' and a.geraet_register in ('OTB'))

where a.metier = ''



####### übrige Metiers
# häufig können metiers aufgrund von falschen logbucheinträgen nicht zugewiesen werden

# Fall 1: Maschenweite passt nicht zum Gebiet (OTB 90mm sind bspw. nur in SD22 und SD23 erlaubt, kommen aber regelmäßig in SD24 vor)

# Fall 2: Maschenweite passt nicht zum Netz (GNS ANA muss >= 157mm sein, wird aber auch mit GNS_DEF netzen oder Plattfischnetzen gefangen und kann dort manchmal target assemblage sein)

# Fall 3: Target Species (assemblage) wird normalerweise nicht mit diesem Netz gefangen ()

update commercial_fishery_process.small_vessel_ce_cl a set a.metier = concat(`geraet_register`,'_FIF_>0_0_0') WHERE metier = ''  




####### update average price 


update commercial_fishery_process.small_vessel_ce_cl a set a.avg_price_kg = 

(select b.avg_price_kg from 
											(SELECT `land_quartal`, `land_monat`, `fao_gebiet`, `rechteck`, `geraet_register`, `fischart`, avg(`avg_price_kg`) as avg_price_kg FROM `small_vessel_ce_cl` WHERE `avg_price_kg` >0.05 and `avg_price_kg` <15
												group by `land_quartal`, `land_monat`, `fao_gebiet`, `rechteck`, `geraet_register`, `fischart`
											)b 

where a.land_quartal = b.land_quartal 
and a.land_monat = b.land_monat
and a.fao_gebiet = b.fao_gebiet
and a.geraet_register = b.geraet_register
and a.rechteck = b.rechteck
and a.fischart = b.fischart
) 

where a.avg_price_kg = 0
-- where a.avg_price_kg = ''
-- where a.avg_price_kg is NULL
# nacheinander dann rechteck, monat, geraet ausklammern. Für Sprotten und Hering ggf. den Preisrahmen herunter setzen (0,20 Euro je kg)


####### update avergae price für die "high-value species" wie etwa Aal oder Seelachs (vorherige Einschränkung auf mittlere Preise zwischen 0.01 und 15 Euro klammern diese teiwleise aus) 

update commercial_fishery_process.small_vessel_ce_cl a set a.avg_price_kg = 

(select b.avg_price_kg from 
											(SELECT `land_quartal`, `land_monat`, `fao_gebiet`, `rechteck`, `geraet_register`, `fischart`, avg(`avg_price_kg`) as avg_price_kg FROM `small_vessel_ce_cl` WHERE `avg_price_kg` >1 and `avg_price_kg` <20
												group by `land_quartal`, `land_monat`, `fao_gebiet`, `rechteck`, `geraet_register`, `fischart`
											)b 

where a.land_quartal = b.land_quartal 
and a.land_monat = b.land_monat
and a.fao_gebiet = b.fao_gebiet
and a.geraet_register = b.geraet_register
and a.rechteck = b.rechteck
and a.fischart = b.fischart
and fischart = 'ELE'
) 

where a.avg_price_kg = 0
-- where a.avg_price_kg = ''
-- where a.avg_price_kg is NULL
and fischart = 'ELE'

# ein weiterer Durchgang mit 'rechteck' ausgeklammert, dann mit 'geraet' ausgeklammert, dann mit beidem ausgeklammert


######################### Einige Fischarten haben keinen Preis, selbst wenn nur noch auf Fischart (letzter Schritt) abgeglichen wird, z.B. Seeskorpion und Aalmuttern. Diese werden dann pauschal auf 1cent gesetzt 

update commercial_fishery_process.small_vessel_ce_cl a
	set a.avg_price_kg = 0.01
	where a.avg_price_kg is NULL
	
	
######################### wenn überall average prices verfügbar sind, können die Erlöse berechnet werden 

update commercial_fishery_process.small_vessel_ce_cl a 
	set a.erloes = round(a.fangkg * a.avg_price_kg,3) 
	where a.erloes = 0









