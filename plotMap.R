#####plotMap
## load required packages
library(readxl)
library(rgdal)
library(hyfo)
library(plyr)
library(ggplot2)

filePath <- file.choose()






















# Indicator name must be capitalized as title, e.g., "Abc of Def and Ghg..." 

# import from readxl read_excel
getProvData <- function(filePath, indicator, year, ...) {
  data <- read_excel(filePath, ...)
  #locate the target column from indicator, using ambiguous match
  indiIndex <- grep(indicator, colnames(data))
  #check input indicator name, if it's correct or if the table contains
  checkIndi(indiIndex)
  indiCol <- colnames(data)[indiIndex]
  message(paste('"', indicoL, '" found', sep = ""))
  
  # Take target year
  data1 <- data[data[, "Year"] == year,]
  # Take target column
  provData <- data.frame(data1[, 'Province'], data1[, indiIndex])
  colnames(provData) <- c("Province", indiCol)
  
  # delete China and NA rows
  provData <- provData[(provData[,1] != "China") & !is.na(provData[, 1]), ]
  # For factors, special attetion needs to be paid, the levels.
  provData$Province <- factor(provData$Province, levels = unique(provData$Province),
                              ordered = TRUE)
  
}


checkIndi <- function(indiIndex) {
  if (length(indiIndex) == 0) {
    stop("No indicator found in the excel, check the file for correct indicator name.")
  } else if (length(indiIndex) > 1) {
    stop("More than one indicator match your input, put more detailed indicator name.")
  } 
}



#s
shapePath <- "C:\\Users\\User\\Google Drive\\CWR General Data\\CN provinces map\\CHN_adm1.shp"

china <- shp2cat(shapePath)


# to generate costumized palette
# plot(ra, col = colorRampPalette(c("white", "red"))(31))

# result should be a result from getProvData, a data frame with 1st column
# Provinces, and 2nd column the data.
plotProvData <- function(provData, china) {
  # here the shape file should be attached with the package
  # province orders are different for provData and the china shape file
  orderedProvData <- provData[match(china@data$NAME_1, provData$Province), ]
  
  plotName <- colnames(provData)[2]
  # attach provData to corresponding postion
  china@data$value <- orderedProvData[, 2]
  
  colorbar <- colorRampPalette(c("white", "yellow", "orange", "red"))(31)
  
  # now the colors needs to be modified
  colorbar_new <- colorbar[match(china@data$value, sort(provData[, 2]))]
  
  
  plot(china, col = colorbar_new)
  
}