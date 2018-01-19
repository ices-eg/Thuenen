drop table if exists length_weight_coefficient;

create table length_weight_coefficient( 
 species_code char(3),
 species int,
 year int,
 sub_division int, 
 quarter int, 
 sx double, 
 sy double,
 sxy double,
 sqx double, 
 sqy double,
 sn double, 
 ln_a double,
 b  double, 
 r double 
);

insert into 
 length_weight_coefficient 
select 

 sc.a3_asfis as species_code,
 si.FISH as species,
 si.JAHR as year,
 1*st.SUBDIV as sub_division,
 si.QUARTAL as quarter,

 sum(log(si.LAENGE * 10)) as sx, 
 sum(log(si.TOTALGEW)) as sy,
 sum(log(si.LAENGE * 10) * log(si.TOTALGEW)) as sxy,
 sum(log(si.LAENGE * 10) * log(si.LAENGE * 10)) as sqx, 
 sum(log(si.TOTALGEW) * log(si.TOTALGEW)) as sqy,
 count(*) as sn, 
 0 as ln_a,
 0 as b, 
 0 as r

from 

 [commercial]_[final].SnglIOR as si,
 [commercial]_[final].StatFi st, 
 [commercial]_[parameter].species_code sc

where 
 si.JAHR = @year 
and 
 st.JAHR = si.JAHR
and 
 st.REISENR = si.REISENR 
and 
 st.STATION = si.STATION 
and 
 sc.bfa = si.FISH

group by 

 species_code,
 species,
 year,
 sub_division, 
 quarter 

;

################
# calculate b
################

update 
 length_weight_coefficient lw
set 
 lw.b = (lw.sn * lw.sxy - lw.sx * lw.sy) / (lw.sn * lw.sqx - lw.sx * lw.sx)
;

###############
#calculate ln_a
###############

update 
 length_weight_coefficient lw
set 
 lw.ln_a = (lw.sy - lw.b * lw.sx) / lw.sn
;

################
# calculate r^2
#
# r = (lw.sxy - 1/lw.sn * lw.sx * lw.sy)/sqrt((lw.sqx-1/lw.sn*lw.sx*lw.sx)*(lw.sqy-1/lw.sn*lw.sy*lw.sy))
# r = r*r
#
################


