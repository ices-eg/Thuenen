drop table if exists sample_valid;

-- MrktFi -- Landings

CREATE TABLE com_sample_process.sample_valid AS
SELECT 
  mf.reisenr,
  mf.jahr,
  mf.quartal,
  mf.station,
  mf.fish,
  'L' as fangart,
  mf.gesamtkg,
  mf.upkg,
  mf.upstck,
  mlf.LengFi_UP,
  si.SnglIOR_count,
  case
	 when (mlf.LengFi_UP is null) then ('catch')
	 when (si.SnglIOR_count is null) then ('catch_length')
	 when (si.SnglIOR_count is not null) then ('catch_length_bio')
	 else ('n.n.')
   end AS sample_valid
FROM com_sample_final.MrktFi mf
LEFT JOIN
(SELECT reisenr,station,fish,sum(lanzahl) as LengFI_UP FROM com_sample_final.MLenFi GROUP BY reisenr,station,fish) mlf
ON mf.reisenr = mlf.reisenr AND
   mf.station = mlf.station AND
   mf.fish = mlf.fish
LEFT JOIN
(SELECT reisenr,station,fish,count(identnr) as SnglIOR_count FROM com_sample_final.SnglIOR GROUP BY reisenr,station,fish) si
ON mf.reisenr = si.reisenr AND
   mf.station = si.station AND
   mf.fish = si.fish
   
UNION

-- DiscFi -- Discards

SELECT 
  mf.reisenr,
  mf.jahr,
  mf.quartal,
  mf.station,
  mf.fish,
  'D' as fangart,
  mf.gesamtkg,
  mf.upkg,
  mf.upstck,
  mlf.LengFi_UP,
  si.SnglIOR_count,
  case
	 when (mlf.LengFi_UP is null) then ('catch')
	 when (si.SnglIOR_count is null) then ('catch_length')
	 when (si.SnglIOR_count is not null) then ('catch_length_bio')
	 else ('n.n.')
   end AS sample_valid
FROM com_sample_final.DiscFi mf
LEFT JOIN
(SELECT reisenr,station,fish,sum(lanzahl) as LengFI_UP FROM com_sample_final.DLenFi GROUP BY reisenr,station,fish) mlf
ON mf.reisenr = mlf.reisenr AND
   mf.station = mlf.station AND
   mf.fish = mlf.fish
LEFT JOIN
(SELECT reisenr,station,fish,count(identnr) as SnglIOR_count FROM com_sample_final.SnglIOR GROUP BY reisenr,station,fish) si
ON mf.reisenr = si.reisenr AND
   mf.station = si.station AND
   mf.fish = si.fish

UNION

-- uncategorized FishFi -- catch

SELECT 
  mf.reisenr,
  mf.jahr,
  mf.quartal,
  mf.station,
  mf.fish,
  'C' as fangart,
  mf.gesamtkg,
  mf.upkg,
  mf.upstck,
  mlf.LengFi_UP,
  si.SnglIOR_count,
  case
	 when (mlf.LengFi_UP is null) then ('catch')
	 when (si.SnglIOR_count is null) then ('catch_length')
	 when (si.SnglIOR_count is not null) then ('catch_length_bio')
	 else ('n.n.')
   end AS sample_valid
FROM com_sample_final.FishFi mf
LEFT JOIN
(SELECT reisenr,station,fish,sum(lanzahl) as LengFI_UP FROM com_sample_final.LengFi GROUP BY reisenr,station,fish) mlf
ON mf.reisenr = mlf.reisenr AND
   mf.station = mlf.station AND
   mf.fish = mlf.fish
LEFT JOIN
(SELECT reisenr,station,fish,count(identnr) as SnglIOR_count FROM com_sample_final.SnglIOR GROUP BY reisenr,station,fish) si
ON mf.reisenr = si.reisenr AND
   mf.station = si.station AND
   mf.fish = si.fish
;

