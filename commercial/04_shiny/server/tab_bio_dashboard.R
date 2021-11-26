#------------------------------------
# Dashboard for species overview
#------------------------------------
#library(shiny)
#library(tidyr)



##### Infographics  #####

select_year <- reactive({
  subset(haul_fo, year==input$year, select=c(year,quarter,ha_index,fao_area,rectangle))
})

gear_data <- reactive({
  gear <- subset(haul_gear, ha_index %in% select_year()$ha_index,
                 select=c(ha_index,gear))
  gear %>%
    left_join(select_year(), by=c("ha_index"))
})

output$GearFilter <- renderUI({
  gearlist <- unique(gear_data()$gear)
  gearlist2 = factor(append("All", as.character(gearlist)))
  selectInput(inputId="gearselect", label="Select gear type", choices=gearlist2, selected= "All")
})

select_gear <- reactive({
  print(gear_data())
  if (input$gearselect == "All"|| is.null(input$gearselect)|| input$biooptionselection=="None"){
    gear_data()
  } else {
    filter(gear_data(), gear==input$gearselect)
  }
})

select_quarter <- reactive({
  if (input$quarter=="All"){
    select_gear()
  } else {
    filter(select_gear(), quarter==input$quarter)
  }
  
})

select_area <- reactive({
  if (input$Id=="FAO Area") {
    filter(select_quarter(), fao_area %in% input$subselect_fao)
  } else {
    filter(select_quarter(), rectangle %in% input$subselect_rect)
  }
})

# Creating Sub Area filter based on the full data
output$spatialops.w <- renderUI({
  if(input$Id=="FAO Area"){
    pickerInput(
      inputId = "subselect_fao",
      label = "FAO Area",
      choices = str_sort(as.character(unique(select_quarter()$fao_area)),numeric = TRUE),
      selected = str_sort(as.character(unique(select_quarter()$fao_area)),numeric = TRUE),
      options = list(
        `actions-box` = TRUE
      ),
      multiple = TRUE
    )}
  else{
    pickerInput(
      inputId = "subselect_rect",
      label = "Rectangle",
      choices = str_sort(as.character(unique(select_quarter()$rectangle)),numeric = TRUE),
      selected=str_sort(as.character(unique(select_quarter()$rectangle)),numeric = TRUE),
      options = list(
        `actions-box` = TRUE
      ),
      multiple = TRUE
    )}
})

select_weight <- reactive({
  we_subset <- subset(sample_weight, ha_index %in% select_area()$ha_index)
  
  we_subset %>%
    left_join(select_area(), by = c("ha_index"))
})

select_species <- reactive({
  if (input$species=="All"){
    select_weight()
  }
  else {
    filter(select_weight(), species == input$species)
  }
})

select_length <- reactive({
  le_subset <- subset(sample_length, we_index %in% select_species()$we_index)
  le_subset %>%
    left_join(select_species(), by=c("we_index"))
})

select_bio <- reactive({
  
  clean_sample <- sample_bio[,2:5] %>% spread(parameter, value)
  names(clean_sample)[3:8] <- c("Length","Weight","Sex","Maturity","Age","Readability")
  
  clean_sample$Length <- lapply(clean_sample$Length, as.numeric)
  clean_sample$Weight <- lapply(clean_sample$Weight, as.numeric)
  
  bi_subset <- subset(clean_sample, le_index %in% select_length()$le_index)
  
  bi_subset %>%
    left_join(select_length(), by = c("le_index"))
})

##### Histogram #######
observeEvent(input$showhist, {
  
  output$age_hist <- renderPlotly({
    p<-ggplot(select_bio(),aes(Age))+geom_bar(color="black",fill="white",width = 1)+
      labs(title ='Histogram of observered ages',x="Age" )
    ggplotly(p)
    
  })
})

