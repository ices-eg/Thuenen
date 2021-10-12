
library(shiny)

shinyUI(
    
    
    #navBarPage
    navbarPage(
        theme = "style.css",
        collapsible = TRUE,
        id = "navbar",
        useShinyjs(),
        fluid = TRUE,
        windowTitle= tags$head(
            tags$link(rel = "icon", type = "image/png", href = "logo_small.png"),
            tags$title("Thünen OF")
            ),
        position = "fixed-top",
        header = tags$style(
            ".navbar-right { float: right !important;}",
            "body {padding-top: 55px;}"),
        tabPanel(id ="tabHome", title = introBox(icon("home")),
                 
                 fluidRow(
                     column(12,align="center",
                            img( src="logo_regular.png", height=100)
                     )),
                 br(), 
                 fluidRow(
                     column(12,align="center",
                            includeHTML('www/home.html') 
                     )),
                 br(),
                 fluidRow(
                     column(12, align="center",
                            div(style="display: inline-block;",class= "image", img(id="fisheryID", src="fishery_logo.png", height=250, style="cursor:pointer;margin-right:40px;")),
                            div(style="display: inline-block;",class= "image", img(id ="sampleID", src="sampling_logo.png", height=250, style="cursor:pointer;margin-right:40px;")),
                            div(style="display: inline-block;",class= "image", img(id ="stockID", src="stock_logo.png", height=250, style="cursor:pointer;margin-right:40px;"))
        
                 )),
        ),
        # -----------------------------------
        # Fisheries overview tab
        # -----------------------------------
        navbarMenu(
            "Fischerei",
            
            # -----------------------------------
            # fleet overview
            # -----------------------------------
            tabPanel(id="tabInventory", "Flotte"
      
            ),
         # -----------------------------------
        # landings overview
        # -----------------------------------
        tabPanel(id="tabInventory", "Anlandungen"
                 
        )),
        
        
                     
        # -----------------------------------
        # Sampling overview tab
        # -----------------------------------
        navbarMenu(
            "Beprobung",
            
            # -----------------------------------
            # Data explore subtab
            # -----------------------------------
            tabPanel(id="tabInventory", "Reisebericht"
                     
            )),
        # -----------------------------------
        # Stock overview tab
        # -----------------------------------
        navbarMenu(
            "Biologie",
            
            # -----------------------------------
            # Data explore subtab
            # -----------------------------------
            tabPanel(id="tabInventory", "Fischarten"
                     
            ))
        
            
    ) # end Navbarpage
)# end of ui