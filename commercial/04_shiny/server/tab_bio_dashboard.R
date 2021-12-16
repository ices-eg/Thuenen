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

 
  ##################
  ### Length/Age ###
  ##################
  LengthWeightAgeSpA=reactive({
    if(is.null(input$slideryear1)){
      filter(LengthWeightAge, age!="NA" & Year == maxyear)
    }else{
      filter(LengthWeightAge, age!="NA" & Year == input$slideryear1)}
  })
  
  LengthWeightAgeSpA1=reactive({
    filter(LengthWeightAge, age!="NA")
  })
  output$coeff_table=renderTable({
    if(input$parameter=="None"){    
      alldata=data.frame(Data= "All data", Linf=coeff_all[[1]], K=coeff_all[[2]], t0=coeff_all[[3]])
      yeardata=data.frame(Data= paste(input$slideryear1, "data"), 
                          Linf=coeff_year[which(coeff_year$Year==input$slideryear1), "Linf"],
                          K=coeff_year[which(coeff_year$Year==input$slideryear1), "K"], 
                          t0=coeff_year[which(coeff_year$Year==input$slideryear1), "t0"])
      rbind(alldata, yeardata)
    }else if(input$parameter=="Sex"){
      alldataF=data.frame(Data= paste("All Females"), 
                          Linf=exp(coeff_sex[which(coeff_sex$Parameter =="lnlinf"), "Female"]),
                          K=exp(coeff_sex[which(coeff_sex$Parameter =="lnk"), "Female"]), 
                          t0=-exp(coeff_sex[which(coeff_sex$Parameter =="lnnt0"), "Female"]))
      alldataM=data.frame(Data= paste("All Males"), 
                          Linf=exp(coeff_sex[which(coeff_sex$Parameter =="lnlinf"), "Male"]),
                          K=exp(coeff_sex[which(coeff_sex$Parameter =="lnk"), "Male"]), 
                          t0=-exp(coeff_sex[which(coeff_sex$Parameter =="lnnt0"), "Male"]))
     
   yeardataF=data.frame(Data= paste(input$slideryear1, " Female"), 
                           Linf=exp(coeff_sex_year[which(coeff_sex_year$Parameter =="lnlinf" & coeff_sex_year$Year==input$slideryear1), "Female"]),
                           K=exp(coeff_sex_year[which(coeff_sex_year$Parameter =="lnk"& coeff_sex_year$Year==input$slideryear1), "Female"]), 
                           t0=-exp(coeff_sex_year[which(coeff_sex_year$Parameter =="lnnt0"& coeff_sex_year$Year==input$slideryear1), "Female"]))
      yeardataM=data.frame(Data= paste(input$slideryear1, " Male"), 
                           Linf=exp(coeff_sex_year[which(coeff_sex_year$Parameter =="lnlinf" & coeff_sex_year$Year==input$slideryear1), "Male"]),
                           K=exp(coeff_sex_year[which(coeff_sex_year$Parameter =="lnk"& coeff_sex_year$Year==input$slideryear1), "Male"]), 
                           t0=-exp(coeff_sex_year[which(coeff_sex_year$Parameter =="lnnt0"& coeff_sex_year$Year==input$slideryear1), "Male"]))
      rbind(alldataF, yeardataF,alldataM, yeardataM)
    }else if(input$parameter=="Gear"){
      alldataA=data.frame(Data= paste("All  Groundgear A"), 
                          Linf=coeff_gear[which(coeff_gear$Gear =="GOV 3647 Groundgear A"), "Linf"],
                          K=coeff_gear[which(coeff_gear$Gear =="GOV 3647 Groundgear A"), "K"], 
                          t0=coeff_gear[which(coeff_gear$Gear =="GOV 3647 Groundgear A"), "t0"])
      alldataD=data.frame(Data= paste("All  Groundgear D"), 
                          Linf=coeff_gear[which(coeff_gear$Gear =="GOV 3647 Groundgear D"), "Linf"],
                          K=coeff_gear[which(coeff_gear$Gear =="GOV 3647 Groundgear D"), "K"], 
                          t0=coeff_gear[which(coeff_gear$Gear =="GOV 3647 Groundgear D"), "t0"])
  
      yeardataA=data.frame(Data= paste(input$slideryear1, " Groundgear A"), 
                           Linf=coeff_gear_year[which(coeff_gear_year$Gear =="GOV 3647 Groundgear A" & coeff_gear_year$Year==input$slideryear1), "Linf"],
                           K=coeff_gear_year[which(coeff_gear_year$Gear =="GOV 3647 Groundgear A" & coeff_gear_year$Year==input$slideryear1), "K"], 
                           t0=coeff_gear_year[which(coeff_gear_year$Gear =="GOV 3647 Groundgear A" & coeff_gear_year$Year==input$slideryear1), "t0"])
      yeardataD=data.frame(Data= paste(input$slideryear1, " Groundgear D"), 
                           Linf=coeff_gear_year[which(coeff_gear_year$Gear =="GOV 3647 Groundgear D" & coeff_gear_year$Year==input$slideryear1), "Linf"],
                           K=coeff_gear_year[which(coeff_gear_year$Gear =="GOV 3647 Groundgear D" & coeff_gear_year$Year==input$slideryear1), "K"], 
                           t0=coeff_gear_year[which(coeff_gear_year$Gear =="GOV 3647 Groundgear D" & coeff_gear_year$Year==input$slideryear1), "t0"])
      rbind( alldataA, yeardataA,alldataD, yeardataD)
    }else if(input$parameter=="Division"){
 yeardataVIa=data.frame(Data= paste(input$slideryear1, " VIa division"), 
                             Linf= coeff_div_year[which(coeff_div_year$ICESCODE=="VIa" & coeff_div_year$Year==input$slideryear1), "Linf"],
                             K=coeff_div_year[which(coeff_div_year$ICESCODE=="VIa" & coeff_div_year$Year==input$slideryear1), "K"],
                             t0=coeff_div_year[which(coeff_div_year$ICESCODE=="VIa" & coeff_div_year$Year==input$slideryear1), "t0"])
      yeardataVIIb=data.frame(Data= paste(input$slideryear1, " VIIb division"), 
                              Linf= coeff_div_year[which(coeff_div_year$ICESCODE=="VIIb" & coeff_div_year$Year==input$slideryear1), "Linf"],
                              K=coeff_div_year[which(coeff_div_year$ICESCODE=="VIIb" & coeff_div_year$Year==input$slideryear1), "K"],
                              t0=coeff_div_year[which(coeff_div_year$ICESCODE=="VIIb" & coeff_div_year$Year==input$slideryear1), "t0"])
      yeardataVIIc=data.frame(Data= paste(input$slideryear1, " VIIc division"), 
                              Linf= coeff_div_year[which(coeff_div_year$ICESCODE=="VIIc" & coeff_div_year$Year==input$slideryear1), "Linf"],
                              K=coeff_div_year[which(coeff_div_year$ICESCODE=="VIIc" & coeff_div_year$Year==input$slideryear1), "K"],
                              t0=coeff_div_year[which(coeff_div_year$ICESCODE=="VIIc" & coeff_div_year$Year==input$slideryear1), "t0"])
      yeardataVIIg=data.frame(Data= paste(input$slideryear1, " VIIg division"), 
                              Linf= coeff_div_year[which(coeff_div_year$ICESCODE=="VIIg" & coeff_div_year$Year==input$slideryear1), "Linf"],
                              K=coeff_div_year[which(coeff_div_year$ICESCODE=="VIIg" & coeff_div_year$Year==input$slideryear1), "K"], 
                              t0=coeff_div_year[which(coeff_div_year$ICESCODE=="VIIg" & coeff_div_year$Year==input$slideryear1), "t0"])
      yeardataVIIj=data.frame(Data= paste(input$slideryear1, " VIIj division"), 
                              Linf= coeff_div_year[which(coeff_div_year$ICESCODE=="VIIj" & coeff_div_year$Year==input$slideryear1), "Linf"],
                              K=coeff_div_year[which(coeff_div_year$ICESCODE=="VIIj" & coeff_div_year$Year==input$slideryear1), "K"], 
                              t0=coeff_div_year[which(coeff_div_year$ICESCODE=="VIIj" & coeff_div_year$Year==input$slideryear1), "t0"])
      yeardataVIIk=data.frame(Data= paste(input$slideryear1, " VIIk division"), 
                              Linf= coeff_div_year[which(coeff_div_year$ICESCODE=="VIIk" & coeff_div_year$Year==input$slideryear1 ), "Linf"],
                              K=coeff_div_year[which(coeff_div_year$ICESCODE=="VIIk" & coeff_div_year$Year==input$slideryear1), "K"],
                              t0=coeff_div_year[which(coeff_div_year$ICESCODE=="VIIk" & coeff_div_year$Year==input$slideryear1), "t0"])
      rbind(yeardataVIa, yeardataVIIb, yeardataVIIc, yeardataVIIg, yeardataVIIj, yeardataVIIk)    
    }
  })
  
  output$laplot=renderPlotly({
    LWA_fish=LengthWeightAgeSpA()
    x=seq(0,max(LengthWeightAgeSpA1()$age) , length.out = 199)
    predicted=data.frame(age=x, predlengthAll= vbTyp(x, Linf=coeff_all[[1]], K=coeff_all[[2]], t0=coeff_all[[3]]),
                         predlengthYear= vbTyp(x, 
                                               Linf= coeff_year[which(coeff_year$Year==input$slideryear1), "Linf"],
                                               K=coeff_year[which(coeff_year$Year==input$slideryear1), "K"], 
                                               t0=coeff_year[which(coeff_year$Year==input$slideryear1), "t0"]),
                         predlengthF= vbTyp(x, Linf=exp(coeff_sex[which(coeff_sex$Parameter =="lnlinf"), "Female"]),
                                            K=exp(coeff_sex[which(coeff_sex$Parameter =="lnk"), "Female"]), 
                                            t0=-exp(coeff_sex[which(coeff_sex$Parameter =="lnnt0"), "Female"])),
                         predlengthM= vbTyp(x, Linf=exp(coeff_sex[which(coeff_sex$Parameter =="lnlinf"), "Male"]),
                                            K=exp(coeff_sex[which(coeff_sex$Parameter =="lnk"), "Male"]), 
                                            t0=-exp(coeff_sex[which(coeff_sex$Parameter =="lnnt0"), "Male"])),
                         predlengthFYear= vbTyp(x, Linf=exp(coeff_sex_year[which(coeff_sex_year$Parameter =="lnlinf" & coeff_sex_year$Year==input$slideryear1), "Female"]),
                                                K=exp(coeff_sex_year[which(coeff_sex_year$Parameter =="lnk"& coeff_sex_year$Year==input$slideryear1), "Female"]), 
                                                t0=-exp(coeff_sex_year[which(coeff_sex_year$Parameter =="lnnt0"& coeff_sex_year$Year==input$slideryear1), "Female"])),
                         predlengthMYear= vbTyp(x, Linf=exp(coeff_sex_year[which(coeff_sex_year$Parameter =="lnlinf" & coeff_sex_year$Year==input$slideryear1), "Male"]),
                                                K=exp(coeff_sex_year[which(coeff_sex_year$Parameter =="lnk"& coeff_sex_year$Year==input$slideryear1), "Male"]), 
                                                t0=-exp(coeff_sex_year[which(coeff_sex_year$Parameter =="lnnt0"& coeff_sex_year$Year==input$slideryear1), "Male"])),
                         predlengthGearA= vbTyp(x, 
                                                Linf= coeff_gear[which(coeff_gear$Gear =="GOV 3647 Groundgear A"), "Linf"],
                                                K=coeff_gear[which(coeff_gear$Gear =="GOV 3647 Groundgear A"), "K"],
                                                t0=coeff_gear[which(coeff_gear$Gear =="GOV 3647 Groundgear A"), "t0"]),
                         predlengthGearAyear= vbTyp(x, 
                                                    Linf=coeff_gear_year[which(coeff_gear_year$Gear =="GOV 3647 Groundgear A" & coeff_gear_year$Year==input$slideryear1), "Linf"],
                                                    K=coeff_gear_year[which(coeff_gear_year$Gear =="GOV 3647 Groundgear A" & coeff_gear_year$Year==input$slideryear1), "K"],
                                                    t0=coeff_gear_year[which(coeff_gear_year$Gear =="GOV 3647 Groundgear A" & coeff_gear_year$Year==input$slideryear1), "t0"]),
                         predlengthGearD= vbTyp(x, 
                                                Linf= coeff_gear[which(coeff_gear$Gear =="GOV 3647 Groundgear D"), "Linf"],
                                                K=coeff_gear[which(coeff_gear$Gear =="GOV 3647 Groundgear D"), "K"],
                                                t0=coeff_gear[which(coeff_gear$Gear =="GOV 3647 Groundgear D"), "t0"]),
                         predlengthGearDyear= vbTyp(x, 
                                                    Linf=coeff_gear_year[which(coeff_gear_year$Gear =="GOV 3647 Groundgear D" & coeff_gear_year$Year==input$slideryear1), "Linf"],
                                                    K=coeff_gear_year[which(coeff_gear_year$Gear =="GOV 3647 Groundgear D" & coeff_gear_year$Year==input$slideryear1), "K"],
                                                    t0=coeff_gear_year[which(coeff_gear_year$Gear =="GOV 3647 Groundgear D" & coeff_gear_year$Year==input$slideryear1), "t0"]),
                         predlengthVIa= vbTyp(x, 
                                              Linf= coeff_div[which(coeff_div$ICESCODE=="VIa"), "Linf"][[1]],
                                              K=coeff_div[which(coeff_div$ICESCODE=="VIa"), "K"][[1]],
                                              t0=coeff_div[which(coeff_div$ICESCODE=="VIa"), "t0"][[1]]),
                         predlengthVIaYear= vbTyp(x, 
                                                  Linf= coeff_div_year[which(coeff_div_year$ICESCODE=="VIa" & coeff_div_year$Year==input$slideryear1), "Linf"][[1]],
                                                  K=coeff_div_year[which(coeff_div_year$ICESCODE=="VIa" & coeff_div_year$Year==input$slideryear1), "K"][[1]],
                                                  t0=coeff_div_year[which(coeff_div_year$ICESCODE=="VIa" & coeff_div_year$Year==input$slideryear1), "t0"][[1]]),
                         predlengthVIIb= vbTyp(x, 
                                               Linf= coeff_div[which(coeff_div$ICESCODE=="VIIb"), "Linf"][[1]],
                                               K=coeff_div[which(coeff_div$ICESCODE=="VIIb" ), "K"][[1]],
                                               t0=coeff_div[which(coeff_div$ICESCODE=="VIIb"), "t0"][[1]]),
                         predlengthVIIbYear= vbTyp(x, 
                                                   Linf= coeff_div_year[which(coeff_div_year$ICESCODE=="VIIb" & coeff_div_year$Year==input$slideryear1), "Linf"][[1]],
                                                   K=coeff_div_year[which(coeff_div_year$ICESCODE=="VIIb" & coeff_div_year$Year==input$slideryear1), "K"][[1]], 
                                                   t0=coeff_div_year[which(coeff_div_year$ICESCODE=="VIIb" & coeff_div_year$Year==input$slideryear1 ), "t0"][[1]]),
                         predlengthVIIc= vbTyp(x, 
                                               Linf= coeff_div[which(coeff_div$ICESCODE=="VIIc"), "Linf"][[1]],
                                               K=coeff_div[which(coeff_div$ICESCODE=="VIIc"), "K"][[1]], 
                                               t0=coeff_div[which(coeff_div$ICESCODE=="VIIc"), "t0"][[1]]),
                         predlengthVIIcYear= vbTyp(x, 
                                                   Linf= coeff_div_year[which(coeff_div_year$ICESCODE=="VIIc" & coeff_div_year$Year==input$slideryear1), "Linf"][[1]],
                                                   K=coeff_div_year[which(coeff_div_year$ICESCODE=="VIIc" & coeff_div_year$Year==input$slideryear1 ), "K"][[1]], 
                                                   t0=coeff_div_year[which(coeff_div_year$ICESCODE=="VIIc" & coeff_div_year$Year==input$slideryear1 ), "t0"][[1]]),
                         predlengthVIIg= vbTyp(x, 
                                               Linf= coeff_div[which(coeff_div$ICESCODE=="VIIg"), "Linf"][[1]],
                                               K=coeff_div[which(coeff_div$ICESCODE=="VIIg"), "K"][[1]],
                                               t0=coeff_div[which(coeff_div$ICESCODE=="VIIg"), "t0"][[1]]),
                         predlengthVIIgYear= vbTyp(x, 
                                                   Linf= coeff_div_year[which(coeff_div_year$ICESCODE=="VIIg" & coeff_div_year$Year==input$slideryear1 ), "Linf"][[1]],
                                                   K=coeff_div_year[which(coeff_div_year$ICESCODE=="VIIg" & coeff_div_year$Year==input$slideryear1 ), "K"][[1]],
                                                   t0=coeff_div_year[which(coeff_div_year$ICESCODE=="VIIg" & coeff_div_year$Year==input$slideryear1), "t0"][[1]]),
                         predlengthVIIj= vbTyp(x, 
                                               Linf= coeff_div[which(coeff_div$ICESCODE=="VIIj"), "Linf"][[1]],
                                               K=coeff_div[which(coeff_div$ICESCODE=="VIIj"), "K"][[1]], 
                                               t0=coeff_div[which(coeff_div$ICESCODE=="VIIj"), "t0"][[1]]),
                         predlengthVIIjYear= vbTyp(x, 
                                                   Linf= coeff_div_year[which(coeff_div_year$ICESCODE=="VIIj" & coeff_div_year$Year==input$slideryear1), "Linf"][[1]],
                                                   K=coeff_div_year[which(coeff_div_year$ICESCODE=="VIIj" & coeff_div_year$Year==input$slideryear1), "K"][[1]],
                                                   t0=coeff_div_year[which(coeff_div_year$ICESCODE=="VIIj" & coeff_div_year$Year==input$slideryear1), "t0"][[1]]),
                         predlengthVIIk= vbTyp(x, 
                                               Linf= coeff_div[which(coeff_div$ICESCODE=="VIIk"), "Linf"][[1]],
                                               K=coeff_div[which(coeff_div$ICESCODE=="VIIk"), "K"][[1]], 
                                               t0=coeff_div[which(coeff_div$ICESCODE=="VIIk"), "t0"][[1]]),
                         predlengthVIIkYear= vbTyp(x, 
                                                   Linf= coeff_div_year[which(coeff_div_year$ICESCODE=="VIIk" & coeff_div_year$Year==input$slideryear1 ), "Linf"][[1]],
                                                   K=coeff_div_year[which(coeff_div_year$ICESCODE=="VIIk" & coeff_div_year$Year==input$slideryear1), "K"][[1]],
                                                   t0=coeff_div_year[which(coeff_div_year$ICESCODE=="VIIk" & coeff_div_year$Year==input$slideryear1), "t0"][[1]])
    )
    
    
    if(dim(LWA_fish)[1]==0){
      p=NULL
    }else if(input$parameter=="None"){
      p=plot_ly() %>% 
        add_trace(data=LWA_fish, x = ~age, y = ~length, type="scatter", mode="markers",
                  text=~paste("Length:",length,"cm","<br>Age:",age),
                  hoverinfo = 'text',marker =list(opacity = 0.5), showlegend = FALSE) %>% 
        layout(hovermode="closest", title=paste("Length vs Age"),
               xaxis = list(title = 'Age (years)', zeroline=FALSE,
                            range= c(min(LengthWeightAgeSpA1()$age)-.1,max(LengthWeightAgeSpA1()$age)+1)),
               yaxis = list(title = 'Length (cm)', zeroline=FALSE,
                            range = c(0, max(LengthWeightAgeSpA1()$length, na.rm = T)*1.05)),
               margin=(list(t=70)), showlegend = TRUE)
      if(all(!is.na(predicted$predlengthAll))){
        p = p %>%
          add_trace(data=predicted, x = ~age, y = ~predlengthAll, type="scatter", mode = "lines",
                    line = list(shape="spline", color="grey"), name="All data fit", hoverinfo="none")
      }
      if(all(!is.na(predicted$predlengthYear))){
        p = p %>%
          add_trace(data=predicted, x = ~age, y = ~predlengthYear, type="scatter", mode = "lines",
                    line = list(shape="spline",color="blue"), name=paste(input$slideryear1, "data fit"), hoverinfo="none")
      }
      p$elementId <- NULL
    }else if(input$parameter=="Sex"){
      p=plot_ly() %>% 
        add_trace(data=LWA_fish, x = ~age, y = ~length, type="scatter", mode="markers",
                  color = ~obs.sex, colors=c('U'='#F8766D','F'='#00BFC4','M'='#B79F00'),
                  text=~paste("Length:",length,"cm","<br>Age:",age, "<br>Sex:", obs.sex),
                  hoverinfo = 'text',marker =list(opacity = 0.5), showlegend = TRUE) %>% 
        layout(hovermode="closest", title=paste("Length vs Age (points coloured by sex)"),
               xaxis = list(title = 'Age (years)', zeroline=FALSE,
                            range= c(min(LengthWeightAgeSpA1()$age)-.1,max(LengthWeightAgeSpA1()$age)+1)),
               yaxis = list(title = 'Length (cm)', zeroline=FALSE,
                            range = c(0, max(LengthWeightAgeSpA1()$length, na.rm = T)*1.05)),
               margin=(list(t=70)))
      if(all(!is.na(predicted$predlengthFYear))){
        p = p %>%
          add_trace(data=predicted, x = ~age, y = ~predlengthFYear, type="scatter", mode = "lines",
                    line = list(shape="spline", color="#00BFC4"), name = "F", hoverinfo="none")
      }
      if(all(!is.na(predicted$predlengthMYear))){
        p = p %>%
          add_trace(data=predicted, x = ~age, y = ~predlengthMYear, type="scatter", mode = "lines",
                    line = list(shape="spline", color="#B79F00"), name = "M", hoverinfo="none")
      }
      p$elementId <- NULL
    }else if(input$parameter=="Gear"){
      p=plot_ly() %>% 
        add_trace(data=LWA_fish, x = ~age, y = ~length, type="scatter", mode="markers",
                  color = ~fldGearDescription, colors=c("#F8766D","#00BFC4"),
                  text=~paste("Length:",length,"cm","<br>Age:",age, "<br>Gear type:",fldGearDescription),
                  hoverinfo = 'text',marker =list(opacity = 0.5), showlegend = TRUE) %>%
        layout(hovermode="closest", title=paste("Length vs Age (points coloured by gear)"),
               yaxis = list(title = 'Length (cm)', range= c(min(LengthWeightAgeSpA1()$length), 
                                                            max(LengthWeightAgeSpA1()$length)+1), zeroline = FALSE),
               xaxis = list(title = 'Age', range = c(-0.1, max(LengthWeightAgeSpA1()$age, na.rm = T)*1.05), 
                            zeroline = FALSE), margin=(list(t=70)), showlegend = TRUE) 
      if(all(!is.na(predicted$predlengthGearAyear))){
        p = p %>%
          add_trace(data=predicted, x = ~age, y = ~predlengthGearAyear, type="scatter", mode = "lines",
                    line = list(shape="spline", color="#F8766D"),name="GOV 3647 Groundgear A", hoverinfo="none")
      }
      if(all(!is.na(predicted$predlengthGearDyear))){
        p = p %>%
          add_trace(data=predicted, x = ~age, y = ~predlengthGearDyear, type="scatter", mode = "lines",
                    line = list(shape="spline", color="#00BFC4"),name="GOV 3647 Groundgear D", hoverinfo="none")  
      }
      p$elementId <- NULL
    }else if(input$parameter=="Division"){
      if(is.null(input$division1)){
        ## "Select a Division"
        p=NULL
      }else{
        grspnew.w2 = filter(LengthWeightAgeSpA(), ICESCODE %in% c(input$division1))
        if(dim(grspnew.w2)[1]==0){
          p=NULL 
        }else{
          
          p=plot_ly() %>% 
            add_trace(data=grspnew.w2, x = ~age, y = ~length, type="scatter", mode="markers",color= ~ICESCODE,
                      colors=c('VIa'='#F8766D','VIIb'='#00BFC4','VIIc'='#B79F00','VIIg'='#619CFF','VIIj'='#00BA38','VIIk'='#F564E3'),
                      text=~paste("Length:",length,"cm","<br>Age:",age, "<br>Division:",ICESCODE),
                      hoverinfo = 'text',marker =list(opacity = 0.5), showlegend = TRUE) %>% 
            layout(hovermode="closest", title=paste("Age vs Length (points coloured by divisions)"),
                   yaxis = list(title = 'Length (cm)', range= c(min(LengthWeightAgeSpA1()$length), 
                                                                max(LengthWeightAgeSpA1()$length)+1), zeroline = FALSE),
                   xaxis = list(title = 'Age', range = c(-0.1, max(LengthWeightAgeSpA1()$age, na.rm = T)*1.05), 
                                zeroline = FALSE), margin=(list(t=70)), showlegend = TRUE)
          
          if(all(!is.na(predicted$predlengthVIaYear)) & "VIa" %in% input$division1 ){
            p=p %>% add_trace(data=predicted, x = ~age, y = ~predlengthVIaYear, type="scatter", mode = "lines",
                              line = list(shape="spline", color='#F8766D'), name=paste(input$slideryear1,"VIa data fit"), hoverinfo="none")}  
          if(all(!is.na(predicted$predlengthVIIbYear))& "VIIb" %in% input$division1 ){
            p=p %>% add_trace(data=predicted, x = ~age, y = ~predlengthVIIbYear, type="scatter", mode = "lines",
                              line = list(shape="spline", color='#00BFC4'), name=paste(input$slideryear1,"VIIb data fit"), hoverinfo="none")}  
          if(all(!is.na(predicted$predlengthVIIcYear))& "VIIc" %in% input$division1 ){
            p=p %>% add_trace(data=predicted, x = ~age, y = ~predlengthVIIcYear, type="scatter", mode = "lines",
                              line = list(shape="spline", color='#B79F00'), name=paste(input$slideryear1,"VIIc data fit"), hoverinfo="none")}  
          if(all(!is.na(predicted$predlengthVIIgYear))& "VIIg" %in% input$division1 ){
            p=p %>% add_trace(data=predicted, x = ~age, y = ~predlengthVIIgYear, type="scatter", mode = "lines",
                              line = list(shape="spline", color='#619CFF'), name=paste(input$slideryear1,"VIIg data fit"), hoverinfo="none")}  
          if(all(!is.na(predicted$predlengthVIIjYear))& "VIIj" %in% input$division1 ){
            p=p %>% add_trace(data=predicted, x = ~age, y = ~predlengthVIIjYear, type="scatter", mode = "lines",
                              line = list(shape="spline", color='#00BA38'), name=paste(input$slideryear1,"VIIj data fit"), hoverinfo="none")}  
          if(all(!is.na(predicted$predlengthVIIkYear))& "VIIk" %in% input$division1 ){
            p=p %>% add_trace(data=predicted, x = ~age, y = ~predlengthVIIkYear, type="scatter", mode = "lines",
                              line = list(shape="spline", color='#F564E3'), name=paste(input$slideryear1,"VIIk data fit"), hoverinfo="none")}  
          
          p$elementId <- NULL
        }
      }
    }
    if(is.null(p)) plotly_empty(type = "scatter", mode="markers") else p
  })
  
  
 
 

  
  output$latab=renderUI({
    if(dim(LengthWeightAgeSpA1())[1]==0){
      h3(paste("No Age data available for", species, sep=" "))
    }else if(dim(LengthWeightAgeSpA())[1]==0){
      h3(paste("No Age data available for", species, "for", input$slideryear1, ".Try another year", sep= " "))
    }else{
      list(
        plotlyOutput("laplot"),
        fluidRow(column(5,h4("Life Parameters"),
                        tableOutput("coeff_table"),offset = 3))
                # ,
                # column(3,h4("Predictions using VBGM"),
                                ##### numericInput("length", "Enter Fish length:", value=30, min = 10, max = 80),
                               ## tableOutput("predage"),
                               #tableOutput("probofage")) ,
        ####tags$small("*age range based on age readings and lengths 
                                                  # taken from fish sampled at ports and the stockbook"),
                        ## plotOutput("age_hist"))
        ,
        "Data fits are modelled using Von Bertalanffy Growth Models",HTML("<br>"),
        "If data fits are missing this is due to either no data available or small sample sizes",HTML("<br>"),
        "*Filtering also available on the RHS by clicking on the legend entry when a parameter is chosen")
    }
  })
  
##### Bio dashboard text and graphs
  output$fish_biology<- renderText({
    as.character(Supp_table[which(Supp_table[,"Fish_Code"] %in% input$species),"biology"])
  })
  
# add fish images to "Bio" sub table  
  output$fish_drawing<- renderImage({
    filename <- paste("www/FishSketches/", Supp_table[which(Supp_table[,"Fish_Code"] %in% input$species),"Fish_Code"], ".png", sep="")
    list(src = filename, filetype = "png",width= "auto", height = 150)}, deleteFile = FALSE)
  
 