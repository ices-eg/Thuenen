## Large Vessel for CL and CE
### Logbuch vorhanden, also wird auf fangnr summiert und die target assemblage abgeleitet

 -- drop table commercial_fishery_process.large_vessel_ce_cl;
--  create table commercial_fishery_process.large_vessel_ce_cl
insert into commercial_fishery_process.large_ce_cl

SELECT 
a.`jahr`,
 a.`eunr`, 
 round(vl.luea/100,2) as luea,
 (case when (vl.luea <800) then ('small') 
  else ('large') end) as klasse,
 a.`reisenr`, 
 a.`fangnr`, 
 a.landnr,
 a.landort,
 d.fangdatb as hol_datum,
 quarter(d.fangdatb) as hol_quartal,
 month(d.fangdatb) as hol_monat,
 
(case when (d.fangdatv not in ('0000-00-00 00:00:00')) then ((datediff(date(d.`fangdatb`),date(d.`fangdatv`))+1))
  else ('1') end)  
   as days_at_sea,
 
 (datediff(date(f.`rueckdat`),date(f.`fahrdat`))+1) as days_at_sea_reise_tabelle,
 
round(sum(timediff(d.`fangdatb`,d.`fangdatv`)/10000),0) as schleppzeit,
count(distinct d.fangnr) as anzahl_hols_reise,
 
 a.fao_gebiet,
 a.zone,
 a.rechteck,
 d.`geraet`, 
 d.`masche`, 
 d.`haken`, 
 d.`gegros`, 
 
 a.fischart,
 b.target_species_assemblage_code as assemblage,
 e.fischart as target,
 'nnn' as target_assemblage,
 
 sum(a.`fangkg`) as fangkg, 
 sum(a.erloes) as erloes,
 round(sum(a.erloes)/sum(a.fangkg),2) as avg_price_kg,
round((sum(a.fangkg)/c.catch),3)  as anteil_fangnr,
'' as metier


FROM commercial_fishery_final.`ANLANDUNG_FIT_KOMPLETT`a

left join commercial_parameter.species_class b

on a.fischart = b.species_code

left join (select jahr, eunr, reisenr, fangnr,sum(fangkg) as catch from commercial_fishery_final.ANLANDUNG_FIT_KOMPLETT group by jahr, eunr, reisenr, fangnr) c

on a.jahr = c.jahr 
and a.eunr = c.eunr
and a.reisenr = c.reisenr
and a.fangnr = c.fangnr


left join commercial_fishery_final.LOGBUCH_FIT d
on a.jahr = d.jahr 
and a.eunr = d.eunr
and a.fng_reisenr = d.reisenr
and a.fangnr = d.fangnr
and a.fischart = d.fischart


left join (select `jahr`, `eunr`, `reisenr`, `fangnr`, `fischart` from commercial_fishery_final.ANLANDUNG_FIT_KOMPLETT 
					where (jahr,eunr,reisenr,fangnr,fangkg) in (select jahr,eunr,reisenr,fangnr,max(fangkg) from commercial_fishery_final.ANLANDUNG_FIT_KOMPLETT group by jahr,eunr,reisenr,fangnr)
					group by jahr, eunr, reisenr, fangnr 
			    ) e
on a.jahr = e.jahr 
and a.eunr = e.eunr
and a.fng_reisenr = e.reisenr
and a.fangnr = e.fangnr


left join commercial_fishery_final.REISE_FIT f 
on a.jahr = f.jahr
and a.eunr = f.eunr
and a.reisenr = f.reisenr


left join commercial_fishery_final.FIFAAKTIV_FIT vl
on a.eunr = vl.eunr



 where vl.luea >= 800
# Beispiel >8m  
#  and a.reisenr = 19007779

group by `jahr`, `eunr`, `reisenr`,  landnr,  landort,`fangnr`, `geraet`, `masche`, `haken`, `gegros`, assemblage, fischart, rechteck;

#########################################################################################################
#########################################################################################################

### "Knochenfische" als assemblage ergänzen 

update large_vessel_ce_cl a set a.assemblage = 'FIF' where assemblage is NULL and a.fischart in ('SCU', 'MZZ')


##### fehlende target species ergänzen (passiert z.B. wenn eine fangnr sich in mehrere landnr aufteilt oder die fänge 50/50 sind)

