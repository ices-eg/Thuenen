#------------------------------------
# Sampled trips overviews and analysis
#------------------------------------
#
# 
# 
#   


##### Interactive Map - tracks of fished trips and fishing areas #####


# Create the map - leaflet 
output$trip_map <- renderLeaflet({
  leaflet() %>% 
    addProviderTiles(providers$Esri.OceanBasemap) %>% 
    setView(lng = 13.0000, lat = 54.800, zoom = 7)
})

##### in progress
#add ICES areas as shapes
# observe({
#  proxy<-leafletProxy("map", data = filter_df())
#  proxy%>%clearShapes()
#  if (input$rec){
#    proxy%>% addPolygons(data=ices.rect, weight=.4,fillOpacity = .1,color = 'grey',group = 'ices_squares',label = ~paste0(ICESNAME),highlight = highlightOptions(weight = 3, color = "red",
#                                                                                                                                                                 bringToFront = TRUE))
#  }
# })