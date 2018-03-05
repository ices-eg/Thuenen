SELECT
	af.JAHR as `year`,
	lw.cruise,
	lw.station,
	lw.species,
	lw.catch_category,
	af.UPKG as orig_weight,
	(case 
		when(lw.tc_length_mass is not null) then (round(sum(lw.catch_length_frequency * lw.tc_length_mass/1000),3))
		when(lw.tc_length_mass is null and lw.ly_length_mass is not NULL) then (round(sum(lw.catch_length_frequency * lw.ly_length_mass/1000),3))
		when(lw.tc_length_mass is null and lw.ly_length_mass is NULL and lw.os_length_mass is not null) then (round(sum(lw.catch_length_frequency * lw.os_length_mass/1000),3))
		else(af.UPKG) 
	end) as calc_weight
	
	
from	
	(select 
		slf.JAHR,
		slf.cruise,
		slf.station,
		slf.species,
		slf.length_class,
		slf.catch_category,
		slf.catch_length_frequency,
		round(EXP(((cmc.sy - (cmc.sn * cmc.sxy - cmc.sx * cmc.sy) / (cmc.sn * cmc.sqx - cmc.sx * cmc.sx) * cmc.sx) / cmc.sn) + (cmc.sn * cmc.sxy - cmc.sx * cmc.sy) / (cmc.sn * cmc.sqx - cmc.sx * cmc.sx) * log(slf.length_class)),4) as tc_length_mass,
		round(EXP(lyc.ln_a + lyc.b * ln(slf.length_class)),4) as ly_length_mass,
		round((osc.a * power(slf.length_class/10,osc.b)),4) as os_length_mass
		
	from 
		(select 
			mfi.JAHR,
			mfi.REISENR as cruise, 
			mfi.STATION as station, 
			mfi.QUARTAL as quarter, 
			mfi.FISH as species, 
			'L' as catch_category,
			10 * mfi.LAENGE as length_class, 
			1 * mfi.LANZAHL as catch_length_frequency
		from 
			`commercial_sample_final`.MLenFi mfi 
		where 
			mfi.JAHR = 2016
		
	union 		
		select 
			mfi.JAHR,
			mfi.REISENR as cruise, 
			mfi.STATION as station, 
			mfi.QUARTAL as quarter, 
			mfi.FISH as species, 
			'D' as catch_category,
			10 * mfi.LAENGE as length_class, 
			1 * mfi.LANZAHL as catch_length_frequency
		from 
			`commercial_sample_final`.DLenFi mfi 
		where 
			mfi.JAHR = 2016	
		
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
		slf.catch_category		
 ) lw
 
 LEFT JOIN 	
	commercial_sample_final.AllFi af
on
 af.JAHR = lw.JAHR
and
 af.REISENR = lw.cruise
and
 af.STATION = lw.station
and
 af.FANGART = lw.catch_category 
and
 af.FISH = lw.species		
	
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
 	af.JAHR,
	lw.cruise,
	lw.station,
	lw.species,
	lw.catch_category
 
 
 
 
 