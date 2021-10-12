
library(shiny)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    # --------------------------------
    # tab selection when click on image
    # --------------------------------
    
    shinyjs::onclick("fisheryID",  updateTabsetPanel(session, inputId="navbar", selected="Fischerei"))
    shinyjs::onclick("sampleID",  updateTabsetPanel(session, inputId="navbar", selected="Beprobung"))
    shinyjs::onclick("stockID",  updateTabsetPanel(session, inputId="navbar", selected="Biologie"))
    
    
    
    
    })


