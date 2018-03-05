

set @year = 2016;

drop table if exists commercial_sample_process.MrktFi_split;
create table commercial_sample_process.MrktFi_split

##################################

SELECT
	smf.JAHR,
	smf.cruise,
	smf.station,
	smf.species,
	smf.catch_category,
	round(sum(smf.GESAMTKG),3) as total_weight,
	sum(smf.GESAMTSTCK) as total_numbers,
	round(sum(smf.UPKG),3) as sample_weight,
	sum(smf.UPSTCK) as sample_numbers
 
 
 FROM
  (SELECT
			mf.JAHR,
			mf.REISENR as cruise, 
			mf.STATION as station, 
			mf.FISH as species, 
			'L' as catch_category,
			sum(mf.GESAMTKG) as GESAMTKG,
			sum(mf.GESAMTSTCK) as GESAMTSTCK,
			sum(mf.UPKG) as UPKG,
			sum(mf.UPSTCK) as UPSTCK
			
	FROM
			commercial_sample_final.MrktFi mf

	WHERE 
		mf.UPKG is NOT NULL 
	AND 
		mf.UPKG IS NOT NULL
--	and 
--		mf.UPKG >0 
--	and 
--		mf.GESAMTKG >0	
 
 group by 
 mf.JAHR,
			mf.REISENR,
			mf.STATION, 
			mf.FISH
 union 
   (select 
		sw.`year`,
		sw.cruise,
		sw.station,
		sw.species,
		'L' as catch_category,
		0 as GESAMTKG,
		0 as GESAMTSTCK,
		sw.landing_component as UPKG,
		sum(sl.landing_length_total) as UPSTCK
   
	from commercial_sample_process.split_weight sw
	left join commercial_sample_process.split_length sl
		on sl.JAHR = sw.`year`
		and sl.cruise = sw.cruise
		and sl.station = sw.station
		and sl.species = sw.species
	
	where	
		sw.landing_component IS NOT NULL 
	and
		sw.treat_landing_sample = 'add' 

	group by 
		sw.`year`,
		sw.cruise,
		sw.station,
		sw.species
	) 

 ) smf

 
 
  group by 
  	smf.JAHR,
	smf.cruise,
	smf.station,
	smf.species,
	smf.catch_category
 
 