-- 

CREATE SCHEMA com_fishery_original;
CREATE SCHEMA com_fishery_heap;

SET search_path TO com_fishery_original,public;	

-- Import der BLE Daten in fishery_original und _heap

DROP TABLE IF EXISTS com_fishery_original.anlandung;
CREATE TABLE com_fishery_original.anlandung
(
    jahr bigint,
    eunr character varying(12),
    reisenr bigint,
    landnr bigint,
    landdat character varying(13),
    landort character varying(5),
    hauptgebiet bigint,
    untergebiet character varying(4),
    hauptbereich character varying(4),
    unterbereich character varying(2),
    teilbereich character varying(2),
    zone character varying(20),
    rechteck character varying(20),
    fischart character varying(20),
    fangkg bigint,
    landkg bigint,
    aufmachung character varying(3),
    zustand character varying(3),
    erloes double precision,
    groesse_id bigint,
    verwendung character varying(3)
);

COPY com_fishery_original.anlandung(EUNR,REISENR,LANDNR,LANDDAT,LANDORT,HAUPTGEBIET,UNTERGEBIET,HAUPTBEREICH,UNTERBEREICH,TEILBEREICH,ZONE,
               RECHTECK,FISCHART,FANGKG,LANDKG,AUFMACHUNG,ZUSTAND,ERLOES,GROESSE_ID,VERWENDUNG)
FROM '/srv/import_csv/ANLANDUNG_2016.csv' DELIMITER ';' CSV HEADER;

UPDATE anlandung SET JAHR = 2016;

SELECT * FROM anlandung;

CREATE TABLE com_fishery_heap.anlandung AS
SELECT * FROM anlandung;


DROP TABLE IF EXISTS reise;
CREATE TABLE reise
(
    jahr bigint,
    eunr character varying(12) ,
    reisenr bigint,
    fahrdat character varying(13),
    rueckdat character varying(13),
    fahrort character varying(5),
    rueckort character varying(5)
)

TRUNCATE com_fishery_original.reise;
COPY com_fishery_original.reise(EUNR,REISENR,FAHRDAT,RUECKDAT,FAHRORT,RUECKORT)
FROM '/srv/import_csv/REISE_2016.csv' DELIMITER ';' CSV HEADER;

UPDATE reise SET JAHR = 2016;

SELECT * FROM reise;

DROP TABLE IF EXISTS com_fishery_heap.reise;
CREATE TABLE com_fishery_heap.reise AS
SELECT * FROM reise;


DROP TABLE IF EXISTS fifaaktiv;
CREATE TABLE fifaaktiv
(
    jahr bigint,
    eunr character varying(12),
    fkz character varying(20),
    rufzeichen character varying(20),
    schiffname character varying(50),
    hafen bigint,
    erzorg character varying(20),
    luea bigint,
    brz bigint,
    kw bigint,
    mapsegment character varying(20),
    fg1 character varying(20),
    typ character varying(20),
    rumpf bigint,
    besatzung bigint,
    baujahr bigint,
    eigner_id bigint,
    reeder_id bigint,
    vorgangsdatum character varying(13),
    gueltig_bis DATE
);

COPY com_fishery_original.fifaaktiv(EUNR,FKZ,RUFZEICHEN,SCHIFFNAME,HAFEN,ERZORG,LUEA,BRZ,KW,MAPSEGMENT,FG1,TYP,RUMPF,BESATZUNG,BAUJAHR,EIGNER_ID,REEDER_ID,VORGANGSDATUM)
FROM '/srv/import_csv/FIFAAKTIV_2016.csv' DELIMITER ';' CSV HEADER ENCODING 'LATIN1';

UPDATE fifaaktiv SET JAHR = 2016, gueltig_bis = NOW();

SELECT * FROM fifaaktiv;

CREATE TABLE com_fishery_heap.fifaaktiv AS
SELECT * FROM fifaaktiv;

