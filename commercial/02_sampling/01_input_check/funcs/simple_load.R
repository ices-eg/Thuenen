simple.load <- function() {
  filenames <- list.files(path=getwd(),
                          pattern=".*csv")
  
  ## Create list of data frame names without the ".csv" part 
  names <- gsub('.{4}$', '', filenames)
  ## Load all files as separate data frames 
  for(i in names){
    filepath <- file.path(getwd(),paste(i,".csv",sep=""))
    assign(i, read.delim(filepath,
                         # colClasses=c("character","factor",rep("numeric",4)),
                         sep = ";"))
  }
}


