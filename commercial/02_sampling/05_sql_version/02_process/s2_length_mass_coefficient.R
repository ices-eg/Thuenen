# Laengen-Gewichts Koeffizienten  
# berechnet aus der SnglIOR 

library("FSA")
library("car")        # benötigt für "rename" von Tabellenspalten
library("magrittr")       # benögtigt für joins
require("dplyr")

require("RPostgreSQL")

# Datenbankverbindung
pw <- { "27btw3_OSF" }
drv <- dbDriver("PostgreSQL")
conn <- dbConnect(drv, dbname = "dcmap_entwicklung",
                  host = "dmar01-hro.ad.ti.bund.de",
                  user = "stoetera",
                  password = pw)
rm(pw)

# Suchpfad setzen auf fishery_sample, public - weniger Tipparbeit
# TI-OF Beprobungsdaten 
# dbGetQuery(conn,"SET search_path TO com_fishery_sample_final,public")
dbGetQuery(conn,"SET search_path TO com_sample_final,public")

tbl_snglior <- dbGetQuery(conn,'SELECT * FROM snglior')

# Spalten reduzieren und NA entfernen (sonst Kalkulationsfehler)

snglior_short <- tbl_snglior[,c("snglid", "reisenr", "jahr", "quartal", "monat", "station", "fish", "identnr", "alter", "laenge", "totalgew")]

snglior_short <- snglior_short %>% filter(snglior_short$laenge != -9.0) 
#                  %>% 
#                  filter(snglior_short$totalgew != -9) %>% 
#                  na.omit(snglior_short, cols(c("laenge", "totalgew")))


# Subdivision ergänzen
snglior_short["subdiv"] <- paste("2",substring(snglior_short$reisenr,1,1), sep = "", collapse = NULL)

# Darstellung einiger LW-Verteilungen
library(ggplot2)
# plot(laenge~totalgew, data=snglior_short)

ggplot(snglior_short, aes(laenge, totalgew))+ geom_point(data=subset(snglior_short, fish=="607"), fill="grey70", colour = "black", alpha =0.7) +  
  labs(x = "Länge (cm)", y = "Gewicht (g)") + facet_grid(quartal ~subdiv) +
  stat_summary(data=subset(snglior_short, fish=="607"), aes(group=subdiv), fun.y=mean, geom="line", colour="red") +
  theme(text = element_text(size=20))


# Einzelkomponenten für ln_a und b vorbereiten
snglior_short <- snglior_short %>% mutate("sx"= log(laenge), "sy"=log(totalgew), "sxy" = sx*sy, "sqx"=sx*sx, "sqy"=sy*sy)
 

# lwc Tabelle 
lwc <- snglior_short %>% group_by(fish, jahr, subdiv, quartal) %>% summarize(n=n(), sx=sum(sx), sy=sum(sy), sxy=sum(sxy), sqx=sum(sqx), sgy=sum(sqy))
lwc <- lwc %>% filter(n != 1) #bei nur einem Tier (n=1) kann kein lwc berechnet werden
lwc <- lwc %>% mutate("b"=(((n*sxy) - (sx*sy))/((n*sqx) - (sx*sx))), "ln_a" = ((sy - b*sx)/n), "r" = cor(ln_a,b)^2)


# Tabelle in die PostgreSQL Datenbank laden (und die bestehende ersetzen)

dbWriteTable(conn, name=c("com_parameter", "length_weight_coefficient"), value= lwc, row.names = TRUE, overwrite = TRUE)


db_write_table(conn, c("com_parameter", "length_weight_coefficient"), lwc)


write.csv(lwc, "length_weight_coefficient.csv", quote = FALSE, row.names = FALSE)