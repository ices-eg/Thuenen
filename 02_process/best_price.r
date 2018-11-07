library("tidyverse")
require("RPostgreSQL")


pw <- {
  "secret"
}
drv <- dbDriver("PostgreSQL")
conn <- dbConnect(
  drv,
  dbname = "dcmap_entwicklung",
  host = "dmar01-hro.ad.ti.bund.de",
  user = "user",
  password = pw
)
rm(pw)

sql = "DROP TABLE IF EXISTS com_fishery_process.land_price"
tbl_land_price <- dbGetQuery(conn, sql)

sql =
  "CREATE TABLE com_fishery_process.land_price AS SELECT
EUNR,
REISENR,
LANDNR,
UNTERBEREICH,
ZONE,
RECHTECK,
extract(year from to_timestamp(landdat ,'YYYYMMDD HH24MI')::timestamp without time zone ) as land_year,
extract(quarter from to_timestamp(landdat ,'YYYYMMDD HH24MI')::timestamp without time zone) as land_quarter,
extract(month from to_timestamp(landdat ,'YYYYMMDD HH24MI')::timestamp without time zone) as land_month,
extract(week from to_timestamp(landdat ,'YYYYMMDD HH24MI')::timestamp without time zone) as land_week,
LANDDAT,
LANDORT,
FISCHART,
sum(FANGKG) as sum_landing,
sum(ERLOES) as sum_revenue,
sum(ERLOES/FANGKG) as avg_price
-- stddev(ERLOES/FANGKG) as std_land_price,
-- stddev(ERLOES/FANGKG)/(sum(ERLOES)/sum(FANGKG)) as cov_land_price
FROM com_fishery_original.anlandung
WHERE FANGKG IS NOT NULL AND FANGKG <> 0 AND ERLOES IS NOT NULL AND ERLOES <> 0
GROUP BY
EUNR,
REISENR,
LANDNR,
UNTERBEREICH,
ZONE,
RECHTECK,
extract(year from to_timestamp(landdat ,'YYYYMMDD HH24MI')::timestamp without time zone),
extract(quarter from to_timestamp(landdat ,'YYYYMMDD HH24MI')::timestamp without time zone),
extract(month from to_timestamp(landdat ,'YYYYMMDD HH24MI')::timestamp without time zone),
extract(week from to_timestamp(landdat ,'YYYYMMDD HH24MI')::timestamp without time zone),
LANDDAT,
LANDORT,
FISCHART
"
dbGetQuery(conn, sql)

sql = "SELECT * FROM com_fishery_process.land_price"

tbl_land_price <- dbGetQuery(conn, sql)

sql = "select distinct
EUNR,
REISENR,
LANDNR,
unterbereich as GEBIET,
ZONE,
RECHTECK,

extract(year from to_timestamp(landdat ,'YYYYMMDD HH24MI')::timestamp without time zone ) as land_year,
extract(quarter from to_timestamp(landdat ,'YYYYMMDD HH24MI')::timestamp without time zone) as land_quarter,
extract(month from to_timestamp(landdat ,'YYYYMMDD HH24MI')::timestamp without time zone) as land_month,
extract(week from to_timestamp(landdat ,'YYYYMMDD HH24MI')::timestamp without time zone) as land_week,

LANDDAT,

LANDORT,
FISCHART

FROM com_fishery_original.anlandung"
tbl_best_price <- dbGetQuery(conn, sql)


groupings = c(
  "land_year,landdat,landort,fischart",
  # date price
  "land_year,land_week,landort,fischart",
  # week price
  "land_year,land_month,landort,fischart",
  # month price
  "land_year,land_quarter,landort,fischart",
  # quarter price
  "land_year,landort,fischart",
  # year price
  "land_year,fischart"
) # country price

get_price <- function(group) {
  sql = "SELECT grouping ,
  sum(sum_landing) as sum_landing,
  sum(sum_revenue) as sum_revenue,
  sum(sum_revenue)/sum(sum_landing) as price
  FROM com_fishery_process.land_price
  GROUP BY grouping"
  
  sqlstr <- gsub("grouping", group, sql)
  
  print(sqlstr)
  return(dbGetQuery(conn, sqlstr))
}

tbls_price <- lapply(groupings, get_price)


tbl_p <- left_join(tbl_best_price, tbl_land_price)

for( i in seq_along(tbls_price)) {
  tbl_p <- left_join(tbl_p, tbls_price[[i]])
  tbl_p <- mutate(tbl_p,avg_price = coalesce(avg_price,price))
  tbl_p = select(tbl_p, -price, -sum_landing, -sum_revenue)
}

copy_to(conn,tbl_p,name="com_fishery_process.best_price",overwrite = TRUE, temporary=FALSE)

View(tbl_p)
