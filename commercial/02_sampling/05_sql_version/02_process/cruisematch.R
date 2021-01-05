# Cruisematch -  Zusammenführung der beprobten Reisen (TI-OF) mit den inträgen aus der Fischereistatistik (Logbuch und Anlandung)
# benötigt für die anschließende Hochrechnung (von Unterproben auf die Reise und die Reise auf die Flotte)

library("tidyverse")
library("plyr")        # benötigt für "rename" von Tabellenspalten
library("dplyr")       # benögtigt für joins
require("RPostgreSQL")

# Datenbankverbindung
pw <- { "27btw3_OSF" }
drv <- dbDriver("PostgreSQL")
conn <- dbConnect(drv, dbname = "dcmap_entwicklung",
                  host = "dmar01-hro.ad.ti.bund.de",
                  user = "stoetera",
                  password = pw)
rm(pw)

# Suchpfad setzen auf fishery_final, public - weniger Tipparbeit
# dbGetQuery(conn,"SET search_path TO com_fishery_final,public")
dbGetQuery(conn,"SET search_path TO com_fishery_original,public") #Zwischenstand, erstmal von hier


# Auswahl der benötigten Tabellen aus _fishery und _sample
# Auswahl des aktuellen jahres

# (REISENR,EUNR) in REISE,LOGBUCH und ANLANDUNG gleichermaßen vorhanden

tbl_ble_reise <- dbGetQuery(conn,"SELECT * FROM reise")
tbl_logbuch <- dbGetQuery(conn,"SELECT * FROM logbuch")
tbl_anlandung <- dbGetQuery(conn,"SELECT * FROM anlandung")

tbl_fifa <- dbGetQuery(conn, "SELECT * FROM fifaaktiv")
tbl_register <- dbGetQuery(conn, "SELECT * FROM eu_register")

#########################################################################
# TI-OF Beprobungsdaten 
# dbGetQuery(conn,"SET search_path TO com_fishery_sample_final,public")
dbGetQuery(conn,"SET search_path TO com_fishery_sample_process,public")

tbl_reise <- dbGetQuery(conn,'SELECT * FROM "Reise"')
tbl_statfi <- dbGetQuery(conn,'SELECT * FROM "StatFi"')


cm <- dbGetQuery(conn, "SELECT
  
  b.\"JAHR\" as jahr, 
  b.\"SCHIFF\" as schiff, 
  b.\"EU_NR\" as eunr, 
  
  (case 
  when(
        (select a.\"Loa\" from com_fishery_original.\"eu_register\" a where a.\"CFR\" = b.\"EU_NR\" and a.\"Event End Date\">21000000) >8.00) 
  then ('big')
  else ('small')
  end) as vessel_class,
  b.\"REISENR\" as osf_reise, 
  to_date(to_char(b.\"REISE_VON\", '99999999'), 'YYYYMMDD') as osf_reise_von, 
  to_date(to_char(b.\"REISE_BIS\", '99999999'), 'YYYYMMDD') as osf_reise_bis,
  to_date(to_char(b.\"REISE_BIS\", '99999999'), 'YYYYMMDD') - to_date(to_char(b.\"REISE_VON\", '99999999'), 'YYYYMMDD') as osf_days_at_sea,
 (select c.\"reisenr\" 
		from com_fishery_original.\"reise\" c 
                 where b.\"EU_NR\" = c.\"eunr\" 
                 and 
                 to_date(to_char(b.\"REISE_VON\", '99999999'), 'YYYYMMDD') between to_date(left(c.\"fahrdat\", 8), 'YYYYMMDD') and to_date(left(c.\"rueckdat\", 8), 'YYYYMMDD')
                 and 
                 to_date(to_char(b.\"REISE_BIS\", '99999999'), 'YYYYMMDD') between to_date(left(c.\"fahrdat\", 8), 'YYYYMMDD') and to_date(left(c.\"rueckdat\", 8), 'YYYYMMDD')) as ble_reise
  FROM 
  com_fishery_sample_process.\"Reise\" b
  ")

#######

