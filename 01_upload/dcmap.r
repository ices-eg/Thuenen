library("tidyverse")
require("RPostgreSQL")

# Prüfung kommerzielle Daten BLE Daten (Logbuch)


# Datenbankverbindung
pw <- { "secret" }
drv <- dbDriver("PostgreSQL")
conn <- dbConnect(drv, dbname = "dcmap_entwicklung",
                  host = "db_server",
                  user = "user",
                  password = pw)
rm(pw)

# Suchpfad setzen auf fishery_original, public - weniger Tipparbeit
dbGetQuery(conn,"SET search_path TO com_fishery_original,public")

# Vollständigkeitsprüfung

# (REISENR,EUNR) in REISE,LOGBUCH und ANLANDUNG gleichermaßen vorhanden
# Beziehungen :
#
# in REISE sind alle Reisen vorhanden
# LOGBUCH hat alle Reisen mit Schiffen > 8m
# ANLANDUNG wiederrum alle Reisen  

tbl_reise <- dbGetQuery(conn,"SELECT * FROM reise")
tbl_logbuch <- dbGetQuery(conn,"SELECT * FROM logbuch")
tbl_anlandung <- dbGetQuery(conn,"SELECT * FROM anlandung")

tbl_reise_rnr <- distinct(tbl_reise,reisenr,eunr)
tbl_logbuch_rnr <- distinct(tbl_logbuch,reisenr,eunr)
tbl_anlandung_rnr <- distinct(tbl_anlandung,reisenr,eunr)

tbl_reise_rnr <- mutate(tbl_reise_rnr,reise = "OK")
tbl_logbuch_rnr <- mutate(tbl_logbuch_rnr,logbuch = "OK")
tbl_anlandung_rnr <- mutate(tbl_anlandung_rnr,anlandung = "OK")

all_rnr <-union_all(union_all(tbl_reise_rnr,tbl_logbuch_rnr),tbl_anlandung_rnr)
reise_logbuch <- tbl_reise_rnr %>% anti_join(tbl_logbuch_rnr)
reise_anlandung <- tbl_reise_rnr %>% anti_join(tbl_anlandung_rnr)

logbuch_reise <- tbl_logbuch_rnr %>% anti_join(tbl_reise_rnr)
logbuch_anlandung <- tbl_logbuch_rnr %>% anti_join(tbl_anlandung_rnr)

anlandung_reise <- tbl_anlandung_rnr %>% anti_join(tbl_reise_rnr)
anlandung_logbuch <- tbl_anlandung_rnr %>% anti_join(tbl_logbuch_rnr)