DROP TABLE IF EXISTS logbuch;
CREATE TABLE logbuch
(
    jahr bigint,
    eunr character varying(12),
    reisenr bigint,
    fangnr bigint,
    hauptgebiet bigint,
    untergebiet bigint,
    hauptbereich character varying(4),
    unterbereich character varying(2),
    teilbereich character varying(2),
    zone character varying(12),
    rechteck character varying(12),
    fangdatv character varying(13),
    fangdatb character varying(13),
    fangzeit double precision,
    glaenge character varying(8),
    gbreite character varying(8),
    geraet character(3),
    hols bigint,
    masche bigint,
    haken bigint,
    gegros bigint,
    fischart character(3),
    fangkglog bigint,
    schaetzkg bigint
)

COPY com_fishery_original.logbuch(EUNR,REISENR,FANGNR,HAUPTGEBIET,UNTERGEBIET,HAUPTBEREICH,UNTERBEREICH,TEILBEREICH,ZONE,RECHTECK,FANGDATV,FANGDATB,
                                  FANGZEIT,GLAENGE,GBREITE,GERAET,HOLS,MASCHE,HAKEN,GEGROS,FISCHART,FANGKGLOG,SCHAETZKG)
FROM '/srv/import_csv/LOGBUCH_2016.csv' DELIMITER ';' CSV HEADER ENCODING 'LATIN1';

UPDATE logbuch SET JAHR = 2016;

SELECT * FROM logbuch;

CREATE TABLE com_fishery_heap.logbuch AS
SELECT * FROM logbuch;


DROP TABLE IF EXISTS anlandung_bms;
CREATE TABLE anlandung_bms
(
  jahr bigint,
  XFR VARCHAR(10),
  CFR VARCHAR(12),
  Ausfahrdatum VARCHAR(16),
  Rueckkehrdatum VARCHAR(16),
  Beifangdatum VARCHAR(16),
  Laenge VARCHAR(8),
  Breite VARCHAR(8),
  Hauptgebiet bigint,
  Untergebiet bigint,
  Hauptbereich VARCHAR(2),
  Unterbereich VARCHAR(5),
  Unit VARCHAR(5),
  Zone VARCHAR(3),
  Rechteck VARCHAR(4),
  Fischart VARCHAR(3),
  Gewicht real,
  Anzahl bigint,
  Fanggeraet VARCHAR(3),
  Maschenweite bigint
);

COPY com_fishery_original.anlandung_bms(XFR,CFR,Ausfahrdatum,Rueckkehrdatum,Beifangdatum,Laenge,Breite,Hauptgebiet,Untergebiet,Hauptbereich,Unterbereich,Unit,Zone
                                        ,Rechteck,Fischart,Gewicht,Anzahl,Fanggeraet,Maschenweite)
FROM '/srv/import_csv/ANLANDUNG_BMS.csv' DELIMITER ';' CSV HEADER ENCODING 'LATIN1';

UPDATE anlandung_bms SET jahr = 2016;

CREATE TABLE com_fishery_heap.anlandung_bms AS
SELECT * FROM anlandung_bms;

DROP TABLE IF EXISTS discard;
CREATE TABLE discard (
  jahr bigint,
  EUNR VARCHAR(12),
  REISENR bigint,
  HAUPTGEBIET VARCHAR(3),
  UNTERGEBIET VARCHAR(4),
  HAUPTBEREICH VARCHAR(4),
  UNTERBEREICH VARCHAR(4),
  TEILBEREICH character varying(2),
  ZONE VARCHAR(3),
  RECHTECK VARCHAR(4),
  GLAENGE VARCHAR(8),
  GBREITE VARCHAR(8),
  DISCARD_DATUM_STRING VARCHAR(16),
  FISCHART VARCHAR(3),
  DISCARDKG real,
  ANZAHL bigint
);

COPY com_fishery_original.discard(EUNR,REISENR,HAUPTGEBIET,UNTERGEBIET,HAUPTBEREICH,UNTERBEREICH,TEILBEREICH,ZONE,RECHTECK,GLAENGE,GBREITE,
                                  DISCARD_DATUM_STRING,FISCHART,DISCARDKG,ANZAHL)