output$bio_lw<- renderPlotly({
  if(input$biooptionselection=="Sex"){
    p <- plot_ly(select_bio(), x = ~Length, y = ~Weight, type = 'scatter', 
                 hoverinfo='text', color = ~Weight, colors="Set1",
                 text=~paste("length:",Length,"cm","<br>weight:",Weight,"<br>sex:",Sex), #, "grams<br>date:", Date),
                 mode = 'markers', marker =list(opacity = 0.5)) %>% 
      layout(hovermode=TRUE, title=paste(input$species,"Length vs Weight (points coloured by sex)"),
             margin=(list(t=70)), showlegend = TRUE) 
    p$elementId <- NULL
    p 
  }else if(input$biooptionselection=="Age"){
    p <- plot_ly(select_bio(), x = ~Length, y = ~Weight, type = 'scatter', mode = 'markers',hoverinfo='text',
                 #text=~paste("length:",Length,"cm","<br>weight:",Weight), #"grams<br>date:", Date, "<br>Age:", Age),
                 color= ~Age, colors = "Spectral", marker =list(opacity = 0.5)) %>%  
      layout(hovermode=TRUE, title=paste(input$species,"Length vs Weight (points coloured by age)"),
             margin=(list(t=70)),
             showlegend = FALSE)
    p$elementId <- NULL
    p
  }else if(input$biooptionselection=="Sample Type"){
    select_bio <- filter(select_bio(), !is.na(catch_category))
    print(select_bio())
    p <- plot_ly(select_bio(), x = ~Length, y = ~Weight, type = 'scatter', mode = 'markers',hoverinfo='text',
                 text=~paste("length:",Length,"cm","<br>weight:",Weight, "<br>sample type:",catch_category), 
                 color= ~catch_category,colors =c('D'='red','L'='lightgreen')) %>%  
      layout(hovermode=TRUE, title=paste(input$species,"Length vs Weight (points coloured by sample type)"),
             margin=(list(t=70)),
             showlegend = TRUE)
    p$elementId <- NULL
    p 
  }else if(input$biooptionselection=="Gear"){
    select_bio <- filter(select_bio(), !is.na(gear))
    print(select_bio())
    p <- plot_ly(select_bio(), x = ~Length, y = ~Weight, type = 'scatter', mode = 'markers',hoverinfo='text',
                 text=~paste("length:",Length,"cm","<br>weight:",Weight, "<br>gear type:",gear),
                 color= ~gear,colors = "Set1") %>%  
      layout(hovermode=TRUE, title=paste(input$species,"Length vs Weight (points coloured by gear type)"),
             margin=(list(t=70)),
             showlegend = TRUE)
    p$elementId <- NULL
    p 
  }
  else{
    print(select_bio())
    p <- plot_ly(select_bio(), x = ~Length, y = ~Weight, type = 'scatter', color=~Weight, colors="Spectral",
                 mode = 'markers', marker =list(opacity = 0.5), hoverinfo='text',
                 text=~paste("length:",Length,"cm<br>weight:",Weight)) %>%
      layout(hovermode=TRUE, title=paste(input$species," Length vs Weight", sep=""),
             margin=(list(t=80)),
             showlegend = FALSE)
    p$elementId <- NULL
    p
    
  }
})

output$bio_la<- renderPlotly({
  if(input$biooptionselection=="Sex"){
    p <- plot_ly(select_bio(), x = ~Age, y = ~Length, type = 'scatter', 
                 hoverinfo='text', color = ~Sex, colors="Set1",
                 text=~paste("length:",Length,"cm","<br>weight:",Weight,"<br>sex:",Sex), #, "grams<br>date:", Date),
                 mode = 'markers', marker =list(opacity = 0.5)) %>% 
      layout(hovermode=TRUE, title=paste(input$species,"Length vs Weight (points coloured by sex)"),
             margin=(list(t=70)), showlegend = TRUE) 
    p$elementId <- NULL
    p 
  }else if(input$biooptionselection=="Weight"){
    p <- plot_ly(select_bio(), x = ~Age, y = ~Length, type = 'scatter', mode = 'markers',hoverinfo='text',
                 #text=~paste("length:",Length,"cm","<br>weight:",Weight), #"grams<br>date:", Date, "<br>Age:", Age),
                 color= ~Age, colors = "Spectral", marker =list(opacity = 0.5)) %>%  
      layout(hovermode=TRUE, title=paste(input$species,"Length vs Weight (points coloured by age)"),
             margin=(list(t=70)),
             showlegend = FALSE)
    p$elementId <- NULL
    p
  }else if(input$biooptionselection=="Sample Type"){
    select_bio <- filter(select_bio(), !is.na(catch_category))
    print(select_bio())
    p <- plot_ly(select_bio(), x = ~Age, y = ~Length, type = 'scatter', mode = 'markers',hoverinfo='text',
                 text=~paste("length:",Length,"cm","<br>weight:",Weight, "<br>sample type:",catch_category), 
                 color= ~catch_category,colors =c('D'='red','L'='lightgreen')) %>%  
      layout(hovermode=TRUE, title=paste(input$species,"Length vs Weight (points coloured by sample type)"),
             margin=(list(t=70)),
             showlegend = TRUE)
    p$elementId <- NULL
    p 
  }else if(input$biooptionselection=="Gear"){
    select_bio <- filter(select_bio(), !is.na(gear))
    print(select_bio())
    p <- plot_ly(select_bio(), x = ~Age, y = ~Length, type = 'scatter', mode = 'markers',hoverinfo='text',
                 text=~paste("length:",Length,"cm","<br>weight:",Weight, "<br>gear type:",gear),
                 color= ~gear,colors = "Set1") %>%  
      layout(hovermode=TRUE, title=paste(input$species,"Length vs Weight (points coloured by gear type)"),
             margin=(list(t=70)),
             showlegend = TRUE)
    p$elementId <- NULL
    p 
  }
  else{
    print(select_bio())
    p <- plot_ly(select_bio(), x = ~Age, y = ~Length, type = 'scatter', color=~Weight, colors="Spectral",
                 mode = 'markers', marker =list(opacity = 0.5), hoverinfo='text',
                 text=~paste("length:",Length,"cm<br>Age:",Weight)) %>%
      layout(hovermode=TRUE, title=paste(input$species," Length vs Weight", sep=""),
             margin=(list(t=80)),
             showlegend = FALSE)
    p$elementId <- NULL
    p
    
  }
})

