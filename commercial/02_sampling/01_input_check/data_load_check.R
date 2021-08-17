library("tidyverse")
require("RPostgreSQL")

# load and check commercial sampling data 
# benötigte Bibliotheken 
library(sqldf)
library(dplyr)
# library(FSA)
# library(magrittr)
library(data.table)


# load data (here: from csv)
  setwd("C:/Dateien/Datenbank 2.0/data_postgres/")
  # source("C:/Dateien/Datenbank 2.0/Thuenen/commercial/02_sampling/01_input_check/funcs/simple_load.R")
  # print(simple.load())

   filenames <- list.files(path=getwd(), pattern=".*csv")
    names <- gsub('.{4}$', '', filenames)
     for(i in names){filepath <- file.path(getwd(),paste(i,".csv",sep=""))
     assign(i, read.delim(filepath, sep = ";"))}


# select the year
  year_range <- c(2018, 2019)

  sample_trip <- trip %>%
    filter((year %in% year_range))  
  
  left_join(haul_fo,sample_trip, by="tr_index")

# connect to database
pw <- { "" }
drv <- dbDriver("PostgreSQL")
conn <- dbConnect(drv, dbname = "dcmap_entwicklung",
                  host = "",
                  user = "",
                  password = pw)
rm(pw)

# set query path (public, less work in typing)
dbGetQuery(conn,"SET search_path TO com_sample_original,public")

# Vollständigkeitsprüfung

# (REISENR,EUNR) in REISE,LOGBUCH und ANLANDUNG gleichermaßen vorhanden
# Beziehungen :
#
# in REISE sind alle Reisen vorhanden
# LOGBUCH hat alle Reisen mit Schiffen > 8m
# ANLANDUNG wiederrum alle Reisen  

sample_trip <- dbGetQuery(conn,"SELECT * FROM reise")

sample_haul_fo <- dbGetQuery(conn,"SELECT * FROM reise")
sample_haul_gear <- dbGetQuery(conn,"SELECT * FROM reise")
sample_haul_env <- dbGetQuery(conn,"SELECT * FROM reise")

sample_weight <- dbGetQuery(conn,"SELECT * FROM reise")
sample_length <- dbGetQuery(conn,"SELECT * FROM reise")
sample_bio <- dbGetQuery(conn,"SELECT * FROM reise")






