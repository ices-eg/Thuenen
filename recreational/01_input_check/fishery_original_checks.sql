


drop table if exists `commercial_sample_persist`.`check_error_summary`;

create table 
 `commercial_sample_persist`.`check_error_summary` 
(
 year int not null, 
 error_code varchar(53) not null, 
 error_count bigint, 
 error_description varchar(254) 
);



drop table if exists `commercial_sample_persist`.`check_action_summary`;

create table 
 `commercial_sample_persist`.`check_action_summary` 
(
 error_code varchar(53), 
 year int, 
 vessel varchar(13), 
 trip int, 
 key_string varchar(254), 
 corr_action varchar(254) 
);




set @_ = concat("__________________________________________________________________________________");
select @_;
set @_ = concat(" try at ", now(), " check_commercial_sample_original.check_vessel_no_type");
select @_;


drop table if exists `commercial_sample_persist`.`check_vessel_no_type`;

create table 
 `commercial_sample_persist`.`check_vessel_no_type`
select 
 year(vt.gueltig_bis_n) as vessel_year, 
 vt.vessel_id as vessel_vessel,
 vt.gueltig_von_n as gueltig_von_datum, 
 vt.gueltig_bis_n as gueltig_bis_datum, 
 vt.type_code, 
 vt.type_name, 
 
 'check in base commercial_sample_persist in table vessel_type (add type_code and type_name)' as corr_action 

from 

 `commercial_sample_persist`.`vessel_type` vt

where 

 vt.type_code = 0 
or  
 vt.type_name = ''  

;



insert into 
 `commercial_sample_persist`.`check_error_summary` 
select 
 vessel_year as year, 
 'vessel_no_type' as error_code, 
 count(*) as error_count, 
 '-- fatal -- : number of entries in table vessel_type having no type_code or type_name' as error_description
from 

 `commercial_sample_persist`.`check_vessel_no_type` 

group by 
 year 
;

 

insert into 
 `commercial_sample_persist`.`check_action_summary` 
select 
 es.error_code, 
 vnt.vessel_year as year, 
 vnt.vessel_vessel as vessel,
 '' as trip,
 concat('_',vnt.gueltig_von_datum,'_',vnt.gueltig_bis_datum) as key_string,
 vnt.corr_action  
from 
 `commercial_sample_persist`.`check_vessel_no_type` vnt, 
 `commercial_sample_persist`.`check_error_summary` es 
where 
 vnt.vessel_year = es.year
and 
 es.error_code = 'vessel_no_type' 
;




set @_ = concat("__________________________________________________________________________________");
select @_;
set @_ = concat(" try at ", now(), " check_commercial_sample_persist.check_trip_no_vessel");
select @_;

drop table if exists `commercial_sample_persist`.`check_trip_no_vessel`;

create table 
 `commercial_sample_persist`.`check_trip_no_vessel`

select distinct 
 yy.trip_year, 
 yy.trip_vessel, 
 yy.REISENR as trip_trip, 
 yy.REISE_VON as trip_date, 
 yy.gueltig_von_datum, 
 yy.gueltig_bis_datum, 
 yy.corr_action  
from 
(

select 
 *
from 
(
select 
 r.JAHR as trip_year, 
 r.EU_NR as trip_vessel,
 vt.vessel_id,
 r.REISENR,
 r.REISE_VON,
 r.REISE_BIS,
 vt.gueltig_von_n as gueltig_von_datum, 
 vt.gueltig_bis_n as gueltig_bis_datum, 
 r.F_LEITER,
 'check for mismatch (also EU_NR !) in base commercial_sample_original in table Reise (corr or del line) and commercial_sample_persisttable vessel_type (corr or add line)' as corr_action 

from 

 `commercial_sample_original`.`Reise` r

left join 

 `commercial_sample_persist`.`vessel_type` vt

on 

  str_to_date(r.REISE_VON, '%Y%m%d') between vt.gueltig_von_n and vt.gueltig_bis_n 

and 

 vt.vessel_id = r.EU_NR 

) xx


where 

 xx.vessel_id is null 
) yy
;




insert into 
 `commercial_sample_persist`.`check_error_summary` 
select 
 trip_year as year, 
 'trip_no_vessel' as error_code, 
 count(*) as error_count, 
 '-- fatal -- : number of entries in table Reise having no key entry in vessel_type' as error_description
from 

 `commercial_sample_persist`.`check_trip_no_vessel` 

group by 
 year 
;

 

insert into 
 `commercial_sample_persist`.`check_action_summary` 
select 
 es.error_code, 
 tnv.trip_year as year, 
 tnv.trip_vessel as vessel,
 tnv.trip_trip as trip,
 concat('_',tnv.trip_date) as key_string,
 tnv.corr_action  
from 
 `commercial_sample_persist`.`check_trip_no_vessel` tnv, 
 `commercial_sample_persist`.`check_error_summary` es 
where 
 tnv.trip_year = es.year
and 
 es.error_code = 'trip_no_vessel' 
;






#__INCLUDE__

set @_ = concat("__________________________________________________________________________________");
select @_;
set @_ = concat(" try at ", now(), " check_commercial_sample_original.check_station_no_trip ");
select @_;

drop table if exists `commercial_sample_persist`.`check_station_no_trip`;

create table 
 `commercial_sample_persist`.`check_station_no_trip`
select 
 *
from 
(
select 
 s.JAHR as station_year, 

 s.EU_NR as station_vessel,
 r.EU_NR as trip_vessel,

 s.REISENR as station_trip,
 r.REISENR as trip_trip,

 s.STATION as station_station,

 s.STATDATUM as station_date,

 concat(s.DIVISION, s.SUBDIV) as station_area,

 'check for mismatch (also EU_NR !)  in base commercial_sample_original in table StatFi (corr or del line) and Reise (corr or add line)' as corr_action 

from 

 `commercial_sample_original`.`StatFi` s

left join 

 `commercial_sample_original`.`Reise` r

on 
 r.JAHR = s.JAHR 
and 
 r.EU_NR = s.EU_NR 
and
 r.REISENR = s.REISENR 

) xx

where 
 xx.trip_trip is null 
;


insert into 
 `commercial_sample_persist`.`check_error_summary`
select 
 station_year as year, 
 'station_no_trip' as error_code, 
 count(*) as error_count, 
 '-- fatal -- : number of entries in table StatFi having no key entry in Reise' as error_description
