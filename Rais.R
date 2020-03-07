library(readr)
library(tidyr)
setwd("~/Desktop/Capstone Data/Data Sources/RAIS")

# Loading youth employment data for 2000, 2001 and 2002-2018
RAIS <- read_csv("~/Desktop/Capstone Data/Data Sources/RAIS/RAIS - RAIS.csv")
RAIS_2001 <- read_csv("RAIS - 2001 - RAIS - 2001.csv")
RAIS_2000 <- read_csv("RAIS - 2000 - RAIS - 2000.csv")

# Creating year variables in order to merge
RAIS_2001$year <- rep(2001, length(RAIS_2001$Município))
RAIS_2000$year <- rep(2000, length(RAIS_2000$Município))
RAIS_2000 <- subset(RAIS_2000, select = c("Município", "year", "youth_employment_total"))

# Changing data format 
RAIS <- gather(RAIS, year, youth_employment_total, "2018":"2002", factor_key=TRUE)

# Merging 
RAIS_youth <- rbind(RAIS_2000, RAIS_2001, RAIS)

# Loading total employment data for 2000, 2001 and 2002-2018
RAIS_Total <- read_csv("RAIS Total - RAIS Total.csv")
RAIS_Total_2000 <- read_csv("RAIS Total - 2000 - RAIS Total - 2000.csv")
RAIS_Total_2001 <- read_csv("RAIS Total - 2001 - RAIS Total - 2001.csv")

# Creating year variables
RAIS_Total_2001$year <- rep(2001, length(RAIS_Total_2001$Município))
RAIS_Total_2000$year <- rep(2000, length(RAIS_Total_2000$Município))
RAIS_Total_2001$employment_total <- RAIS_Total_2001$"2001"
RAIS_Total_2000$employment_total <- RAIS_Total_2000$"2000"
RAIS_Total_2001 <- subset(RAIS_Total_2001, select = c("Município", "year", "employment_total"))
RAIS_Total_2000 <- subset(RAIS_Total_2000, select = c("Município", "year", "employment_total"))

# Changing data format
RAIS_Total <- gather(RAIS_Total, year, employment_total, "2018":"2002", factor_key=TRUE)

# Merging total unemployment data
RAIS_total <- rbind(RAIS_Total_2000, RAIS_Total_2001, RAIS_Total)

# Merging all data
RAIS_final <- merge(RAIS_youth, RAIS_total)

# Saving cleaned dataset
setwd("~/Desktop/Capstone Data/Cleaned Data")
write.csv(RAIS_final, "RAIS.csv")