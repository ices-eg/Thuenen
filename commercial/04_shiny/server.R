
# Define server logic, re-direct to server folder
shinyServer(function(input, output, session) {
    
    for (file in list.files("server")) {
        source(file.path("server", file), local = TRUE, encoding = 'UTF-8')$value
    }
    
})

# every Tab gets its own Server file in the directory for easier maintenance 
trip <- read.csv("Data/trip.csv", sep=";")
haul_fo <- read.csv("Data/haul_fo.csv")
haul_gear <- read.csv("Data/haul_gear.csv")

sample_weight <- read.csv("Data/sample_weight.csv")
sample_length <- read.csv("Data/sample_length.csv")
sample_bio <- read.csv("Data/sample_bio.csv")