from 

 `commercial_sample_persist`.`check_station_no_trip`

group by 
 year 
;



insert into 
 `commercial_sample_persist`.`check_action_summary`
select 
 es.error_code, 
 snt.station_year, 
 snt.station_vessel, 
 snt.station_trip, 
 concat('_',snt.station_station,'_',snt.station_date) as key_string, 
 snt.corr_action  
from 
 `commercial_sample_persist`.`check_station_no_trip` snt, 
 `commercial_sample_persist`.`check_error_summary` es

where

 snt.station_year = es.year
and 
 es.error_code = 'station_no_trip' 
;




set @_ = concat("__________________________________________________________________________________");
select @_;
set @_ = concat(" try at ", now(), " check_commercial_sample_original.check_trip_no_station ");
select @_;

drop table if exists `commercial_sample_persist`.`check_trip_no_station`;

create table 
 `commercial_sample_persist`.`check_trip_no_station`
select 
 *
from 
(
select 
 r.JAHR as trip_year, 

 r.EU_NR as trip_vessel,
 s.EU_NR as station_vessel, 

 r.REISENR as trip_trip,
 s.REISENR as station_trip, 

 concat(s.DIVISION, s.SUBDIV) as station_area,

 'check for mismatch (also EU_NR !) in base commercial_sample_original in table Reise (corr or del line) and StatFi (corr or add line)' as corr_action 

from 

 `commercial_sample_original`.`Reise` r

left join 

 `commercial_sample_original`.`StatFi` s

on 
 r.JAHR = s.JAHR 
and 
 r.EU_NR = s.EU_NR 
and
 r.REISENR = s.REISENR 

) xx

where 

 xx.station_trip is null 

;



insert into 
 `commercial_sample_persist`.`check_error_summary`
select 
 trip_year as year, 
 'trip_no_station' as error_code, 
 count(*) as error_count, 
 '-- fatal -- : number of entries in table Reise having no key entry in StatFi' as error_description
from 

 `commercial_sample_persist`.`check_trip_no_station`

group by 
 year 
;


insert into 
 `commercial_sample_persist`.`check_action_summary` 
select 
 es.error_code, 
 tns.trip_year as year, 
 tns.trip_vessel as vessel,
 tns.trip_trip as trip,
 concat('') as key_string,
 tns.corr_action  
from 
 `commercial_sample_persist`.`check_trip_no_station` tns, 
 `commercial_sample_persist`.`check_error_summary` es 
where 
 tns.trip_year = es.year
and 
 es.error_code = 'trip_no_station' 
;






set @_ = concat("__________________________________________________________________________________");
select @_;
set @_ = concat(" try at ", now(), " check_commercial_sample_original.check_haul_no_station ");
select @_;

drop table if exists `commercial_sample_persist`.`check_haul_no_station`;

create table 
 `commercial_sample_persist`.`check_haul_no_station`
select 
 *
from 
(
select 
 n.JAHR as haul_year, 

 n.EU_NR as haul_vessel, 
 s.EU_NR as station_vessel,

 n.REISENR as haul_trip,
 s.REISENR as station_trip, 

 n.STATION as haul_station,
 s.STATION as station_station,

 n.STATDATUM as haul_date,
 s.STATDATUM as station_date,

 concat(s.DIVISION, s.SUBDIV) as station_area,

 'check for mismatch (also EU_NR !) in base commercial_sample_original in table NetzFi (corr or del line) and StatFi (corr or add line)' as corr_action 

from 

 `commercial_sample_original`.`NetzFi` n

left join 

 `commercial_sample_original`.`StatFi` s

on 
 s.JAHR = n.JAHR 
and 
 s.EU_NR = n.EU_NR 
and
 s.REISENR = n.REISENR 
and
 s.STATION = n.STATION 

) xx

where 
 xx.station_station is null 
;




insert into 
 `commercial_sample_persist`.`check_error_summary`
select 
 haul_year as year, 
 'haul_no_station' as error_code, 
 count(*) as error_count, 
 '-- fatal -- : number of entries in table NetzFi having no key entry in StatFi' as error_description
from 

 `commercial_sample_persist`.`check_haul_no_station`

group by 
 year 
;



insert into 
 `commercial_sample_persist`.`check_action_summary` 
select 
 es.error_code, 
 hns.haul_year as year, 
 hns.haul_vessel as vessel,
 hns.haul_trip as trip,
 concat('_',hns.haul_station,'_',hns.haul_date) as key_string,
 hns.corr_action  
from 
 `commercial_sample_persist`.`check_haul_no_station` hns, 
 `commercial_sample_persist`.`check_error_summary` es 
where 
 hns.haul_year = es.year
and 
 es.error_code = 'haul_no_station' 
;



set @_ = concat("__________________________________________________________________________________");
select @_;
set @_ = concat(" try at ", now(), " check_commercial_sample_original.check_station_no_haul ");
select @_;

drop table if exists `commercial_sample_persist`.`check_station_no_haul`;

create table 
 `commercial_sample_persist`.`check_station_no_haul`
select 
 *
from 
(
select 
 s.JAHR as station_year, 

 s.EU_NR as station_vessel,
 n.EU_NR as haul_vessel,

 s.REISENR as station_trip,
 n.REISENR as haul_trip, 

 s.STATION as station_station,
 n.STATION as haul_station,

 s.STATDATUM as station_date,
 n.STATDATUM as haul_date,

 concat(s.DIVISION, s.SUBDIV) as station_area,

 'check for mismatch (also EU_NR !) in base commercial_sample_original in table StatFi (corr or del line) and NetzFi (corr or add line)' as corr_action 

from 

 `commercial_sample_original`.`StatFi` s

left join 

 `commercial_sample_original`.`NetzFi` n

on 
 n.JAHR = s.JAHR 
and 
 n.EU_NR = s.EU_NR 
and
 n.REISENR = s.REISENR 
and
 n.STATION = s.STATION 

) xx

where 

 xx.haul_station is null 

;
 
 

insert into 
 `commercial_sample_persist`.`check_error_summary`
select 
 station_year as year, 
 'station_no_haul' as error_code, 
 count(*) as error_count, 
 '-- fatal -- : number of entries in table StatFi having no key entry in NetzFi' as error_description
from 

 `commercial_sample_persist`.`check_station_no_haul`

group by 
 year 
;



insert into 
 `commercial_sample_persist`.`check_action_summary` 