update commercial_fishery_process.large_vessel_ce_cl a set a.target = (

select b.fischart

from 
(select `jahr`, `eunr`, `reisenr`, `fangnr`, `fischart` 
 from commercial_fishery_final.ANLANDUNG_FIT 
   where (jahr,eunr,reisenr,fangnr,fangkg) in (select jahr,eunr,reisenr,fangnr,max(fangkg) 
                                                from commercial_fishery_final.ANLANDUNG_FIT 
                                                   group by jahr,eunr,reisenr,fangnr) group by jahr, eunr, reisenr, fangnr) b

 where a.jahr = b.jahr 
 and a.reisenr = b.reisenr 
 and a.fangnr = b.fangnr)
 
 where a.target is NULL



##### target assemblage updaten (assemblage pro fangnr >60% Anteil)

update `large_vessel_ce_cl` a set a. target_assemblage = (select b.assemblage from 

(select jahr, eunr, reisenr, fangnr, assemblage, sum(`anteil_fangnr`) as anteil from `large_vessel_ce_cl`  group by jahr, eunr, reisenr, fangnr, assemblage) b  

where a.jahr = b.jahr 
and a.eunr = b.eunr 
and a.reisenr = b.reisenr
and a.fangnr = b.fangnr
and b.anteil >=0.6)


#### Update leerer felder (herabsetzen der assemblage grenze)

update `large_vessel_ce_cl` a set a. target_assemblage = (select b.assemblage from 

(select jahr, eunr, reisenr, fangnr, assemblage, sum(`anteil_fangnr`) as anteil from `large_vessel_ce_cl`  group by jahr, eunr, reisenr, fangnr, assemblage) b  

where a.jahr = b.jahr 
and a.eunr = b.eunr 
and a.reisenr = b.reisenr
and a.fangnr = b.fangnr
and b.anteil >=0.51)

where a.target_assemblage = ''


##### update der letzten freien target_assemblages (nun wird nur noch der maximale fang je fangnr verwendet)

update `large_vessel_ce_cl` a set a.target_assemblage = (select

b.assemblage
   from
   
   (select  jahr, eunr, reisenr, fangnr, assemblage, sum(`anteil_fangnr`) as anteil 
           from `large_vessel_ce_cl` 
             where (jahr,eunr,reisenr,fangnr,anteil_fangnr)in (select jahr,eunr,reisenr,fangnr,max(anteil_fangnr)
                                                                  from `large_vessel_ce_cl` 
                                                                    group by jahr,eunr,reisenr,fangnr) 
         group by jahr, eunr, reisenr, fangnr, assemblage) b  

where a.jahr = b.jahr 
and a.eunr = b.eunr 
and a.reisenr = b.reisenr
and a.fangnr = b.fangnr

group by a.eunr, a.reisenr, a.fangnr, a.fischart, a.assemblage, a.target_assemblage)

where a.target_assemblage = ''



####### Netztypen aktualisieren 
update commercial_fishery_process.large_vessel_ce_cl set geraet = 'FPN' where geraet = 'FWR';
update commercial_fishery_process.large_vessel_ce_cl set geraet = 'FPO' where geraet = 'FIX';
update commercial_fishery_process.large_vessel_ce_cl set geraet = 'GNS' where geraet = 'GN';
update commercial_fishery_process.large_vessel_ce_cl set geraet = 'GNS' where geraet = 'MIS';
update commercial_fishery_process.large_vessel_ce_cl set geraet = 'OTB' where geraet = 'TTB';
update commercial_fishery_process.large_vessel_ce_cl set geraet = 'LLS' where geraet = 'LL';
update commercial_fishery_process.large_vessel_ce_cl set geraet = 'LLS' where geraet = 'LLD';
update commercial_fishery_process.large_vessel_ce_cl set geraet = 'OTB' where geraet = 'TBB';
update commercial_fishery_process.large_vessel_ce_cl set geraet = 'GNS' where geraet = 'GND';
update commercial_fishery_process.large_vessel_ce_cl set geraet = 'GNS' where geraet = 'GTN';
update commercial_fishery_process.large_vessel_ce_cl set geraet = 'OTB' where geraet = 'OTG';
update commercial_fishery_process.large_vessel_ce_cl set geraet = 'GNS' where geraet = 'GEN';
update commercial_fishery_process.large_vessel_ce_cl set geraet = 'OTB' where geraet = 'TB';



###################### Metier Level 6 ergänzen

