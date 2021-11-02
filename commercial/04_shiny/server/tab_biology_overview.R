#------------------------------------
# Biology overview
#------------------------------------
#library(shiny)
#library(tidyr)



##### Infographics  #####
select_year <- reactive({
  
  subset(haul_fo, year==input$year, select=c(year,ha_index))
  
})

output$yearfilter<- renderUI({
  print(select_year()$year)
  sliderInput("year","Years", min=min(trip$year, na.rm=TRUE), max=max(trip$year, na.rm=TRUE),
              # value=c(min(grsp()$Year, na.rm=TRUE), max(grsp()$Year, na.rm=TRUE)), sep="", step=1) ##all years
              value=max(trip$year, na.rm=TRUE), sep="", step=1)##by one year
  
})

observe({updateSliderInput(session, "receive", value = input$year)})

clean_sample <- sample_bio[,2:5] %>% spread(parameter, value)
names(clean_sample)[3:8] <- c("Length","Weight","Sex","Maturity","Age","Readability")

clean_sample$Length <- lapply(clean_sample$Length, as.numeric)
clean_sample$Weight <- lapply(clean_sample$Weight, as.numeric)

select_weight <- reactive({
  we_index <- subset(sample_weight, ha_index %in% select_year()$ha_index)
})

select_species <- reactive({
  filter(select_weight(), species %in% input$species)
})

select_length <- reactive({
  subset(sample_length, we_index %in% select_species()$we_index)
})

select_bio <- reactive({
  subset(clean_sample, le_index %in% select_length()$le_index)
})

# grspnew.w<- reactive({
#     
#     # grspyear<- filter(select_bio())#, Year %in% input$year)
#     grspyear <- select_bio()
#     # if(input$quarter == "All" || is.null(input$quarter)){
#     #     grspqtr = grspyear
#     # }else{
#     #     grspqtr<- filter(grspyear, Quarter %in% input$quarter )
#     #}
#     grspqtr = grspyear #added line
#     # if(input$gearselect == "All"|| is.null(input$gearselect)|| input$biooptionselection=="None"){
#     #     grspgear = grspqtr
#     # }else{
#     #     grspgear <- filter(grspqtr, Gear %in% input$gearselect)
#     # }
# })

# grspnew.w1<- reactive({
#     grspSub <- grspnew.w()
#     # if(input$Id=="ICES Area"){
#     #     grspSub <- filter(grspnew.w(),ICESSubArea %in% input$subselect)}
#     # else{
#     #     grspSub <- filter(grspnew.w(),ICESDivFullNameN %in% input$subselect2)
#     # }
# })

#Creating Sub Area filter based on the full data
#output$spatialops.w <- renderUI({
# if(input$Id=="ICES Area"){
#     pickerInput(
#         inputId = "subselect",
#         label = "ICES Area",
#         choices = str_sort(as.character(unique(grsp()$ICESSubArea)),numeric = TRUE),
#         selected=str_sort(as.character(unique(grsp()$ICESSubArea)),numeric = TRUE),
#         options = list(
#             `actions-box` = TRUE
#         ),
#         multiple = TRUE
#     )}
# else{
#     pickerInput(
#         inputId = "subselect2",
#         label = "ICES Division",
#         choices = str_sort(as.character(unique(grsp()$ICESDivFullNameN )),numeric = TRUE),
#         selected=str_sort(as.character(unique(grsp()$ICESDivFullNameN )),numeric = TRUE),
#         options = list(
#             `actions-box` = TRUE
#         ),
#         multiple = TRUE
#     )}
#})