select 
 es.error_code, 
 snh.station_year as year, 
 snh.station_vessel as vessel,
 snh.station_trip as trip,
 concat('_',snh.station_station,'_',snh.station_date) as key_string,
 snh.corr_action  
from 
 `commercial_sample_persist`.`check_station_no_haul` snh, 
 `commercial_sample_persist`.`check_error_summary` es 
where 
 snh.station_year = es.year
and 
 es.error_code = 'station_no_haul' 
;




set @_ = concat("__________________________________________________________________________________");
select @_;
set @_ = concat(" try at ", now(), " check_commercial_sample_original.check_catch_no_haul ");
select @_;

drop table if exists `commercial_sample_persist`.`check_catch_no_haul`;

create table 
 `commercial_sample_persist`.`check_catch_no_haul`
select 
 *
from 
(
select 
 f.JAHR as catch_year, 

 f.EU_NR as catch_vessel,
 n.EU_NR as haul_vessel,

 f.REISENR as catch_trip,
 n.REISENR as haul_trip,

 f.STATION as catch_station,
 n.STATION as haul_station,

 f.STATDATUM as catch_date,
 n.STATDATUM as haul_date,

 'check for mismatch (also EU_NR !) in base commercial_sample_original in table FishFi (corr or del line) and NetzFi (corr or add line)' as corr_action 

from 

 `commercial_sample_original`.`FishFi` f

left join 

 `commercial_sample_original`.`NetzFi` n

on 

 n.JAHR = f.JAHR 
and 
 n.EU_NR = f.EU_NR 
and
 n.REISENR = f.REISENR 
and
 n.STATION = f.STATION 

) xx

where 

 xx.haul_station is null 

;





insert into 
 `commercial_sample_persist`.`check_error_summary`
select 
 catch_year as year, 
 'catch_no_haul' as error_code, 
 count(*) as error_count, 
 '-- fatal -- : number of entries in table FishFi having no key entry in NetzFi' as error_description
from 

 `commercial_sample_persist`.`check_catch_no_haul`

group by 
 year 
;


insert into 
 `commercial_sample_persist`.`check_action_summary` 
select 
 es.error_code, 
 cnh.catch_year as year, 
 cnh.catch_vessel as vessel,
 cnh.catch_trip as trip,
 concat('_',cnh.catch_station,'_',cnh.catch_date) as key_string,
 cnh.corr_action  
from 
 `commercial_sample_persist`.`check_catch_no_haul` cnh, 
 `commercial_sample_persist`.`check_error_summary` es 
where 
 cnh.catch_year = es.year
and 
 es.error_code = 'catch_no_haul' 
;




set @_ = concat("__________________________________________________________________________________");
select @_;
set @_ = concat(" try at ", now(), " check_commercial_sample_original.check_haul_no_catch ");
select @_;

drop table if exists `commercial_sample_persist`.`check_haul_no_catch`;

create table 
 `commercial_sample_persist`.`check_haul_no_catch`
select 
 *
from 
(
select 

 n.JAHR as haul_year, 

 n.EU_NR as haul_vessel,
 f.EU_NR as catch_vessel,

 n.REISENR as haul_trip,
 f.REISENR as catch_trip,

 n.STATION as haul_station,
 f.STATION as catch_station,

 n.STATDATUM as haul_date,
 f.STATDATUM as catch_date,

 'check for mismatch (also EU_NR !) in base commercial_sample_original in table NetzFi (corr or del line) and FishFi (corr or add line)' as corr_action 

from 

 `commercial_sample_original`.`NetzFi` n

left join 

 `commercial_sample_original`.`FishFi` f

on 
 f.JAHR = n.JAHR 
and 
 f.EU_NR = n.EU_NR 
and
 f.REISENR = n.REISENR 
and
 f.STATION = n.STATION 

) xx

where 

 xx.catch_station is null 

and 

-- # all years where catch is already split into discard and landing 
-- # (i.e. having no FishFi entries)
-- # would produce a lot of entries in the error tables 
-- # if not excluded from error cases by that list

 xx.haul_year in (2012)

;


set @_ = concat(" catch not yet split year list = >>2012<< ");
select @_;



insert into 
 `commercial_sample_persist`.`check_error_summary`
select 
 haul_year as year, 
 'haul_no_catch' as error_code, 
 count(*) as error_count, 
 '-- check -- : number of entries in table NetzFi having no key entry in FishFi' as error_description
from 

 `commercial_sample_persist`.`check_haul_no_catch`

group by 
 year 
;



insert into 
 `commercial_sample_persist`.`check_action_summary` 
select 
 es.error_code, 
 hnc.haul_year as year, 
 hnc.haul_vessel as vessel,
 hnc.haul_trip as trip,
 concat('_',hnc.haul_station,'_',hnc.haul_date) as key_string,
 hnc.corr_action  
from 
 `commercial_sample_persist`.`check_haul_no_catch` hnc, 
 `commercial_sample_persist`.`check_error_summary` es 
where 
 hnc.haul_year = es.year
and 
 es.error_code = 'haul_no_catch' 
;





set @_ = concat("__________________________________________________________________________________");
select @_;
set @_ = concat(" try at ", now(), " check_commercial_sample_original.check_landing_no_haul ");
select @_;

drop table if exists `commercial_sample_persist`.`check_landing_no_haul`;

create table 
 `commercial_sample_persist`.`check_landing_no_haul`
select 
 *
from 
(
select 
 l.JAHR as landing_year, 

 l.EU_NR as landing_vessel,
 n.EU_NR as haul_vessel,

 l.REISENR as landing_trip,
 n.REISENR as haul_trip,

 l.STATION as landing_station,
 n.STATION as haul_station,

 l.STATDATUM as landing_date,
 n.STATDATUM as haul_date,

 'check for mismatch (also EU_NR !) in base commercial_sample_original in table MrktFi (corr or del line) and NetzFi (corr or add line)' as corr_action 

from 

 `commercial_sample_original`.`MrktFi` l

left join 

 `commercial_sample_original`.`NetzFi` n

on 
 n.JAHR = l.JAHR 
and 
 n.EU_NR = l.EU_NR 
and
 n.REISENR = l.REISENR 
and
 n.STATION = l.STATION 

) xx

where 

 xx.haul_station is null 

;


insert into 
 `commercial_sample_persist`.`check_error_summary`
