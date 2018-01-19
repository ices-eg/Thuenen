drop table if exists sample_valid;

create table 
sample_valid
 
-- -- -- -- -- Ergänzung von MrktFi und MLenFi -- -- -- -- -- 
 
 
select distinct
 mf.REISENR,
 mf.JAHR,
 mf.QUARTAL,
 mf.STATION,
 mf.FISH,
 mf.FANGART,
 mf.GESAMTKG,
 mf.GESAMTSTCK,
 mf.UPKG,
 mf.UPSTCK,

  mlf.reisenr as length_reisenr,
 (select distinct sum(mlf.LANZAHL) from commercial_sample_final.MLenFi mlf 
     where mlf.reisenr = mf.reisenr 
	 and mlf.station = mf.station 
	 and mlf.FISH = mf.fish
	 group by mf.reisenr, mf.station, mf.fish) as LengFi_UP,

 si.reisenr as SnglIOR_reisenr,
 
 (select distinct count(si.reisenr) from commercial_sample_final.SnglIOR si
     where mf.reisenr = si.reisenr
	 and mf.station = si.station
	 and mf.fish = si.fish
     group by si.reisenr, si.station, si.fish) as SnglIOR_count
 
 
from commercial_sample_final.MrktFi mf

left join
 commercial_sample_final.MLenFi mlf 
on 
 mlf.reisenr = mf.reisenr 
and  
 mlf.station = mf.station 
and
 mlf.FISH = mf.fish 
 
left join
 commercial_sample_final.SnglIOR si
on
 si.reisenr = mf.reisenr 
and 
 si.station = mf.station 
and 
 si.FISH = mf.fish 

 
-- -- -- -- -- -- Ergänzung von DiscFi und DLenFi -- -- -- -- --


union
select distinct
 df.REISENR,
 df.JAHR,
 df.QUARTAL,
 df.STATION,
 df.FISH,
 df.FANGART,
 df.GESAMTKG,
 df.GESAMTSTCK,
 df.UPKG,
 df.UPSTCK,

  dlf.reisenr as length_reisenr,
 (select distinct sum(dlf.LANZAHL) from commercial_sample_final.DLenFi dlf 
     where dlf.reisenr = df.reisenr 
	 and dlf.station = df.station 
	 and dlf.FISH = df.fish
	 group by df.reisenr, df.station, df.fish) as LengFi_UP,

 si.reisenr as SnglIOR_reisenr,
 
 (select distinct count(si.reisenr) from commercial_sample_final.SnglIOR si
     where df.reisenr = si.reisenr
	 and df.station = si.station
	 and df.fish = si.fish
     group by si.reisenr, si.station, si.fish) as SnglIOR_count
 
 
from commercial_sample_final.DiscFi df

left join
 commercial_sample_final.DLenFi dlf 
on 
 dlf.reisenr = df.reisenr 
and  
 dlf.station = df.station 
and
 dlf.FISH = df.fish 
 
left join
 commercial_sample_final.SnglIOR si
on
 si.reisenr = df.reisenr 
and 
 si.station = df.station 
and 
 si.FISH = df.fish 


-- -- -- -- -- -- Ergänzung von FishFi und LengFi-- -- -- -- --


union
select distinct
 ff.REISENR,
 ff.JAHR,
 ff.QUARTAL,
 ff.STATION,
 ff.FISH,
 'C' as FANGART,
 ff.GESAMTKG,
 ff.GESAMTSTCK,
 ff.UPKG,
 ff.UPSTCK,

  flf.reisenr as length_reisenr,
 (select distinct sum(flf.LANZAHL) from commercial_sample_final.LengFi flf 
     where flf.reisenr = ff.reisenr 
	 and flf.station = ff.station 
	 and flf.FISH = ff.fish
	 group by ff.reisenr, ff.station, ff.fish) as LengFi_UP,

 si.reisenr as SnglIOR_reisenr,
 
 (select distinct count(si.reisenr) from commercial_sample_final.SnglIOR si
     where ff.reisenr = si.reisenr
	 and ff.station = si.station
	 and ff.fish = si.fish
     group by si.reisenr, si.station, si.fish) as SnglIOR_count
 
 
from commercial_sample_final.FishFi ff

left join
 commercial_sample_final.LengFi flf 
on 
 flf.reisenr = ff.reisenr 
and  
 flf.station = ff.station 
and
 flf.FISH = ff.fish 
 
left join
 commercial_sample_final.SnglIOR si
on
 si.reisenr = ff.reisenr 
and 
 si.station = ff.station 
and 
 si.FISH = ff.fish 


;


-- -- -- -- -- -- Hinzufügen der sample_valid Einordnung (treat sample, Abschnitt '02 species') -- -- -- -- -- -- -- 


alter table sample_valid

add column sample_valid varchar (30)
;

-- -- -- -- -- -- -- -- -- --

update sample_valid gof

set sample_valid =
(case
	 when (gof.LengFi_UP is null) then ("catch")
	 when (gof.SnglIOR_count is null) then ("catch_length")
	 when (gof.SnglIOR_count is not null) then ("catch_length_bio")
	 else ("n.n.")
 end)
;