output$bio_lw<- renderPlotly({
  if(input$biooptionselection=="Sex"){
    select_bio <- filter(select_bio(), !is.na(Sex))
    p <- plot_ly(select_bio(), x = ~Length, y = ~Weight, type = 'scatter', 
                 text=~paste("length:",Length,"cm","<br>weight:",Weight), #, "grams<br>date:", Date),
                 hoverinfo='text',
                 color = ~Sex, colors="Set1",
                 mode = 'markers', marker =list(opacity = 0.5)) %>% 
      layout(hovermode=TRUE, title=paste(input$species,"Length vs Weight (points coloured by sex)"),
             #xaxis = list(title = 'Length (cm)', range= c(min(grspnew.w1()$Length), max(grspnew.w1()$Length)+1)),
             #yaxis = list(title = 'Weight (g)', range = c(0, max(grspnew.w1()$Weight, na.rm = T)*1.05)),
             margin=(list(t=70)),
             showlegend = TRUE) 
    p$elementId <- NULL
    p 
  }else if(input$biooptionselection=="Age"){
    print(select_bio())
    select_bio <- filter(select_bio(), !is.na(Age))
    p <- plot_ly(select_bio(), x = ~Length, y = ~Weight, type = 'scatter', mode = 'markers',hoverinfo='text',
                 text=~paste("length:",Length,"cm","<br>weight:",Weight), #"grams<br>date:", Date, "<br>Age:", Age),
                 color= ~Age, colors = "Set1",marker =list(opacity = 0.5)) %>%  
      layout(hovermode=TRUE, title=paste(input$species,"Length vs Weight (points coloured by age)"),
             #xaxis = list(title = 'Length (cm)', range= c(min(grspnew.w1()$Length), max(grspnew.w1()$Length)+1)),
             #yaxis = list(title = 'Weight (g)', range = c(0, max(grspnew.w1()$Weight, na.rm = T)*1.05)),
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
             #xaxis = list(title = 'Length (cm)', range= c(min(grspnew.w1()$Length), max(grspnew.w1()$Length)+1)),
             #yaxis = list(title = 'Weight (g)', range = c(0, max(grspnew.w1()$Weight, na.rm = T)*1.05)),
             margin=(list(t=70)),
             showlegend = TRUE)
    p$elementId <- NULL
    p 
  }else if(input$biooptionselection=="Sample Type"){
    grspnew.w1 <- filter(grspnew.w1(), !is.na(Type))
    p <- plot_ly(grspnew.w1(), x = ~Length, y = ~Weight, type = 'scatter', mode = 'markers',hoverinfo='text',
                 text=~paste("length:",Length,"cm","<br>weight:",Weight, "grams<br>date:", Date, "<br>sample type:",Type), 
                 color= ~Type,colors =c('Discards'='red','Landings'='lightgreen')) %>%  
      layout(hovermode=TRUE, title=paste(input$species,"Length vs Weight (points coloured by sample type)"),
             #xaxis = list(title = 'Length (cm)', range= c(min(grspnew.w1()$Length), max(grspnew.w1()$Length)+1)),
             #yaxis = list(title = 'Weight (g)', range = c(0, max(grspnew.w1()$Weight, na.rm = T)*1.05)),
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
             #xaxis = list(title = 'Length (cm)', range= c(min(grspnew.w1()$Length), max(grspnew.w1()$Length)+1)),
             #yaxis = list(title = 'Weight (g)', range = c(0, max(grspnew.w1()$Weight, na.rm = T)*1.05)),
             margin=(list(t=70)),
             showlegend = TRUE)
    p$elementId <- NULL
    p 
  }
  else{
    p <- plot_ly(select_bio(), x = ~Length, y = ~Weight, type = 'scatter',color=~Weight, colors="Spectral",
                 mode = 'markers', marker =list(opacity = 0.5), hoverinfo='text',
                 text=~paste("length:",Length,"cm<br>weight:",Weight)) %>%#, "grams<br>Date:", Date)) %>%
      layout(hovermode=TRUE, title=paste(input$species," Length vs Weight", sep=""),
             #xaxis = list(title = 'Length (cm)', range= c(min(grspnew.w1()$Length), max(grspnew.w1()$Length)+1)),
             #yaxis = list(title = 'Weight (g)', range = c(0, max(grspnew.w1()$Weight, na.rm = T)*1.05)),
             margin=(list(t=80)),
             showlegend = FALSE)
    p$elementId <- NULL
    p
    
  }
})