select 
 landing_year as year, 
 'landing_no_haul' as error_code, 
 count(*) as error_count, 
 '-- fatal -- : number of entries in table MrktFi having no key entry in NetzFi' as error_description
from 

 `commercial_sample_persist`.`check_landing_no_haul`

group by 
 year 
;


insert into 
 `commercial_sample_persist`.`check_action_summary` 
select 
 es.error_code, 
 lnh.landing_year as year, 
 lnh.landing_vessel as vessel,
 lnh.landing_trip as trip,
 concat('_',lnh.landing_station,'_',lnh.landing_date) as key_string,
 lnh.corr_action  
from 
 `commercial_sample_persist`.`check_landing_no_haul` lnh, 
 `commercial_sample_persist`.`check_error_summary` es 
where 
 lnh.landing_year = es.year
and 
 es.error_code = 'landing_no_haul' 
;




set @_ = concat("__________________________________________________________________________________");
select @_;
set @_ = concat(" try at ", now(), " check_commercial_sample_original.check_haul_no_landing ");
select @_;

drop table if exists `commercial_sample_persist`.`check_haul_no_landing`;

create table 
 `commercial_sample_persist`.`check_haul_no_landing`
select 
 *
from 
(
select 
 n.JAHR as haul_year, 

 n.EU_NR as haul_vessel,
 l.EU_NR as landing_vessel,

 n.REISENR as haul_trip,
 l.REISENR as landing_trip,

 n.STATION as haul_station,
 l.STATION as landing_station,

 n.STATDATUM as haul_date,
 l.STATDATUM as landing_date,

 'check for mismatch (also EU_NR !) in base commercial_sample_original in table NetzFi (corr or del line) and MrktFi (corr or add line)' as corr_action 

from 

 `commercial_sample_original`.`NetzFi` n

left join 

 `commercial_sample_original`.`MrktFi` l

on 
 l.JAHR = n.JAHR 
and 
 l.EU_NR = n.EU_NR 
and
 l.REISENR = n.REISENR 
and
 l.STATION = n.STATION 

) xx

where 

 xx.landing_station is null 

;


insert into 
 `commercial_sample_persist`.`check_error_summary`
select 
 haul_year as year, 
 'haul_no_landing' as error_code, 
 count(*) as error_count, 
 '-- fatal -- : number of entries in table NetzFi having no key entry in MrktFi' as error_description
from 

 `commercial_sample_persist`.`check_haul_no_landing`

group by 
 year 
;



insert into 
 `commercial_sample_persist`.`check_action_summary` 
select 
 es.error_code, 
 hnl.haul_year as year, 
 hnl.haul_vessel as vessel,
 hnl.haul_trip as trip,
 concat('_',hnl.haul_station,'_',hnl.haul_date) as key_string,
 hnl.corr_action  
from 
 `commercial_sample_persist`.`check_haul_no_landing` hnl, 
 `commercial_sample_persist`.`check_error_summary` es 
where 
 hnl.haul_year = es.year
and 
 es.error_code = 'haul_no_landing' 
;





set @_ = concat("__________________________________________________________________________________");
select @_;
set @_ = concat(" try at ", now(), " check_commercial_sample_original.check_discard_no_haul ");
select @_;

drop table if exists `commercial_sample_persist`.`check_discard_no_haul`;

create table 
 `commercial_sample_persist`.`check_discard_no_haul`
select 
 *
from 
(
select 
 d.JAHR as discard_year, 

 d.EU_NR as discard_vessel,
 n.EU_NR as haul_vessel,

 d.REISENR as discard_trip,
 n.REISENR as haul_trip,

 d.STATION as discard_station,
 n.STATION as haul_station,

 d.STATDATUM as discard_date,
 n.STATDATUM as haul_date,

 'check for mismatch (also EU_NR !) in base commercial_sample_original in table DiscFi (corr or del line) and NetzFi (corr or add line)' as corr_action 

from 

 `commercial_sample_original`.`DiscFi` d

left join 

 `commercial_sample_original`.`NetzFi` n

on 
 n.JAHR = d.JAHR 
and 
 n.EU_NR = d.EU_NR 
and
 n.REISENR = d.REISENR 
and
 n.STATION = d.STATION 

) xx

where 

 xx.haul_station is null 

;



insert into 
 `commercial_sample_persist`.`check_error_summary`
select 
 discard_year as year, 
 'discard_no_haul' as error_code, 
 count(*) as error_count, 
 '-- fatal -- : number of entries in table DiscFi having no key entry in NetzFi' as error_description
from 

 `commercial_sample_persist`.`check_discard_no_haul`

group by 
 year 
;


insert into 
 `commercial_sample_persist`.`check_action_summary` 
select 
 es.error_code, 
 dnh.discard_year as year, 
 dnh.discard_vessel as vessel,
 dnh.discard_trip as trip,
 concat('_',dnh.discard_station,'_',dnh.discard_date) as key_string,
 dnh.corr_action  
from 
 `commercial_sample_persist`.`check_discard_no_haul` dnh, 
 `commercial_sample_persist`.`check_error_summary` es 
where 
 dnh.discard_year = es.year
and 
 es.error_code = 'discard_no_haul' 
;




set @_ = concat("__________________________________________________________________________________");
select @_;
set @_ = concat(" try at ", now(), " check_commercial_sample_original.check_haul_no_discard ");
select @_;

drop table if exists `commercial_sample_persist`.`check_haul_no_discard`;

create table 
 `commercial_sample_persist`.`check_haul_no_discard`
select 
 *
from 
(
select 
 n.JAHR as haul_year, 

 n.EU_NR as discard_vessel,
 d.EU_NR as haul_vessel,

 n.REISENR as haul_trip,
 d.REISENR as discard_trip,

 n.STATION as haul_station,
 d.STATION as discard_station,

 n.STATDATUM as haul_date,
 d.STATDATUM as discard_date,

 'check for mismatch (also EU_NR !) in base commercial_sample_original in table NetzFi (corr or del line) and DiscFi (corr or add line)' as corr_action 

from 

 `commercial_sample_original`.`NetzFi` n

left join 

 `commercial_sample_original`.`DiscFi` d

on 
 d.JAHR = n.JAHR 
and 
 d.EU_NR = n.EU_NR 
and
 d.REISENR = n.REISENR 
and
 d.STATION = n.STATION 

) xx

where 

 xx.haul_station is null 

;


insert into 
 `commercial_sample_persist`.`check_error_summary`
