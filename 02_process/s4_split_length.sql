# split length class 
# Längenklassen aus LnegFi werden entsprechend ihrer Zuteilung in der treat_sample in Landing und Discard (MLenFi / DLenFi) aufgeteilt.
# Basierend auf dieser Einteilung wird im nächsten Schritt der Catch (FishFi) proportional geteilt und Landing/Discard (MrktFi und DiscFi) aufgeschlagen.

drop table if exists commercial_sample_process.split_length;

set @year = 2016;
create table commercial_sample_process.split_length

select
 lf.JAHR,
 lf.cruise,
 lf.station,
 lf.species,
 lf.length_class,
# sum(lf.catch_length_frequency) as catch_length,
 ts.split_length_class,
 
 ts.treat_landing_frequency,
 (case 
	when (ts.treat_landing_frequency = "add" and lf.length_class >= ts.split_length_class) then (COALESCE (lf.catch_length_frequency,0) + COALESCE(lf.landing_length_frequency,0))
	when (ts.treat_landing_frequency = "neglect" and lf.length_class >= ts.split_length_class) then (sum(lf.landing_length_frequency)) 
	when (ts.treat_landing_frequency = "replace" and lf.length_class >= ts.split_length_class) then (sum(lf.catch_length_frequency))
	else (0)
	end) as landing_length_total,
	
 ts.treat_discard_frequency, 
 (case 
	when (ts.treat_discard_frequency = "add" and lf.length_class < ts.split_length_class) then (COALESCE(lf.catch_length_frequency,0) + COALESCE(lf.discard_length_frequency,0))
	when (ts.treat_discard_frequency = "neglect" and lf.length_class < ts.split_length_class) then (sum(lf.discard_length_frequency)) 
	when (ts.treat_discard_frequency = "replace" and lf.length_class < ts.split_length_class) then (sum(lf.catch_length_frequency))
	else(0)
	end) as discard_length_total
 
FROM
	(select 
		fi.JAHR,
		fi.REISENR as cruise, 
		fi.STATION as station, 
		fi.NETZ as net,
		fi.QUARTAL as quarter, 
		fi.FISH as species, 
		'U' as sex, 
		10 * fi.LAENGE as length_class, 
		1 * fi.LANZAHL as catch_length_frequency, 
		0 as landing_length_frequency, 
		0 as discard_length_frequency  

	from 
		`commercial_sample_final`.LengFi fi 
	where 
		fi.JAHR = @year
  
	union

	################################################
	#
	# landing temporary length frequency tlf

	select 
		fi.JAHR,
		fi.REISENR as cruise, 
		fi.STATION as station, 
		fi.NETZ as net,
		fi.QUARTAL as quarter,
		fi.FISH as species, 
		'U' as sex, 
		10 * fi.LAENGE as length_class, 
		0 as catch_length_frequency, 
		1 * fi.LANZAHL as landing_length_frequency, 
		0 as discard_length_frequency  

	from 
		`commercial_sample_final`.MLenFi fi 

	where 
		fi.JAHR = @year

	union

	##################################################
	#
	# discard temporary length frequency tlf

	select 
		fi.JAHR,
		fi.REISENR as cruise, 
		fi.STATION as station, 
		fi.NETZ as net,
		fi.QUARTAL as quarter,
		fi.FISH as species, 
		'U' as sex, 
		10 * fi.LAENGE as length_class, 
		0 as catch_length_frequency, 
		0 as landing_length_frequency, 
		1 * fi.LANZAHL as discard_length_frequency  

	from 
		`commercial_sample_final`.DLenFi fi 

	where 
		fi.JAHR = @year 

) lf
 
LEFT JOIN
 commercial_sample_process.treat_sample ts

on
 lf.JAHR = ts.this_year
and
 lf.cruise = ts.cruise
and
 lf.station = ts.station
and
 lf.species = ts.species
 
group by  
 lf.JAHR,
 lf.cruise,
 lf.station,
 lf.species,
 lf.length_class,
 ts.split_length_class,
 ts.treat_landing_frequency,
 ts.treat_discard_frequency