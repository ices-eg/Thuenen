### raising factor 

set @year = 2016;

select distinct 

 *

from 

(

select 

 vru.this_year,
 vru.cruise,
 vru.station,
 vru.net,
 vru.species,
 vru.sex,
 vru.split_length_class,
 vru.sample_valid,
 vru.major_avg_class_mass_source,
 vru.treat_discard_frequency,
 vru.raising_mode,
 vru.raising_species_code,
 vru.raising_species,
 vru.sampling_factor,
 vru.treat_landing_sample, 
 vru.treat_landing_frequency,
 vru.fisher_landing_mass,
 vru.landing_sample_mass,
 vru.calc_landing_sample_mass,
 case 
  when vru.raising_factor_1 is not null
  then vru.raising_factor_1
  else vrx.raising_factor_1
 end as raising_factor

    from

(

select 

 af.JAHR as this_year,
 af.REISENR as cruise,
 af.STATION as station,
 af.NETZ as net,
 af.FISH as species, 
 ts.sex,
 ts.split_length_class,
 ts.sample_valid,
 bas.major_avg_class_mass_source,
 ts.treat_discard_frequency,
 ts.raising_mode,
 ts.raising_species_code,
 ts.raising_species,
 ts.sampling_factor,
 ts.treat_landing_sample, 
 ts.treat_landing_frequency,
 mf.GESAMTKG as fisher_landing_mass,
 mf.UPKG as landing_sample_mass,
 bas.total_landing_sample_mass as calc_landing_sample_mass, 

# zum testen
 bas.total_landing_sample_mass,
            
 case 

  when ts.raising_species = 0 
  then ts.sampling_factor 

  when ts.raising_species = ts.species 
   and mf.GESAMTKG is not null 
   and trim(ts.treat_landing_sample) in ('add') 
   and bas.total_landing_sample_mass > 0 
   and ts.raising_species > 0
  then round((bas.total_landing_sample_mass / 1000 + mf.GESAMTKG) / (bas.total_landing_sample_mass / 1000), 5)

  when ts.raising_species = ts.species 
   and mf.GESAMTKG is not null 
   and bas.total_landing_sample_mass > 0 
   and trim(ts.treat_landing_sample) in ('neglect') 
   and ts.raising_species > 0
  then round(mf.GESAMTKG/(bas.total_landing_sample_mass / 1000), 5) 

  else null 

 end as raising_factor_1

from

 commercial_sample_final.AllFi af 

left join 

 commercial_sample_final.MrktFi mf 

on 

 af.JAHR = mf.JAHR
and 
 af.REISENR = mf.REISENR
and 
 af.STATION = mf.STATION
and 
 af.NETZ = mf.NETZ
and 
 af.FISH = mf.FISH

left join 

 commercial_sample_process.station_sample_split bas 

on  

 bas.cruise = af.REISENR
and 
 bas.station = af.STATION 
and 
 bas.net = af.NETZ
and 
 bas.species = af.FISH
and 
 bas.this_year = af.JAHR

left join

 commercial_sample_process.treat_sample ts 

on 

 af.REISENR =ts.cruise
and 
 af.JAHR = ts.this_year
and 
 af.STATION = ts.station
and 
 af.NETZ = ts.net
and 
 af.FISH = ts.species


) vru 

left join

(

select  
 
 vr.this_year,
 vr.cruise,
 vr.station,
 vr.net,
 vr.species,
 vr.sex,
 vr.raising_species,
 vr.raising_factor_1

from

(

select 

 af.JAHR as this_year,
 af.REISENR as cruise,
 af.STATION as station,
 af.NETZ as net,
 af.FISH as species,
 ts.sex,
 ts.split_length_class,
 ts.sample_valid,
 bas.major_avg_class_mass_source,
 ts.treat_discard_frequency,
 ts.raising_mode,
 ts.raising_species_code,
 ts.raising_species,
 ts.sampling_factor,
 ts.treat_landing_sample, 
 ts.treat_landing_frequency,
 mf.GESAMTKG as fisher_landing_mass,
 mf.UPKG as landing_sample_mass,
 bas.total_landing_sample_mass as calc_landing_sample_mass, 

 round(

   if(mf.GESAMTKG is not null,

      if(trim(ts.treat_landing_sample) in ('add'), 
        (bas.total_landing_sample_mass / 1000 + mf.GESAMTKG), 
         mf.GESAMTKG), 

      bas.total_landing_sample_mass / 1000) / 
       if(bas.total_landing_sample_mass > 0, 
          bas.total_landing_sample_mass / 1000
          ,1)

   ,5) as raising_factor,
            
 case 

   when ts.raising_species = 0 
   then ts.sampling_factor
             
   when ts.raising_species = ts.species 
    and mf.GESAMTKG is not null 
    and trim(ts.treat_landing_sample) in ('add') 
    and bas.total_landing_sample_mass > 0 
    and ts.raising_species > 0
   then round((bas.total_landing_sample_mass / 1000 + mf.GESAMTKG) / (bas.total_landing_sample_mass / 1000), 5)

   when ts.raising_species = ts.species 
    and mf.GESAMTKG is not null 
    and bas.total_landing_sample_mass > 0 
    and trim(ts.treat_landing_sample) in ('neglect') 
    and ts.raising_species > 0
   then round(mf.GESAMTKG/(bas.total_landing_sample_mass / 1000), 5)
        
  else 

   null 

 end as raising_factor_1
         
from 

 commercial_sample_final.AllFi af 

left join 

 commercial_sample_final.MrktFi mf 

on 

 af.JAHR = mf.JAHR
and 
 af.REISENR = mf.REISENR
and 
 af.STATION = mf.STATION
and 
 af.NETZ = mf.NETZ
and 
 af.FISH = mf.FISH

left join 

 commercial_sample_process.station_sample_split bas

on  

 bas.cruise = af.REISENR
and 
 bas.station = af.STATION 
and 
 bas.net = af.NETZ
and 
 bas.species = af.FISH
and 
 bas.this_year = af.JAHR

left join

 commercial_sample_process.treat_sample ts 

on 

 af.REISENR =ts.cruise
and 
 af.JAHR = ts.this_year
and 
 af.STATION = ts.station
and 
af.NETZ = ts.net
and 
 af.FISH = ts.species
 
where 

 mf.GESAMTKG is not null
and 
 af.JAHR = @year
    
) vr

where 

 vr.raising_factor_1 is not null

)vrx 

on 

 vru.raising_species =vrx.species
and 
 vru.cruise =vrx.cruise
and 
 vru.this_year = vrx.this_year
and 
 vru.station = vrx.station
and 
 vru.net = vrx.net
and 
 vru.sex = vrx.sex

) vrxx