select 
 haul_year as year, 
 'haul_no_discard' as error_code, 
 count(*) as error_count, 
 '--  fatal -- : number of entries in table NetzFi having no key entry in DiscFi' as error_description
from 

 `commercial_sample_persist`.`check_haul_no_discard`

group by 
 year 
;


insert into 
 `commercial_sample_persist`.`check_action_summary` 
select 
 es.error_code, 
 hnd.haul_year as year, 
 hnd.haul_vessel as vessel,
 hnd.haul_trip as trip,
 concat('_',hnd.haul_station,'_',hnd.haul_date) as key_string,
 hnd.corr_action  
from 
 `commercial_sample_persist`.`check_haul_no_discard` hnd, 
 `commercial_sample_persist`.`check_error_summary` es 
where 
 hnd.haul_year = es.year
and 
 es.error_code = 'haul_no_discard' 
;



set @_ = concat("__________________________________________________________________________________");
select @_;
set @_ = concat(" try at ", now(), " check_commercial_sample_original.check_landing_no_discard ");
select @_;

drop table if exists `commercial_sample_persist`.`check_landing_no_discard`;

create table 
 `commercial_sample_persist`.`check_landing_no_discard`
select 
 *
from 
(
select 
 l.JAHR as landing_year, 

 l.EU_NR as landing_vessel,
 d.EU_NR as discard_vessel,

 l.REISENR as landing_trip,
 d.REISENR as discard_trip,

 l.STATION as landing_station,
 d.STATION as discard_station,

 l.STATDATUM as landing_date,
 d.STATDATUM as discard_date,

 l.FISH as landing_species,
 d.FISH as discard_species, 

 l.GESAMTKG as landing_catch, 
 d.GESAMTKG as discard_catch,

 l.UPKG as landing_sample_mass,
 d.UPKG as discard_sample_mass,

 l.UPSTCK as landing_sample_number, 
 d.UPSTCK as discard_sample_number,

 'check for mismatch (also EU_NR !) in base commercial_sample_original in table MrktFi (corr or del line) and DiscFi (corr or add line)' as corr_action 

from 

 `commercial_sample_original`.`MrktFi` l

left join 

 `commercial_sample_original`.`DiscFi` d

on 
 d.JAHR = l.JAHR 
and 
 d.EU_NR = l.EU_NR 
and
 d.REISENR = l.REISENR 
and
 d.STATION = l.STATION 
and
 d.FISH = l.FISH

) xx

where 
 xx.landing_species is null 
;


insert into 
 `commercial_sample_persist`.`check_error_summary`
select 
 landing_year as year, 
 'landing_no_discard' as error_code, 
 count(*) as error_count, 
 '-- fatal -- : number of entries in table MrktFi having no key entry in DiscFi' as error_description
from 

 `commercial_sample_persist`.`check_landing_no_discard`

group by 
 year 
;


insert into 
 `commercial_sample_persist`.`check_action_summary` 
select 
 es.error_code, 
 lnd.landing_year as year, 
 lnd.landing_vessel as vessel,
 lnd.landing_trip as trip,
 concat('_',lnd.landing_station,'_',lnd.landing_date,'_',lnd.landing_species) as key_string,
 lnd.corr_action  
from 
 `commercial_sample_persist`.`check_landing_no_discard` lnd, 
 `commercial_sample_persist`.`check_error_summary` es 
where 
 lnd.landing_year = es.year
and 
 es.error_code = 'landing_no_discard' 
;





set @_ = concat("__________________________________________________________________________________");
select @_;
set @_ = concat(" try at ", now(), " check_commercial_sample_original.check_discard_no_landing ");
select @_;

drop table if exists `commercial_sample_persist`.`check_discard_no_landing`;

create table 
 `commercial_sample_persist`.`check_discard_no_landing`
select 
 *
from 
(
select 
 d.JAHR as discard_year, 

 d.EU_NR as discard_vessel,
 l.EU_NR as landing_vessel,

 d.REISENR as discard_trip,
 l.REISENR as landing_trip,

 d.STATION as discard_station,
 l.STATION as landing_station,

 d.STATDATUM as discard_date,
 l.STATDATUM as landing_date,

 d.FISH as discard_species, 
 l.FISH as landing_species, 

 d.GESAMTKG as discard_catch,
 l.GESAMTKG as landing_catch, 

 d.UPKG as discard_sample_mass,
 l.UPKG as landing_sample_mass,

 d.UPSTCK as discard_sample_number,
 l.UPSTCK as landing_sample_number,

 'check for mismatch (also EU_NR !) in base commercial_sample_original in table DiscFi (corr or del line) and MrktFi (corr or add line)' as corr_action 

from 

 `commercial_sample_original`.`DiscFi` d 

left join 

 `commercial_sample_original`.`MrktFi` l

on 
 l.JAHR = d.JAHR 
and 
 l.EU_NR = d.EU_NR 
and
 l.REISENR = d.REISENR 
and
 l.STATION = d.STATION 
and
 l.FISH = d.FISH

) xx

where 

 xx.landing_species is null 

;


insert into 
 `commercial_sample_persist`.`check_error_summary`
select 
 discard_year as year, 
 'discard_no_landing' as error_code, 
 count(*) as error_count, 
 '-- fatal -- : number of entries in table DiscFi having no key entry in MrktFi' as error_description
from 

 `commercial_sample_persist`.`check_discard_no_landing`

group by 
 year 
;


insert into 
 `commercial_sample_persist`.`check_action_summary` 
select 
 es.error_code, 
 dnl.discard_year as year, 
 dnl.discard_vessel as vessel,
 dnl.discard_trip as trip,
 concat('_',dnl.discard_station,'_',dnl.discard_date,'_',dnl.discard_species) as key_string,
 dnl.corr_action  
from 
 `commercial_sample_persist`.`check_discard_no_landing` dnl, 
 `commercial_sample_persist`.`check_error_summary` es 
where 
 dnl.discard_year = es.year
and 
 es.error_code = 'discard_no_landing' 
;





set @_ = concat("__________________________________________________________________________________");
select @_;
set @_ = concat(" try at ", now(), " check_commercial_sample_original.check_catch_no_length ");
select @_;

drop table if exists `commercial_sample_persist`.`check_catch_no_length`;

create table 
 `commercial_sample_persist`.`check_catch_no_length`
select 
 *
