


# --------------------------------
# tab selection when click on image
# --------------------------------

shinyjs::onclick("fisheryID",  updateTabsetPanel(session, inputId="navbar", selected="tabfish_over"))
shinyjs::onclick("sampleID",  updateTabsetPanel(session, inputId="navbar", selected="tabsample_over"))
shinyjs::onclick("stockID",  updateTabsetPanel(session, inputId="navbar", selected="tabstock_over"))