FROM '/srv/import_csv/DISCARD_2016.csv' DELIMITER ';' CSV HEADER ENCODING 'LATIN1';

UPDATE discard SET jahr = 2016;

CREATE TABLE com_fishery_heap.discard AS
SELECT * FROM discard;

--  Einschränkung der Daten in _original auf die Ostseegebiete

-- Test
-- SELECT DISTINCT untergebiet,hauptbereich,unterbereich,teilbereich FROM logbuch WHERE untergebiet = '3';

DELETE FROM anlandung WHERE hauptgebiet <> '27' or untergebiet <> '3';
DELETE FROM logbuch WHERE hauptgebiet <> '27' or untergebiet <> '3';
DELETE FROM anlandung_bms WHERE hauptgebiet <> '27' or untergebiet <> '3';
DELETE FROM discard WHERE hauptgebiet <> '27' or untergebiet <> '3';

-- Vollständigkeitsprüfung

-- EUNR und REISENR as reise in logbuch und anlandung vorhanden

SELECT *,
       CASE WHEN reise = 'FEHLT' AND (logbuch = 'OK' OR anlandung = 'OK') THEN 'Reise fehlt zu Anlandung/Logbucheintrag'
            WHEN logbuch = 'OK' and anlandung = 'FEHLT' THEN 'Anlandung fehlt zu Logbuch'
	    WHEN anlandung = 'OK' and luea >= 800 and logbuch = 'FEHLT' THEN 'Logbucheintrag fehlt bei Schiff >= 8m'
	    ELSE 'OK' END as fehler
FROM
(
	SELECT rnr.*,
	       v.luea,
	       CASE WHEN r.reisenr IS NULL THEN 'FEHLT' ELSE 'OK' END as reise,
	       CASE WHEN lb.reisenr IS NULL THEN 'FEHLT' ELSE 'OK' END as logbuch,
	       CASE WHEN a.reisenr IS NULL THEN 'FEHLT' ELSE 'OK' END as anlandung
	FROM
	(
		SELECT DISTINCT *
		FROM
		(
			SELECT reisenr,eunr FROM reise
			union
			SELECT reisenr,eunr FROM logbuch
			union
			SELECT reisenr,eunr FROM anlandung
		) rnr
	) rnr
	LEFT JOIN (SELECT DISTINCT reisenr,eunr FROM reise) r ON rnr.reisenr = r.reisenr and rnr.eunr = r.eunr
	LEFT JOIN (SELECT DISTINCT reisenr,eunr FROM logbuch) lb ON rnr.reisenr = lb.reisenr and rnr.eunr = lb.eunr
	LEFT JOIN (SELECT DISTINCT reisenr,eunr FROM anlandung) a ON rnr.reisenr = a.reisenr and rnr.eunr = a.eunr
	LEFT JOIN fifaaktiv v ON rnr.eunr = v.eunr
) rnr
WHERE CASE WHEN reise = 'FEHLT' AND (logbuch = 'OK' OR anlandung = 'OK') THEN 'Reise fehlt zu Anlandung/Logbucheintrag'
            WHEN logbuch = 'OK' and anlandung = 'FEHLT' THEN 'Anlandung fehlt zu Logbuch'
	    WHEN anlandung = 'OK' and luea >= 800 and logbuch = 'FEHLT' THEN 'Logbucheintrag fehlt bei Schiff >= 8m'
	    ELSE 'OK' END <> 'OK';

-- Anlandung : landort mit rueckort in reise identisch?

SELECT a.eunr,a.reisenr,a.landnr,a.landdat,a.landort,r.*
FROM anlandung a
LEFT JOIN reise r ON a.reisenr = r.reisenr AND a.eunr = r.eunr
WHERE a.landort <> r.rueckort;

