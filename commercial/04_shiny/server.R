
# Define server logic, re-direct to server folder
shinyServer(function(input, output, session) {
    
    for (file in list.files("server")) {
        source(file.path("server", file), local = TRUE, encoding = 'UTF-8')$value
    }
    
})


# read in sample data 
trip <- read.csv("data/trip.csv", sep=";")
haul_fo <- read.csv("data/haul_fo.csv")
haul_gear <- read.csv("Data/haul_gear.csv")

sample_weight <- read.csv("Data/sample_weight.csv")
sample_length <- read.csv("Data/sample_length.csv")
sample_bio <- read.csv("Data/sample_bio.csv")

# read in fishery data
#landings <- read.csv("Data/anlandung.csv")
#logbooks <- read.csv("Data/logbuch.csv")
#trip_info <- read.csv("Data/reise.csv")
#all_vessel <- read.csv("Data/all_vessel_ce_cl_join.csv")

# read in supportive files
#harbor <- read.csv("Data/harbor_code.csv")
#species <- read.csv("Data/species_code.csv")