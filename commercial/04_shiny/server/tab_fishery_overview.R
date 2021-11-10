mapdata <-landings %>% 
  group_by(jahr, fao_gebiet, rechteck, fischart) %>% 
  summarize(fangkg = sum(fangkg))

#SpAggdata <- readRDS("Data/SpAggdata26022019.rds")
#sp_data_gp <- readRDS("Data/sp_data_gp_20190306.rds")

#------------------------------------
# Fishery overview
#------------------------------------
# tabPanel( 
#  title = "Flotte", 
#  fluidRow(
#    br(),

#function(input, output, session) {
  
##### Interactive Map - fishing areas #####
  # Create the map - leaflet 
  output$map <- renderLeaflet({
    leaflet() %>% 
      addProviderTiles(providers$Esri.OceanBasemap) %>% 
      setView(lng = 13.0000, lat = 54.800, zoom = 7)
  })

  # Filtering for Mapping 
  mapdata1 <- reactive({
    subset(mapdata, Year %in% input$slideryear)
  }) 

#} #end of function

  
##############  not connected to map yet, only reactive to year slider and drop-down!
##### Pie chart - sum of landings per species #####
##############
    sp_data_gp1 <- reactive({
    subset(landings, jahr %in% input$slideryear)
  })
# define data for reactive plot  
  sp_data_gp2_all <- reactive({
    sp_data_gp1() %>%
      group_by(group_fish) %>% 
      summarise(Totalkg = sum(fangkg))
  })
  sp_data_gp2_def <- reactive({
    sp_data_gp1() %>%  
      subset(group_fish %in% ("demersal species")) %>%
      group_by(fischart) %>% 
      summarise(Totalkg = sum(fangkg))
  })
  sp_data_gp2_spf <- reactive({
    sp_data_gp1() %>%
      subset(group_fish %in% ("pelagic species")) %>% 
      group_by(fischart) %>% 
      summarise(Totalkg = sum(fangkg))
  })
  m <- list(
    l = 30,
    r = 40,
    t = 160,
    b = 20
  ) 
# function to select data selection from above, based on drop-down menue  
  observe({
    P1 <- input$species_groups
    
    if(P1== "Total Landings kg") { 
      
      output$sp_piechart <- renderPlotly({   
        sp_data_gp2_all()  %>%
          plot_ly(labels = ~group_fish, values = ~Totalkg, 
                  textinfo ='label', textposition = "auto",  
                  type = 'pie',
                  marker = list(colors = c('#0c8e98','#06651f', '#F8D51A','#742416','#b8170f', '#f15f06'))) %>% ##8B2E62  
          layout(title = "Catch Composition (Species groups)",  showlegend = FALSE,
                 autosize = T, margin = m,
                 xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                 yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                 plot_bgcolor='transparent',
                 paper_bgcolor='transparent',
                 font = list(color='#FFFFFF'))
      })
    }else if (P1 == "Demersal Species kg") { 
      ##### Loading gif #####
      output$sp_piechart <- renderPlotly({   
        Sys.sleep(1)
        sp_data_gp2_def() %>%
          plot_ly(labels = ~fischart, values = ~Totalkg, 
                  textinfo ='label', textposition = "auto",
                  type = 'pie',
                  marker = list(colors = c('#0c8e98','#06651f', '#F8D51A','#742416','#b8170f', '#f15f06'))) %>% 
          layout(title = "Catch Composition (Catch Kg)",  showlegend = FALSE,
                 autosize = T, margin = m,
                 xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                 yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                 plot_bgcolor='transparent',
                 paper_bgcolor='transparent',
                 font = list(color='#FFFFFF'))
      })
    }else if (P1 == "Pelagic Species kg") { 
      ##### Loading gif #####
      output$sp_piechart <- renderPlotly({   
        Sys.sleep(1)
        sp_data_gp2_spf() %>%
          plot_ly(labels = ~fischart, values = ~Totalkg, 
                  textinfo ='label', textposition = "auto",
                  type = 'pie',
                  marker = list(colors = c('#0c8e98','#06651f', '#F8D51A','#742416','#b8170f', '#f15f06'))) %>% 
          layout(title = "Catch Composition (Catch Kg)",  showlegend = FALSE,
                 autosize = T, margin = m,
                 xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                 yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                 plot_bgcolor='transparent',
                 paper_bgcolor='transparent',
                 font = list(color='#FFFFFF'))
      })
    }
    
  })  
  
       
##### Infographics  #####


  
#  output$box1 <- renderValueBox({valueBox("Total Number of operating fishing vessels", value=noVessel, icon = icon("fas fa-anchor"))})#,  "fas fa-calculator"
#  output$box2 <- renderValueBox({valueBox("Number of fishing trips", value = maxKG(),icon =icon("fas fa-trophy"))})#fas fa-trophy"
#  output$box3 <- renderValueBox({valueBox("Total Landings (tons)", value = totalswept(), icon = icon("fas fa-ship"))})
  
  