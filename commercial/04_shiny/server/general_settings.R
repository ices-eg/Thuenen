
# --------------------------------
# tab selection when click on image
# --------------------------------

shinyjs::onclick("fisheryID",  updateTabsetPanel(session, inputId="navbar", selected="Fishery overview"))
shinyjs::onclick("sampleID",  updateTabsetPanel(session, inputId="navbar", selected="Sampling overview"))
shinyjs::onclick("stockID",  updateTabsetPanel(session, inputId="navbar", selected="Biology overview"))


# --------------------------------
# modal disclaimer
# --------------------------------

# the modal dialog where the user agree in terms
disclaimer_modal <- modalDialog(
  title = "Terms of use",
  includeHTML("data/DescriptionDisclaimer.txt"),
  easyClose = T, #set to F if you want people to click the "I agree" button
  footer = tagList( downloadButton("report", "Download Disclaimer"),
                    actionButton("ok", "I agree")
  )     
)

# Show the modal on start up ...
showModal(disclaimer_modal)

# ... close when agree
observeEvent(input$ok,{
  removeModal()
})