from 
(
select 
 f.JAHR as catch_year, 

 f.EU_NR as catch_vessel,
 cl.EU_NR as length_vessel,

 f.REISENR as catch_trip,
 cl.REISENR as length_trip,

 f.STATION as catch_station,
 cl.STATION as length_station,

 f.STATDATUM as catch_date,
 cl.STATDATUM as length_date,

 f.FISH as catch_species,
 cl.FISH as length_species, 

 sum(cl.LANZAHL) as number_measured, 

 'check for mismatch (also EU_NR !) in base commercial_sample_original in table FishFi (corr or del line) and LengFi (corr or add line)' as corr_action 

from 

 `commercial_sample_original`.`FishFi` f

left join 

 `commercial_sample_original`.`LengFi` cl

on 
 cl.JAHR = f.JAHR 
and 
 cl.EU_NR = f.EU_NR 
and
 cl.REISENR = f.REISENR 
and
 cl.STATION = f.STATION 
and
 cl.FISH = f.FISH

group by 

 catch_year, 
 length_vessel,
 length_trip,
 length_station,
 length_species 

) xx

having 

 xx.number_measured is null 

;


insert into 
 `commercial_sample_persist`.`check_error_summary`
select 
 catch_year as year, 
 'catch_no_length' as error_code, 
 count(*) as error_count, 
 '-- check -- : number of entries in table FishFi having no key entry in LengFi' as error_description
from 

 `commercial_sample_persist`.`check_catch_no_length`

group by 
 year 
;


insert into 
 `commercial_sample_persist`.`check_action_summary` 
select 
 es.error_code, 
 cnl.catch_year as year, 
 cnl.catch_vessel as vessel,
 cnl.catch_trip as trip,
 concat('_',cnl.catch_station,'_',cnl.catch_date,'_',cnl.catch_species) as key_string,
 cnl.corr_action  
from 
 `commercial_sample_persist`.`check_catch_no_length` cnl, 
 `commercial_sample_persist`.`check_error_summary` es 
where 
 cnl.catch_year = es.year
and 
 es.error_code = 'catch_no_length' 
;





set @_ = concat("__________________________________________________________________________________");
select @_;
set @_ = concat(" try at ", now(), " check_commercial_sample_original.check_landing_no_length ");
select @_;

drop table if exists `commercial_sample_persist`.`check_landing_no_length`;

create table 
 `commercial_sample_persist`.`check_landing_no_length`
select 
 *
from 
(
select 
 l.JAHR as landing_year, 

 l.EU_NR as landing_vessel,
 ll.EU_NR as length_vessel,

 l.REISENR as landing_trip,
 ll.REISENR as length_trip,

 l.STATION as landing_station,
 ll.STATION as length_station,

 l.STATDATUM as landing_date,
 ll.STATDATUM as length_date,

 l.FISH as landing_species,
 ll.FISH as length_species, 

 sum(ll.LANZAHL) as number_measured, 

 'check for mismatch (also EU_NR !) in base commercial_sample_original in table MrktFi (corr or del line) and MLenFi (corr or add line)' as corr_action 

from 

 `commercial_sample_original`.`MrktFi` l

left join 

 `commercial_sample_original`.`MLenFi` ll

on 
 ll.JAHR = l.JAHR 
and 
 ll.EU_NR = l.EU_NR 
and
 ll.REISENR = l.REISENR 
and
 ll.STATION = l.STATION 
and
 ll.FISH = l.FISH

where 

 l.UPKG > 0 


group by 

 landing_year, 
 length_vessel,
 length_trip,
 length_station,
 length_species 

) xx

having 

 xx.number_measured is null or xx.number_measured = 0 

;


insert into 
 `commercial_sample_persist`.`check_error_summary`
select 
 landing_year as year, 
 'landing_no_length' as error_code, 
 count(*) as error_count, 
 '-- check -- : number of entries in table MrktFi having no key entry in MLenFi' as error_description
from 

 `commercial_sample_persist`.`check_landing_no_length`

group by 
 year 
;


insert into 
 `commercial_sample_persist`.`check_action_summary` 
select 
 es.error_code, 
 lnl.landing_year as year, 
 lnl.landing_vessel as vessel,
 lnl.landing_trip as trip,
 concat('_',lnl.landing_station,'_',lnl.landing_date,'_',lnl.landing_species) as key_string,
 lnl.corr_action  
from 
 `commercial_sample_persist`.`check_landing_no_length` lnl, 
 `commercial_sample_persist`.`check_error_summary` es 
where 
 lnl.landing_year = es.year
and 
 es.error_code = 'landing_no_length' 
;






set @_ = concat("__________________________________________________________________________________");
select @_;
set @_ = concat(" try at ", now(), " check_commercial_sample_original.check_discard_no_length ");
select @_;

drop table if exists `commercial_sample_persist`.`check_discard_no_length`;

create table 
 `commercial_sample_persist`.`check_discard_no_length`
select 
 *
from 
(
select 
 d.JAHR as discard_year, 

 d.EU_NR as discard_vessel,
 dl.EU_NR as length_vessel,

 d.REISENR as discard_trip,
 dl.REISENR as length_trip,

 d.STATION as discard_station,
 dl.STATION as length_station,

 d.STATDATUM as discard_date,
 dl.STATDATUM as length_date,

 d.FISH as discard_species,
 dl.FISH as length_species, 

 sum(dl.LANZAHL) as number_measured, 

 'check for mismatch (also EU_NR !) in base commercial_sample_original in table DiscFi (corr or del line) and DLenFi (corr or add line)' as corr_action 

from 

 `commercial_sample_original`.`DiscFi` d

left join 

 `commercial_sample_original`.`DLenFi` dl

on 
 dl.JAHR = d.JAHR 
and 
 dl.EU_NR = d.EU_NR 
and
 dl.REISENR = d.REISENR 
and
 dl.STATION = d.STATION 
and
 dl.FISH = d.FISH 

where 

 d.UPKG > 0 


group by 

 discard_year, 
 length_vessel,
 length_trip,
 length_station,
 length_species 

) xx

having 

 xx.number_measured is null or xx.number_measured = 0

;


insert into 
 `commercial_sample_persist`.`check_error_summary`
select 
 discard_year as year, 
 'discard_no_length' as error_code, 
 count(*) as error_count, 
 '-- check -- : number of entries in table DiscFi having no key entry in DLenFi' as error_description
from 

 `commercial_sample_persist`.`check_discard_no_length`

