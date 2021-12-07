#------------------------------------
# Fishery inventories
#------------------------------------
# 
# inventory tables require the "all_vessel_" format 
#  
# tables for lan and effort are loaded separately   


##### create DT frame for data #####







# output for CL inventory

output$inventorytable_CL <- DT::renderDT(DT::datatable({data_list()[[1]]
  
  }

, options = list(
  pageLength = 20,autoWidth=T,scrollX=TRUE
),filter = 'top'
))

# output for CE inventory
output$inventorytable_CE <- DT::renderDT(DT::datatable({data_list()[[2]]}
                                                       
                                                       , options = list(
                                                         pageLength = 20,autoWidth=T,scrollX=TRUE
                                                       ),filter = 'top'
))



########
#download widget
########

output$download_filtered_inventorytable_CL <- 
  downloadHandler(
    filename = "cl_inventory_data.csv",
    content = function(file){
      write.csv(cainventory[input[["inventorytable_CL_rows_all"]], ],
                file)
    }
  )
#download widget
output$download_filtered_inventorytable_CE <- 
  downloadHandler(
    filename = "CE_inventory_data.csv",
    content = function(file){
      write.csv(ca[input[["inventorytable_CE_rows_all"]], ],
                file)
    }
  )

