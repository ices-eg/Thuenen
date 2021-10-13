
library(shiny)

shinyUI(
    
    
    #navBarPage
    navbarPage(
        theme = "style.css",
        collapsible = TRUE,
        id = "navbar",
        useShinyjs(),
        fluid = TRUE,
        windowTitle= tags$head(
            tags$link(rel = "icon", type = "image/png", href = "logo_small.png"),
            tags$title("Thünen OF")
            ),
        position = "fixed-top",
        header = tags$style(
            ".navbar-right { float: right !important;}",
            "body {padding-top: 55px;}"),
        tabPanel(id ="tabHome", title = introBox(icon("home")),
                 
                 fluidRow(
                     column(12,align="center",
                            img( src="logo_regular.png", height=100)
                     )),
                 br(), 
                 fluidRow(
                     column(12,align="center",
                            includeHTML('www/home.html') 
                     )),
                 br(),
                 fluidRow(
                     column(12, align="center",
                            div(style="display: inline-block;",class= "image", img(id="fisheryID", src="fishery_logo_eng.png", height=250, style="cursor:pointer;margin-right:40px;")),
                            div(style="display: inline-block;",class= "image", img(id ="sampleID", src="sampling_logo_eng.png", height=250, style="cursor:pointer;margin-right:40px;")),
                            div(style="display: inline-block;",class= "image", img(id ="stockID", src="stock_logo_eng.png", height=250, style="cursor:pointer;margin-right:40px;"))
        
                 )),
        ),
   # -----------------------------------
   # Fisheries overview tab
   # -----------------------------------
        navbarMenu(
            "Fishery",
            
            tabPanel(id="tabfish_over", "Fishery overview"
            ),
      # -----------------------------------
      # fleet overview
      # -----------------------------------
            tabPanel(id="tabInventory", "Fleet data"
      
            ),
      # -----------------------------------
      # landings overview
      # -----------------------------------
        tabPanel(id="tabInventory", "Landings"
                 
        )),
        
        
                     
   # -----------------------------------
   # Sampling overview tab
   # -----------------------------------
        navbarMenu(
            "Sampling",
          
            tabPanel(id="tabsample_over", "Sampling overview"
            ),  
      # -----------------------------------
      # cruise report markdown
      # -----------------------------------
            tabPanel(id="tabInventory", "Cruise report"
                     
            )),
   # -----------------------------------
   # Stock overview tab
   # -----------------------------------
        navbarMenu(
          "Biology",
          tabPanel(id="tabstock_over", "Biology overview"
          ), 
      # -----------------------------------
      # species selection and basic data
      # -----------------------------------
            tabPanel(id="tabInventory", "Species"),
            
            tabPanel(id="tablength", "Length distributions",
               fluidPage(
                 titlePanel("fish length test"), 
                 sidebarLayout(
                   sidebarPanel(
#                     selectInput("tbl_sample_length", "Choose a dataset:",
#                                 choices = c("cod", "plaice", "flounder")
#                     ),
#                     numericInput("area", "Number of observations to view:", 10),
#                     sliderInput("year", "Year",
#                                 min = 2016,
#                                 max = 2020
                   ), 
                   helpText("test some stuff")
                 ) # end layout    
                ) # end fluidpage  
              ) # end tabPanel 
            ) # end navbarmenue    
                     
# -------                     
                     
    ) # end Navbarpage
)# end of ui