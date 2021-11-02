


# --------------------------------
# tab selection when click on image
# --------------------------------

shinyjs::onclick("fisheryID",  updateTabsetPanel(session, inputId="navbar", selected="Fishery overview"))
shinyjs::onclick("sampleID",  updateTabsetPanel(session, inputId="navbar", selected="Sampling overview"))
shinyjs::onclick("stockID",  updateTabsetPanel(session, inputId="navbar", selected="Biology overview"))


