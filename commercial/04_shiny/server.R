
library(shiny)


# Define server logic, re-direct to server folder
shinyServer(function(input, output) {

    for (file in list.files("server")) {
        source(file.path("server", file), local = TRUE, encoding = 'UTF-8')$value
    }
    
    
    })


