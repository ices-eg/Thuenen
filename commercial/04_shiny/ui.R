
library(shiny)
#library(shinyjs)
#library(shinydashboard)
#library(rintrojs)

# myUrl <- "https://thuenen-sampling.de"

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
    # Fisheries Tab
    # -----------------------------------
    navbarMenu(
      "Fishery",
      
      # -----------------------------------
      # fishing fleet overview
      # -----------------------------------
      tabPanel(id="tabfish_over", "Fishery overview",
               dashboardPage(
                 dashboardHeader(disable = TRUE),
                 dashboardSidebar(disable = TRUE),
                 dashboardBody(
                   fluidPage(
                     #                     setSliderColor("white", 1), #to change the color of the first slider in this fluidpage
                     chooseSliderSkin("Round"), #change the style of all slider in this fluidpage
                     fluidRow(valueBoxOutput("box1"),
                              valueBoxOutput("box2"),
                              valueBoxOutput("box3")),
                     br(), 
                     fluidRow(box(h4("Interactive map"), style = "margin-top:-1.5em", width=12, background = "light-blue",
                                  column(8, leafletOutput("map", height=550, width="auto")),
                                  column(4, id="controls", fixed=FALSE, draggable = TRUE, 
                                         fluidRow(column(12,selectInput("species_groups",label=NULL, choices = c("Total Landings kg","Demersal Species kg", "Pelagic Species kg")),
                                                         sliderInput("slideryear", "Year:", min = 2003, max(landings$jahr) #max = 2021
                                                                     , value = 2020, step = 1, sep = "", animate = TRUE)
                                         )), 
                                         br(), br(), br(), br(), 
                                         fluidRow(column(12,plotlyOutput("sp_piechart") %>% 
                                                           withSpinner(color="#0dc5c1"),
                                                         style = "margin-top:-9em"),
                                                  solidHeader =FALSE, collapsible = T,width= "auto", background = "navy")
                                  ), 
                     )),
                     fluidRow(width =12,style = "margin-top:-4em", 
                              box(width =12, img(src="header-fang2.jpg", width = "1200px", height = "75px", style="display: block; margin-left: auto; margin-right: auto;margin-top:0em"))
                     )
                   ) #end of fluidRow
                 ) #end of dashboardBody
               ) # end of dashboardPage
      ), #end of tabPanel   
      
      # -----------------------------------
      # fleet overview
      # -----------------------------------
      tabPanel(id="tab_fish_landings", "Commercial Landings",
               dashboardPage(
                 dashboardHeader(disable = TRUE),
                 dashboardSidebar(disable = TRUE),
                 dashboardBody(
                   fluidPage(
                     chooseSliderSkin("Round"), #change the style of all slider in this fluidpage
                     br(),
                     fluidRow((column(12,selectInput("species_groups",label=NULL, choices = c("Total Landings kg","Demersal Species kg", "Pelagic Species kg")),
                                      checkboxGroupInput("variable", "Select Quarter:",
                                                         c("Q1" = "q1",
                                                           "Q2" = "q2",
                                                           "Q3" = "q3",
                                                           "Q4" = "q4")),
                                      sliderInput("slideryear", "Year:", min = 2003, max(landings$jahr), #max = 2021
                                                  value = 2020, step = 1, sep = "", animate = TRUE) )
                     )),
                     fluidRow(tabPanel(id="map", "Map", 
                                       fluidPage(fluidRow(box(h4("Interactive map"), style = "margin-top:-1.5em", width=12, background = "light-blue",
                                                              column(8, leafletOutput("map", height=550, width="auto")))),
                                                 tabPanel(id="table", "Table",
                                                          fluidPage())
                                                 
                                       )))
                   ) #end of dashboardBody
                 ) # end of dashboardPage
               ), #end of tabPanel      
               
               
               
               # -----------------------------------
               # landings overview
               # -----------------------------------
               tabPanel(id="tab_fish_log", "Logbooks"
                        
               ),
               
               
               # -----------------------------------
               # landings overview
               # -----------------------------------
               tabPanel(id="tab_fish_invent", "Fishery Inventory"
                        
               ))),        
      
      
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
      
      navbarMenu("Biology",
                 tabPanel(id="tabstock_over", "Biology overview"
                          
                 ),
                 
                 
                 # -----------------------------------
                 # Species dashboard
                 # -----------------------------------                
                 tabPanel(id="tabstock_dash", "Species Dashboard",
                          fluidRow(column(width = 7,
                                          fluidRow(column(width=3,
                                                          # We set the species list and default selection in server.R now 
                                                          selectInput("species",label="Species",
                                                                      choices = list("All", "COD", "FLE", "PLE", "DAB", "HER", "TUR"),
                                                                      selected = "COD"),
                                                          conditionalPanel(condition = "input.fishtab == 'A'",
                                                                           selectInput(inputId="biooptionselection", label="Select parameter", 
                                                                                       choices=list("None","Age","Sex","Gear","Sample Type"),
                                                                                       selected = "None")),
                                                          conditionalPanel(condition = "input.fishtab == 'B'",
                                                                           selectInput(inputId="ageoptionselection", label="Select parameter", 
                                                                                       choices=list("None","Age","Sex","Gear","Sample Type"),
                                                                                       selected = "None")),
                                                          conditionalPanel(condition = "input.biooptionselection =='Gear' && input.fishtab == 'A'",
                                                                           uiOutput("GearFilter")),
                                                          conditionalPanel(condition = "input.ageoptionselection =='Gear' && input.fishtab == 'B'",
                                                                           uiOutput("GearFilter.a"))),
                                                   column(width=4,
                                                          selectInput("quarter", label="Quarter",
                                                                      choices = list("All", 1, 2, 3, 4),
                                                                      selected = "All"),
                                                          sliderInput("year", "Years", min=min(trip$year, na.rm=TRUE), max=max(trip$year, na.rm=TRUE),
                                                                      value=max(trip$year, na.rm=TRUE), sep="", step=1)), #by one year
                                                   column(width=5,
                                                          conditionalPanel("input.fishtab == 'A'",
                                                                           radioGroupButtons(inputId = "Id",label = "",
                                                                                             choices = c("FAO Area", 
                                                                                                         "Rectangle"),
                                                                                             direction = "horizontal",
                                                                                             checkIcon = list(
                                                                                               yes = tags$i(class = "fa fa-check-square", 
                                                                                                            style = "color: steelblue"),
                                                                                               no = tags$i(class = "fa fa-square-o", 
                                                                                                           style = "color: steelblue"))),
                                                                           uiOutput("spatialops.w")),
                                                          
                                                          conditionalPanel("input.fishtab == 'A'",
                                                                           downloadButton("downloadDatalw", "Download data")),
                                                          
                                                          conditionalPanel("input.fishtab == 'B'",
                                                                           radioGroupButtons(inputId = "Id.a", label = "",
                                                                                             choices = c("FAO Area", 
                                                                                                         "Rectangle"),
                                                                                             direction = "horizontal",
                                                                                             checkIcon = list(
                                                                                               yes = tags$i(class = "fa fa-check-square", 
                                                                                                            style = "color: steelblue"),
                                                                                               no = tags$i(class = "fa fa-square-o", 
                                                                                                           style = "color: steelblue"))),
                                                                           uiOutput("spatialops.a")),
                                                          
                                                          conditionalPanel("input.fishtab == 'B'",                 
                                                                           downloadButton("downloadDatala", "Download data", class="btn btn-outline-primary")
                                                                           
                                                          ))),
                                          
                                          ##### Fish sp tab - Maps and plots  ######                                     
                                          fluidRow(
                                            column(width=12,
                                                   conditionalPanel(condition = "input.fishtab == 'A'",
                                                                    plotlyOutput("bio_lw")
                                                                    %>% withSpinner(color="#0dc5c1")),
                                                   conditionalPanel(condition = "input.fishtab == 'B'",
                                                                    plotlyOutput("bio_la")
                                                                    %>% withSpinner(color="#0dc5c1"))
                                            ))#,
                                          
                                          # fluidRow(
                                          #   column(width=10,
                                          #          conditionalPanel(condition = "input.fishtab == 'C'",
                                          #                           imageOutput("fish_b1", height="100%"),
                                          #                           tags$style(HTML(".js-irs-0 .irs-grid-pol.small {height: 4px;}")),
                                          #                           tags$style(HTML(".js-irs-1 .irs-grid-pol.small {height: 0px;}")),
                                          #                           sliderInput("slideryear", "Choose Year:",
                                          #                                       min = 2007, max = 2019, #change after yearly update..For year 2020 max year is 2019
                                          #                                       value = 2019, step = 1,
                                          #                                       sep = "",
                                          #                                       animate = TRUE),htmlOutput("LandingsDisttext")),offset=4,style = "margin-top:-5em"))
                          ), 
                          ##### Fish sp tab - Species tabsets #####
                          column(width = 5, tabsetPanel(id = "fishtab",
                                                        tabPanel("Biology",value= "A", 
                                                                 p(), htmlOutput("fish_biology"),
                                                                 fluidRow(column(width=7,imageOutput("fish_drawing", height='100%')),
                                                                          column(width=5,conditionalPanel(condition = "input.species =='COD'",
                                                                                                          imageOutput("monk_belly"))))),     
                                                        tabPanel("Age", value = "B", 
                                                                 p(),
                                                                 fluidRow(column(width=5, htmlOutput("ageingtxt")),
                                                                          column(width=7, imageOutput("speciesotolith", height='100%'))),
                                                                 p(),
                                                                 fluidRow(column(width=5,textInput("lengthcm", label = "Enter fish length in cm:"), value = 0),
                                                                          column(width=7,tags$b("Age range observed*:"), h4(textOutput("agerange")),
                                                                                 tags$b("Modal age is:"),h4(textOutput("mode")),
                                                                                 tags$small("*age range based on age readings and lengths taken from fish sampled at ports and the stockbook"))),
                                                                 hr(),
                                                                 column(width=5,actionButton("showhist",label = "Show Histogram")), 
                                                                 plotlyOutput("age_hist"))#,
                                                        # tabPanel("Distribution",value= "C",
                                                        #          
                                                        #          p(),htmlOutput("fish_distribution"),
                                                        #          p(),htmlOutput("fish_b1a"),
                                                        #          h3("Useful links for more information:"),
                                                        #          a(href=paste0("https://shiny.marine.ie/stockbook/"),
                                                        #            "The Digital Stockbook",target="_blank"),
                                                        #          p(), 
                                                        #          a(href=paste0("https://www.marine.ie"),
                                                        #            "The Marine Institute webpage",target="_blank"),
                                                        #          p(),
                                                        #          "For any quaries contact",
                                                        #          a("informatics@marine.ie",href="informatics@marine.ie"))
                          )
                          )
                          )), 
                                   
                                   # -----------------------------------
                                   # stock specific data and plots
                                   # -----------------------------------
                                   tabPanel(id="tabInventory", "Stock parameter"),
                                   
                                   
                                   # -----------------------------------
                                   # stock specific data and plots
                                   # -----------------------------------
                                   tabPanel(id="tablength", "Length distributions",
                                            fluidPage(
                                              titlePanel("fish length test"), 
                                              sidebarLayout(
                                                sidebarPanel(
                                                  #                     selectInput("tbl_sample_length", "Choose a dataset:",
                                                  #                                 choices = c("cod", "plaice", "flounder")
                                                  #                                  ),
                                                  #                     numericInput("area", "Number of observations to view:", 10),
                                                  sliderInput("year", "Year", min = 2016, max = 2020, value = 2019, sep = ""), 
                                                  helpText("test some stuff")), 
                                                mainPanel(plotOutput("distPlot"))
                                              ) # end layout    
                                            ) # end fluidpage
                                   ) # end tabPanel 
                          ) # end navbarmenue    
                          
                          # -------                     
                          
                 ) # end Navbarpage
      )# end of ui
      