group by 
 year 
;



insert into 
 `commercial_sample_persist`.`check_action_summary` 
select 
 es.error_code, 
 dnl.discard_year as year, 
 dnl.discard_vessel as vessel,
 dnl.discard_trip as trip,
 concat('_',dnl.discard_station,'_',dnl.discard_date,'_',dnl.discard_species) as key_string,
 dnl.corr_action  
from 
 `commercial_sample_persist`.`check_discard_no_length` dnl, 
 `commercial_sample_persist`.`check_error_summary` es 
where 
 dnl.discard_year = es.year
and 
 es.error_code = 'discard_no_length' 
;






set @_ = concat("__________________________________________________________________________________");
select @_;
set @_ = concat(" try at ", now(), " check_commercial_sample_original.check_length_no_catch ");
select @_;

drop table if exists `commercial_sample_persist`.`check_length_no_catch`;

create table 
 `commercial_sample_persist`.`check_length_no_catch`
select 
 *
from 
(
select 
 cl.JAHR as length_year, 

 cl.EU_NR as length_vessel,
 f.EU_NR as catch_vessel,

 cl.REISENR as length_trip,
 f.REISENR as catch_trip,

 cl.STATION as length_station,
 f.STATION as catch_station,

 cl.STATDATUM as length_date,
 f.STATDATUM as catch_date,

 cl.FISH as length_species,
 f.FISH as catch_species, 

 sum(cl.LANZAHL) as number_measured, 

 'check for mismatch (also EU_NR !) in base commercial_sample_original in table LengFi (corr or del line) and FishFi (corr or add line)' as corr_action 

from 

 `commercial_sample_original`.`LengFi` cl

left join 

 `commercial_sample_original`.`FishFi` f

on 
 f.JAHR = cl.JAHR 
and 
 f.EU_NR = cl.EU_NR 
and
 f.REISENR = cl.REISENR 
and
 f.STATION = cl.STATION 
and
 f.FISH = cl.FISH

group by 

 length_year, 
 length_vessel,
 length_trip,
 length_station,
 length_species 

) xx

having 

 xx.number_measured > 0 and xx.catch_species is null  

;



insert into 
 `commercial_sample_persist`.`check_error_summary`
select 
 length_year as year, 
 'length_no_catch' as error_code, 
 count(*) as error_count, 
 '-- fatal -- : number of entries in table LengFi having no key entry in FishFi' as error_description
from 

 `commercial_sample_persist`.`check_length_no_catch`

group by 
 year 
;


insert into 
 `commercial_sample_persist`.`check_action_summary` 
select 
 es.error_code, 
 lnc.length_year as year, 
 lnc.length_vessel as vessel,
 lnc.length_trip as trip,
 concat('_',lnc.length_station,'_',lnc.length_date,'_',lnc.length_species) as key_string,
 lnc.corr_action  
from 
 `commercial_sample_persist`.`check_length_no_catch` lnc, 
 `commercial_sample_persist`.`check_error_summary` es 
where 
 lnc.length_year = es.year
and 
 es.error_code = 'length_no_catch' 
;





set @_ = concat("__________________________________________________________________________________");
select @_;
set @_ = concat(" try at ", now(), " check_commercial_sample_original.check_length_no_landing ");
select @_;

drop table if exists `commercial_sample_persist`.`check_length_no_landing`;

create table 
 `commercial_sample_persist`.`check_length_no_landing`
select 
 *
from 
(
select 
 ll.JAHR as length_year, 

 ll.EU_NR as length_vessel,
 l.EU_NR as landing_vessel,

 ll.REISENR as length_trip,
 l.REISENR as landing_trip,

 ll.STATION as length_station,
 l.STATION as landing_station,

 ll.STATDATUM as length_date,
 l.STATDATUM as landing_date,

 ll.FISH as length_species, 
 l.FISH as landing_species,

 sum(ll.LANZAHL) as number_measured, 

 'check for mismatch (also EU_NR !) in base commercial_sample_original in table MLenFi (corr or del line) and MrktFi (corr or add line)' as corr_action 

from 

 `commercial_sample_original`.`MLenFi` ll

left join 

 `commercial_sample_original`.`MrktFi` l

on 
 l.JAHR = ll.JAHR 
and 
 l.EU_NR = ll.EU_NR 
and
 l.REISENR = ll.REISENR 
and
 l.STATION = ll.STATION 
and
 l.FISH = ll.FISH

group by 

 length_year, 
 length_vessel,
 length_trip,
 length_station,
 length_species 

) xx

having 

 xx.number_measured > 0 and xx.landing_species is null  

;


insert into 
 `commercial_sample_persist`.`check_error_summary`
select 
 length_year as year, 
 'length_no_landing' as error_code, 
 count(*) as error_count, 
 '-- fatal -- : number of entries in table MLenFi having no key entry in MrktFi' as error_description
from 

 `commercial_sample_persist`.`check_length_no_landing`

group by 
 year 
;


insert into 
 `commercial_sample_persist`.`check_action_summary` 
select 
 es.error_code, 
 lnl.length_year as year, 
 lnl.length_vessel as vessel,
 lnl.length_trip as trip,
 concat('_',lnl.length_station,'_',lnl.length_date,'_',lnl.length_species) as key_string,
 lnl.corr_action  
from 
 `commercial_sample_persist`.`check_length_no_landing` lnl, 
 `commercial_sample_persist`.`check_error_summary` es 
where 
 lnl.length_year = es.year
and 
 es.error_code = 'length_no_landing' 
;




set @_ = concat("__________________________________________________________________________________");
select @_;
set @_ = concat(" try at ", now(), " check_commercial_sample_original.check_length_no_discard ");
select @_;

drop table if exists `commercial_sample_persist`.`check_length_no_discard`;

create table 
 `commercial_sample_persist`.`check_length_no_discard`
select 
 *
from 
(
select 
 dl.JAHR as length_year, 

 dl.EU_NR as length_vessel,
 d.EU_NR as discard_vessel,

 dl.REISENR as length_trip,
 d.REISENR as discard_trip,

 dl.STATION as length_station,
 d.STATION as discard_station,

 dl.STATDATUM as length_date,
 d.STATDATUM as discard_date,

 dl.FISH as length_species, 
 d.FISH as discard_species,

 sum(dl.LANZAHL) as number_measured, 

 'check for mismatch (also EU_NR !) in base commercial_sample_original in table DLenFi (corr or del line) and DiscFi (corr or add line)' as corr_action 

from 

 `commercial_sample_original`.`DLenFi` dl

left join 

 `commercial_sample_original`.`DiscFi` d 

on 
 d.JAHR = dl.JAHR 
and 
 d.EU_NR = dl.EU_NR 
and
 d.REISENR = dl.REISENR 
and
 d.STATION = dl.STATION 
and
 d.FISH = dl.FISH

group by 

 length_year, 
 length_vessel,
 length_trip,
 length_station,
 length_species 

) xx