update commercial_fishery_process.large_vessel_ce_cl a set a.metier = (SELECT b.metier 

from commercial_parameter.baltic_metier b 

where  a.geraet = b.gear_code
and a.target_assemblage = b.target_assemblage
and right(a.fao_gebiet, 2) between b.area_min and b.area_max
and a.masche between b.mesh_open_min and b.mesh_open_max
and b.valid_to = '2099-12-31')

##### Metier für Area 28.2 ergänzen 

update commercial_fishery_process.large_vessel_ce_cl a set a.metier = (SELECT b.metier 

from commercial_parameter.baltic_metier b 

where  a.geraet = b.gear_code
and a.target_assemblage = b.target_assemblage
and mid(a.fao_gebiet,8, 2) between b.area_min and b.area_max
and a.masche between b.mesh_open_min and b.mesh_open_max
and b.valid_to = '2099-12-31')

where a.fao_gebiet = '27.3.d.28.2'



####### übrige Metiers
# häufig können metiers aufgrund von falschen logbucheinträgen nicht zugewiesen werden

# Fall 1: Maschenweite passt nicht zum Gebiet (OTB 90mm sind bspw. nur in SD22 und SD23 erlaubt, kommen aber regelmäßig in SD24 vor)

# Fall 2: Maschenweite passt nicht zum Netz (GNS ANA muss >= 157mm sein, wird aber auch mit GNS_DEF netzen oder Plattfischnetzen gefangen und kann dort manchmal target assemblage sein)

# Fall 3: Target Species (assemblage) wird normalerweise nicht mit diesem Netz gefangen ()

update commercial_fishery_process.large_vessel_ce_cl a set a.metier = concat(`geraet`,'_FIF_',`masche`) WHERE metier = ''  


####### update average price. Grenze liegt hier bei 5cent bis 15/kg, um Sonderfälle und falsche Abrechnungen zu vermeiden


update commercial_fishery_process.large_vessel_ce_cl a set a.avg_price_kg = 

(select b.avg_price_kg from 
											(SELECT `hol_quartal`, `hol_monat`, `fao_gebiet`, `rechteck`, `geraet`, `fischart`, avg(`avg_price_kg`) as avg_price_kg FROM `large_vessel_ce_cl` WHERE `avg_price_kg` >0.05 and `avg_price_kg` <15
												group by `hol_quartal`, `hol_monat`, `fao_gebiet`, `rechteck`, `geraet`, `fischart`
											)b 

where a.hol_quartal = b.hol_quartal 
and a.hol_monat = b.hol_monat
and a.fao_gebiet = b.fao_gebiet
and a.geraet = b.geraet
and a.rechteck = b.rechteck
and a.fischart = b.fischart
) 

where a.avg_price_kg = 0
-- where a.avg_price_kg = ''
-- where a.avg_price_kg is NULL
# nacheinander dann rechteck, monat, geraet ausklammern. Für Sprotten und Hering ggf. den Preisrahmen herunter setzen (0,20 Euro je kg)


####### update average price für die "high-value species" wie etwa Aal oder Seelachs (vorherige Einschränkung auf mittlere Preise zwischen 0.01 und 15 Euro klammern diese teilweise aus) 

update commercial_fishery_process.large_vessel_ce_cl a set a.avg_price_kg = 

(select b.avg_price_kg from 
											(SELECT `hol_quartal`, `hol_monat`, `fao_gebiet`, `rechteck`, `geraet`, `fischart`, avg(`avg_price_kg`) as avg_price_kg FROM `large_vessel_ce_cl` WHERE `avg_price_kg` >1 and `avg_price_kg` <20
												group by `hol_quartal`, `hol_monat`, `fao_gebiet`, `rechteck`, `geraet`, `fischart`
											)b 

where a.hol_quartal = b.hol_quartal 
and a.hol_monat = b.hol_monat
and a.fao_gebiet = b.fao_gebiet
and a.geraet = b.geraet
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

update commercial_fishery_process.large_vessel_ce_cl a 
	set a.avg_price_kg = 0.01
	where a.avg_price_kg is NULL
	
	
######################### wenn überall average prices verfügbar sind, können die Erlöse berechnet werden 

update commercial_fishery_process.large_vessel_ce_cl a 
	set a.erloes = round(a.fangkg * a.avg_price_kg,3) 
	where a.erloes = 0



