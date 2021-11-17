
# Define server logic, re-direct to server folder
shinyServer(function(input, output, session) {
    
    for (file in list.files("server")) {
        source(file.path("server", file), local = TRUE, encoding = 'UTF-8')$value
    }
    
})


# read in sample data 
trip <- read.csv("data/trip.csv", sep=";")
haul_fo <- read.csv("data/haul_fo.csv")
haul_gear <- read.csv("data/haul_gear.csv")

sample_weight <- read.csv("data/sample_weight.csv")
sample_length <- read.csv("data/sample_length.csv")
sample_bio <- read.csv("data/sample_bio.csv")

# read in fishery data
landings <- read.csv("data/anlandung.csv", sep=";")
#logbooks <- read.csv("data/logbuch.csv")
#trip_info <- read.csv("data/reise.csv")
#all_vessel <- read.csv("data/all_vessel_ce_cl_join.csv")

# read in supportive files
#harbor <- read.csv("data/harbor_code.csv")
#species <- read.csv("data/species_code.csv")

# add species group to the landings 
landings <- landings %>% mutate(group_fish = case_when(fischart %in% c("COD", "PLE", "FLE", "DAB", "SOL", "TUR", "BLL", "WHG", "LUM") ~ "demersal species", 
                                                  fischart %in% c("HER", "SPR", "GAR", "MAC", "HKE") ~ "pelagic species", 
                                                  fischart %in% c("FPE", "FRO", "FBR", "FBU", "FPI", "FPP", "FTE", "ELP", "FCC", "FCP") ~ "freshwater species",
                                                  fischart %in% c("TRS","PLN", "ELE","SAL","TRO") ~ "freshwater species", TRUE ~ "other")
)

#ices.rect <- read_sf("shp/ices_rectangles/ices_squares_simple.shp")
#ices.rect <- read_sf("../data/shapefiles/ices_rectangles/ices_squares_simple.shp")
#ices.rect<-as(ices.rect, 'Spatial')