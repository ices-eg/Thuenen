#------------------------------------
# Dashboard for species overview
#------------------------------------
#library(shiny)
#library(tidyr)



##### Infographics  #####
select_year <- reactive({
  subset(haul_fo, year==input$year, select=c(year,quarter,ha_index,fao_area,rectangle))
})

# year_data <- subset(haul_fo, year==input$year, select=c(year,quarter,ha_index,fao_area,rectangle))

select_quarter <- reactive({
  if (input$quarter=="All"){
    select_year()
  } else {
    filter(select_year(), quarter==input$quarter)
  }
  
})

# if (input$quarter=="All"){
#     quarter_data <- year_data
# } else {
#     quarter_data <- subset(year_data, quarter==input$quarter)
# }

select_area <- reactive({
  if (input$Id=="FAO Area") {
    filter(select_quarter(), fao_area %in% input$subselect_fao)
  } else {
    filter(select_quarter(), rectangle %in% input$subselect_rect)
  }
})

# if (input$Id=="FAO Area") {
#     area_data <- subset(quarter_data, fao_area %in% input$subselect_fao)
# } else {
#     area_data <- subset(quarter_data, rectangle %in% input$subselect_rect)
# }

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
  we_index <- subset(sample_weight, ha_index %in% select_area()$ha_index)
})

# weight_data <- subset(sample_weight, ha_index %in% area_data$ha_index)

select_species <- reactive({
  if (input$species=="All"){
    select_weight()
  }
  else {
    filter(select_weight(), species %in% input$species)
  }
})

# if (input$species=="All"){
#     species_data <- weight_data
# }
# else {
#     species_data <- subset(weight_data, species %in% input$species)
# }

# select_catch <- reactive({
#     filter(select_weight(), catch_category)
# })

select_length <- reactive({
  subset(sample_length, we_index %in% select_species()$we_index)
})

# length_data <- subset(sample_length, we_index %in% species_data$we_index)

select_bio <- reactive({
  
  clean_sample <- sample_bio[,2:5] %>% spread(parameter, value)
  names(clean_sample)[3:8] <- c("Length","Weight","Sex","Maturity","Age","Readability")
  
  clean_sample$Length <- lapply(clean_sample$Length, as.numeric)
  clean_sample$Weight <- lapply(clean_sample$Weight, as.numeric)
  
  subset(clean_sample, le_index %in% select_length()$le_index)
})

# bio_data <- subset(clean_sample, we_index %in% length_data$we_index)
# print(bio_data)

output$bio_lw<- renderPlotly({
  if(input$biooptionselection=="Sex"){
    select_bio <- filter(select_bio(), !is.na(Sex))
    p <- plot_ly(select_bio(), x = ~Length, y = ~Weight, type = 'scatter', 
                 text=~paste("length:",Length,"cm","<br>weight:",Weight,"<br>sex:",Sex), #, "grams<br>date:", Date),
                 hoverinfo='text', color = ~Sex, colors="Set1",
                 mode = 'markers', marker =list(opacity = 0.5)) %>% 
      layout(hovermode=TRUE, title=paste(input$species,"Length vs Weight (points coloured by sex)"),
             margin=(list(t=70)), showlegend = TRUE) 
    p$elementId <- NULL
    p 
  }else if(input$biooptionselection=="Age"){
    select_bio <- filter(select_bio(), !is.na(Age))
    p <- plot_ly(select_bio(), x = ~Length, y = ~Weight, type = 'scatter', mode = 'markers',hoverinfo='text',
                 text=~paste("length:",Length,"cm","<br>weight:",Weight), #"grams<br>date:", Date, "<br>Age:", Age),
                 color= ~Age, colors = "Set1",marker =list(opacity = 0.5)) %>%  
      layout(hovermode=TRUE, title=paste(input$species,"Length vs Weight (points coloured by age)"),
             margin=(list(t=70)),
             showlegend = FALSE)
    p$elementId <- NULL
    p 
  }else if(input$biooptionselection=="Presentation"){
    grspnew.w1 <- filter(grspnew.w1(), !is.na(Presentation))
    p <- plot_ly(grspnew.w1(), x = ~Length, y = ~Weight, type = 'scatter', mode = 'markers',hoverinfo='text',
                 text=~paste("length:",Length,"cm","<br>weight:",Weight, "grams<br>date:", Date, "<br>presentation:", Presentation),
                 color= ~Presentation, colors = "Dark2") %>%  
      layout(hovermode=TRUE, title=paste(input$species,"Length vs Weight (points coloured by sample presentation)"),
             margin=(list(t=70)),
             showlegend = TRUE)
    p$elementId <- NULL
    p 
  }else if(input$biooptionselection=="Sample Type"){
    grspnew.w1 <- filter(select_bio(), !is.na(Type))
    p <- plot_ly(grspnew.w1(), x = ~Length, y = ~Weight, type = 'scatter', mode = 'markers',hoverinfo='text',
                 text=~paste("length:",Length,"cm","<br>weight:",Weight, "grams<br>date:", Date, "<br>sample type:",Type), 
                 color= ~Type,colors =c('Discards'='red','Landings'='lightgreen')) %>%  
      layout(hovermode=TRUE, title=paste(input$species,"Length vs Weight (points coloured by sample type)"),
             margin=(list(t=70)),
             showlegend = TRUE)
    p$elementId <- NULL
    p 
  }else if(input$biooptionselection=="Gear"){
    grspnew.w1 <- filter(grspnew.w1(), !is.na(Gear))
    p <- plot_ly(grspnew.w1(), x = ~Length, y = ~Weight, type = 'scatter', mode = 'markers',hoverinfo='text',
                 text=~paste("length:",Length,"cm","<br>weight:",Weight, "grams<br>date:", Date, "<br>gear type:",Gear),
                 color= ~Gear,colors = "Set1") %>%  
      layout(hovermode=TRUE, title=paste(input$species,"Length vs Weight (points coloured by gear type)"),
             margin=(list(t=70)),
             showlegend = TRUE)
    p$elementId <- NULL
    p 
  }
  else{
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
