# split catch weight into DIS and LAN parts 
# Das gemeinsame Fangewicht der FishFi wird entsprechend der Längenklassen aus LengFi in Landing und Discard (MrktFi / DiscFi) aufgeteilt.
# Die Einteilung benötigt length-weight coefficients und die vorherige Aufteilung der LengFi Längen
set @year = 2016;

drop table if exists commercial_sample_process.split_weight;
create table commercial_sample_process.split_weight

##################################
SELECT
	ff.JAHR as `year`,
	lw.cruise,
	lw.station,
	lw.species,
	ff.UPKG as orig_weight,
	(case 
		when(lw.tc_length_mass is not null) then (round(sum(lw.catch_length_frequency * lw.tc_length_mass/1000),3))
		when(lw.tc_length_mass is null and lw.ly_length_mass is not NULL) then (round(sum(lw.catch_length_frequency * lw.ly_length_mass/1000),3))
		when(lw.tc_length_mass is null and lw.ly_length_mass is NULL and lw.os_length_mass is not null) then (round(sum(lw.catch_length_frequency * lw.os_length_mass/1000),3))
		else(ff.UPKG) 
	end) as calc_weight,
	ts.treat_landing_sample,
	ts.split_length_class,
	
	(case
		when (lw.tc_length_mass is not null) then ('cruise_lw')
		when (lw.tc_length_mass is null and lw.ly_length_mass is not null) then ('area_lw')
		when (lw.tc_length_mass is null and lw.ly_length_mass is null and lw.os_length_mass is not null) then ('average_lw')
		else ('original_lw' )
	end) as lw_source,
	
	(case
		when(lw.tc_length_mass is not null) then (round(sum(lw.discard_length * lw.tc_length_mass/1000),3)) 
		when(lw.tc_length_mass is null and lw.ly_length_mass is not NULL) then (round(sum(lw.discard_length * lw.ly_length_mass/1000),3))
		when(lw.tc_length_mass is null and lw.ly_length_mass is NULL and lw.os_length_mass is not null) then (round(sum(lw.discard_length * lw.os_length_mass/1000),3))
		else(0) 
	end)	as discard_component,
	
	(case
		when(lw.tc_length_mass is not null) then (round(sum(lw.landing_length * lw.tc_length_mass/1000),3)) 
		when(lw.tc_length_mass is null and lw.ly_length_mass is not NULL) then (round(sum(lw.landing_length * lw.ly_length_mass/1000),3))
		when(lw.tc_length_mass is null and lw.ly_length_mass is NULL and lw.os_length_mass is not null) then (round(sum(lw.landing_length * lw.os_length_mass/1000),3))
		else(0) 
	end) as landing_component
		
####################################	

FROM
	(select 
		slf.JAHR,
		slf.cruise,
		slf.station,
		slf.species,
		slf.length_class,
		(case when(slf.length_class < ts2.split_length_class) then ('DIS')
				 when (slf.length_class > ts2.split_length_class) then ('LAN')
		 end) as category,
		slf.catch_length_frequency,
		round(EXP(((cmc.sy - (cmc.sn * cmc.sxy - cmc.sx * cmc.sy) / (cmc.sn * cmc.sqx - cmc.sx * cmc.sx) * cmc.sx) / cmc.sn) + (cmc.sn * cmc.sxy - cmc.sx * cmc.sy) / (cmc.sn * cmc.sqx - cmc.sx * cmc.sx) * log(slf.length_class)),4) as tc_length_mass,
		round(EXP(lyc.ln_a + lyc.b * ln(slf.length_class)),4) as ly_length_mass,
		round((osc.a * power(slf.length_class/10,osc.b)),4) as os_length_mass,
	(case 
		when (ts2.treat_landing_frequency = "add" and slf.length_class >= ts2.split_length_class) then (slf.catch_length_frequency)
		when (ts2.treat_landing_frequency = "neglect" and slf.length_class >= ts2.split_length_class) then (0) 
		when (ts2.treat_landing_frequency = "replace" and slf.length_class >= ts2.split_length_class) then (sum(slf.catch_length_frequency))
	end) as landing_length,
 
	(case 
		when (ts2.treat_discard_frequency = "add" and slf.length_class < ts2.split_length_class) then (slf.catch_length_frequency)
		when (ts2.treat_discard_frequency = "neglect" and slf.length_class < ts2.split_length_class) then(0) 
		when (ts2.treat_discard_frequency = "replace" and slf.length_class < ts2.split_length_class) then (sum(slf.catch_length_frequency))
	end) as discard_length
		
	from 
		(select 
			fi.JAHR,
			fi.REISENR as cruise, 
			fi.STATION as station, 
			fi.NETZ as net,
			fi.QUARTAL as quarter, 
			fi.FISH as species, 
			'' as catch_category,
			10 * fi.LAENGE as length_class, 
			1 * fi.LANZAHL as catch_length_frequency
		from 
			`commercial_sample_final`.LengFi fi 
		where 
			fi.JAHR = 2016
		) slf

	left join 
		(select 
			si.JAHR,
			si.FISH as species,
			si.REISENR as cruise,
			sum(log(si.LAENGE * 10)) as sx, 
			sum(log(si.TOTALGEW)) as sy,
			sum(log(si.LAENGE * 10) * log(si.TOTALGEW)) as sxy,
			sum(log(si.LAENGE * 10) * log(si.LAENGE * 10)) as sqx, 
			sum(log(si.TOTALGEW) * log(si.TOTALGEW)) as sqy,
			count(*) as sn
		from 
			`commercial_sample_final`.SnglIOR si 
		group by 
			si.JAHR,
			si.FISH, 
			si.REISENR
		) cmc    
	on 
		slf.JAHR = cmc.JAHR
	and 
		slf.cruise = cmc.cruise
	and 
		slf.species = cmc.species

	left join
		commercial_sample_process.treat_sample ts2
	on
		slf.JAHR = ts2.this_year
	and
		slf.cruise = ts2.cruise
	and
		slf.station = ts2.station
	and
		slf.species = ts2.species	
		
	left join 
		commercial_parameter.last_year_length_mass_coefficient lyc
	on
		lyc.year = slf.JAHR
	and
		lyc.species_ish = slf.species 
	and
		lyc.quarter = slf.quarter  
	and
		lyc.division_sub = concat(2,left(slf.cruise,1)) 

	left join 
		commercial_parameter.other_source_length_mass_coefficient osc
	on
		osc.species_ish = slf.species
		
	group by  
		slf.JAHR,
		slf.cruise,
		slf.station,
		slf.species,
		slf.length_class,
		ts2.split_length_class,
		ts2.treat_landing_frequency,
		ts2.treat_discard_frequency	
		
 ) lw
	
###############################################
	
LEFT JOIN 	
	commercial_sample_final.FishFi ff
on
 ff.JAHR = lw.JAHR
and
 ff.REISENR = lw.cruise
and
 ff.STATION = lw.station
and
 ff.FISH = lw.species		
	
LEFT JOIN
 commercial_sample_process.treat_sample ts

on
 lw.JAHR = ts.this_year
and
 lw.cruise = ts.cruise
and
 lw.station = ts.station
and
 lw.species = ts.species	
 
GROUP BY
 	ff.JAHR,
	lw.cruise,
	lw.station,
	lw.species,
	ff.UPKG,
	ts.treat_landing_sample
 