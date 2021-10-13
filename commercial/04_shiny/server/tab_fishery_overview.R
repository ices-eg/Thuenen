#mapdata <- readRDS("Data/mapdata26022019.rds")
#SpAggdata <- readRDS("Data/SpAggdata26022019.rds")
#sp_data_gp <- readRDS("Data/sp_data_gp_20190306.rds")

#------------------------------------
# Fishery overview
#------------------------------------
# tabPanel( 
#  title = "Flotte", 
#  fluidRow(
#    br(),
    
##### Infographics  #####
## Box1
totalfish <- reactive({
  sum(stnInView()$RaisedNo,na.rm=TRUE)
})
catch <- reactive({
  formatC(totalfish(), digits = 1, format= "d",mode = "integer", big.mark = ",")
})

## Box2
biggestkg <-  reactive({
  max(stnInView()$CatchKg, na.rm=TRUE)
})
maxKG <- reactive({
  formatC(biggestkg(),digits = 1, format = "d", mode = "integer", big.mark = ",")
})

## Box3
totalswept <- reactive({
  formatC(sum(stnInView()$AreaKmSq),format="d", big.mark=",")
})
kmtext <- HTML("<p>Swept area (km <sup>2</sup> ) </p>")
output$box1 <- renderValueBox({valueBox(value = catch(),subtitle="Total Number of fish surveyed", icon = icon("fas fa-anchor"))})#,  "fas fa-calculator"
output$box2 <- renderValueBox({valueBox("largest survey catch (kg)", value = maxKG(),icon =icon("fas fa-trophy"))})#fas fa-trophy"
output$box3 <- renderValueBox({valueBox( value = totalswept(), subtitle = kmtext,icon = icon("fas fa-ship"))})