having 

 xx.number_measured > 0 and discard_species is null 
;


insert into 
 `commercial_sample_persist`.`check_error_summary`
select 
 length_year as year, 
 'length_no_discard' as error_code, 
 count(*) as error_count, 
 '-- fatal -- : number of entries in table DLenFi having no key entry in DiscFi' as error_description
from 

 `commercial_sample_persist`.`check_length_no_discard`

group by 
 year 
;



insert into 
 `commercial_sample_persist`.`check_action_summary` 
select 
 es.error_code, 
 lnd.length_year as year, 
 lnd.length_vessel as vessel,
 lnd.length_trip as trip,
 concat('_',lnd.length_station,'_',lnd.length_date,'_',lnd.length_species) as key_string,
 lnd.corr_action  
from 
 `commercial_sample_persist`.`check_length_no_discard` lnd, 
 `commercial_sample_persist`.`check_error_summary` es 
where 
 lnd.length_year = es.year 
and 
 es.error_code = 'length_no_discard' 
;





set @_ = concat("__________________________________________________________________________________");
select @_;
set @_ = concat(" try at ", now(), " check_commercial_sample_original.check_individual_no_haul ");
select @_;

drop table if exists `commercial_sample_persist`.`check_individual_no_haul`;

create table 
 `commercial_sample_persist`.`check_individual_no_haul`
select 
 *
from 
(
select 
 si.JAHR as individual_year, 

 si.EU_NR as individual_vessel,
 n.EU_NR as haul_vessel,

 si.REISENR as individual_trip,
 n.REISENR as haul_trip,

 si.STATION as individual_station,
 n.STATION as haul_station,

 si.STATDATUM as individual_date,
 n.STATDATUM as haul_date,

 si.FISH as individual_species, 

 count(*) as number_aged,  

 'check for mismatch (also EU_NR !) in base commercial_sample_original in table SnglIOR (corr or del line) and NetzFi (corr or add line)' as corr_action 

from 

 `commercial_sample_original`.`SnglIOR` si

left join 

 `commercial_sample_original`.`NetzFi` n

on 

 n.JAHR = si.JAHR 
and 
 n.EU_NR = si.EU_NR 
and
 n.REISENR = si.REISENR 
and
 n.STATION = si.STATION 

group by 

 individual_year, 
 individual_vessel,
 individual_trip,
 individual_station,
 individual_date,
 individual_species 

) xx

where 

 xx.haul_station is null 

;


insert into 
 `commercial_sample_persist`.`check_error_summary`
select 
 individual_year as year, 
 'individual_no_haul' as error_code, 
 count(*) as error_count, 
 '-- fatal -- : number of entries in table SnglIOR having no key entry in NetzFi' as error_description
from 

 `commercial_sample_persist`.`check_individual_no_haul`

group by 
 year 
;


insert into 
 `commercial_sample_persist`.`check_action_summary` 
select 
 es.error_code, 
 inh.individual_year as year, 
 inh.individual_vessel as vessel,
 inh.individual_trip as trip,
 concat('_',inh.individual_station,'_',inh.individual_date) as key_string,
 inh.corr_action  
from 
 `commercial_sample_persist`.`check_individual_no_haul` inh, 
 `commercial_sample_persist`.`check_error_summary` es 
where 
 inh.individual_year = es.year
and 
 es.error_code = 'individual_no_haul' 
;





set @_ = concat("__________________________________________________________________________________");
select @_;
set @_ = concat(" try at ", now(), " check_commercial_sample_original.check_haul_no_individual ");
select @_;

drop table if exists `commercial_sample_persist`.`check_haul_no_individual`;

create table 
 `commercial_sample_persist`.`check_haul_no_individual`
select 
 *
from 
(
select 
 n.JAHR as haul_year, 

 n.EU_NR as haul_vessel,
 si.EU_NR as individual_vessel,

 n.REISENR as haul_trip,
 si.REISENR as individual_trip,

 n.STATION as haul_station,
 si.STATION as individual_station,

 n.STATDATUM as haul_date,
 si.STATDATUM as individual_date,

 'check for mismatch (also EU_NR !) in base commercial_sample_original in table NetzFi (corr or del line) and SnglIOR (corr or add line)' as corr_action 

from 

 `commercial_sample_original`.`NetzFi` n

left join 

 `commercial_sample_original`.`SnglIOR` si

on 
 si.JAHR = n.JAHR 
and 
 si.EU_NR = n.EU_NR 
and
 si.REISENR = n.REISENR 
and
 si.STATION = n.STATION 

) xx

where 

 xx.individual_station is null

and 

-- # this is to exclude senseless error messages for sea sampled hauls

 mid(xx.haul_trip, 2, 1) in (3) 
;


set @_ = concat(" laboratory sample observer code = >>3<< ");
select @_;




insert into 
 `commercial_sample_persist`.`check_error_summary`
select 
 haul_year as year, 
 'haul_no_individual' as error_code, 
 count(*) as error_count, 
 '-- check -- : number of entries in table NetzFi having no key entry in SnglIOR' as error_description
from 

 `commercial_sample_persist`.`check_haul_no_individual`

group by 
 year 
;


insert into 
 `commercial_sample_persist`.`check_action_summary` 
select 
 es.error_code, 
 hni.haul_year as year, 
 hni.haul_vessel as vessel,
 hni.haul_trip as trip,
 concat('_',hni.haul_station,'_',hni.haul_date) as key_string,
 hni.corr_action  
from 
 `commercial_sample_persist`.`check_haul_no_individual` hni, 
 `commercial_sample_persist`.`check_error_summary` es 
where 
 hni.haul_year = es.year
and 
 es.error_code = 'haul_no_individual' 
;



alter table `commercial_sample_persist`.`check_error_summary` order by error_description, year;

alter table `commercial_sample_persist`.`check_action_summary` order by year, trip, error_code, key_string;