-- Anlandung : fischart identisch mit logbuch
(
	SELECT *,'FEHLT in anlandung' as fehler
	FROM
	(SELECT DISTINCT eunr,reisenr,fischart FROM logbuch) lb
	LEFT JOIN
	(SELECT DISTINCT eunr,reisenr,fischart FROM anlandung) a
	ON lb.eunr = a.eunr AND lb.reisenr = a.reisenr AND  lb.fischart = a.fischart
	WHERE a.reisenr IS NULL
)
UNION
(
	SELECT *,'FEHLT in logbuch' as fehler
	FROM
	(SELECT DISTINCT a.eunr,a.reisenr,a.fischart FROM anlandung a
	 LEFT JOIN fifaaktiv v ON a.eunr = v.eunr
	 WHERE v.luea >= 800
	) a
	LEFT JOIN
	(SELECT DISTINCT eunr,reisenr,fischart FROM logbuch) lb
	ON lb.eunr = a.eunr AND lb.reisenr = a.reisenr AND  lb.fischart = a.fischart
	WHERE lb.reisenr IS NULL
);

-- Inhaltsprüfung

-- Reise : FAHRDAT vor RUECKDAT

SELECT jahr,
       reisenr,
       eunr,
       to_timestamp(fahrdat, 'YYYYMMDD HH24MI'),
       to_timestamp(rueckdat, 'YYYYMMDD HH24MI'),
       CASE WHEN to_timestamp(fahrdat, 'YYYYMMDD HH24MI') > to_timestamp(rueckdat, 'YYYYMMDD HH24MI') THEN 'RUECKDAT liegt vor FAHRDAT'
       	    ELSE 'OK' END as fehler
FROM reise
WHERE CASE WHEN to_timestamp(fahrdat, 'YYYYMMDD HH24MI') > to_timestamp(rueckdat, 'YYYYMMDD HH24MI') THEN 'RUECKDAT liegt vor FAHRDAT'
       	    ELSE 'OK' END <> 'OK';

-- Reise : FAHRORT / RUECKORT gültig

SELECT r.jahr,
       r.reisenr,
       r.eunr,
       r.fahrort,
       fo.fao_code,
       r.rueckort,
       ro.fao_code,
       CASE WHEN fo.fao_code IS NULL OR ro.fao_code IS NULL THEN 'FAHRORT oder RUECKORT fehlt'
       ELSE 'OK' END as fehler
FROM reise r
LEFT JOIN com_parameter.convert_harbour_code fo ON r.fahrort = fo.fao_code
LEFT JOIN com_parameter.convert_harbour_code ro ON r.rueckort = ro.fao_code
WHERE CASE WHEN fo.fao_code IS NULL OR ro.fao_code IS NULL THEN 'FAHRORT oder RUECKORT fehlt'
       ELSE 'OK' END <> 'OK';

-- LOGBUCH FANGDATV FANGDATB FANGZEIT korrekt

-- FANGDATB - FANGDATV ergibt einen Zeitinterval
-- extract(epoch FROM FANGDATB - FANGDATV)/3600 ergibt Zeitabstand in Dezimalstunden
-- floor(Dezimalstunden) = volle Stunden
-- Dezimalstunden - floor(Dezimalstunden) = Restminuten in Stunden
-- Restminuten / 100 = x/60 ; x = (Restminuten * 60) / 1; Restminuten in Minuten
-- komplette Formel substituiert:
-- floor(Dezimalstunden) * 100 + ((Dezimalstunden - floor(Dezimalstunden)) * 60) / 1
with logbuch as (
SELECT jahr,
       eunr,
       reisenr,
       fangnr,
       to_timestamp(fangdatb, 'YYYYMMDD HH24MI') as fangdatv,
       to_timestamp(fangdatv, 'YYYYMMDD HH24MI') as fangdatb,
       fangzeit,
       extract(epoch from to_timestamp(fangdatb, 'YYYYMMDD HH24MI') - to_timestamp(fangdatv, 'YYYYMMDD HH24MI'))/3600 as dec_h
       
FROM logbuch
)
SELECT reisenr,fangnr,fangdatv,fangdatb,fangzeit,
       floor(dec_h) * 100 + (((dec_h - floor(dec_h)) * 60) / 1) as fzeit
FROM logbuch
WHERE fangzeit <> floor(dec_h) * 100 +((dec_h - floor(dec_h)) * 60) / 1;

