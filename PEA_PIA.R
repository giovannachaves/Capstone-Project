setwd("~/Desktop/Capstone Data/Data Sources/IBGE Desemprego/")
library(tidyr)
library(readr)

# Loading unemployment data from IBGE
PEA <- list()
PEAcsv <- dir(pattern = "^PEA_")
for (k in 1:length(PEAcsv)){
  PEA[[k]] <- read.csv(PEAcsv[k], sep = ";")
}

variables_PEA  <- cbind("nome","Codigo_6","year","youth_employment")

for (k in 1:27){
  PEA[[k]]$Codigo_6 <- PEA[[k]]$"Cod..Loc."
  PEA[[k]]$nome <- PEA[[k]]$"Divisões.Territoriais"
  PEA[[k]]$"2010" <- PEA[[k]]$"X16.a.29.anos..2010"
  PEA[[k]]$"2000" <- PEA[[k]]$"X16.a.29.anos..2000"
  PEA[[k]] <- gather(PEA[[k]], year, youth_employment, "2010":"2000", factor_key=TRUE)
  PEA[[k]] <- subset(PEA[[k]], select = variables_PEA)
}

municipios_cod <- read_csv("~/Desktop/Capstone Data/Cleaned Data/municipios_cod.csv")
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

for (k in 1:27){
  PEA[[k]] <- merge(PEA[[k]], municipios_cod, by='nome')
  PEA[[k]] = PEA[[k]][PEA[[k]]$codigo_uf == getmode(PEA[[k]]$codigo_uf),]
}

PEA_Complete <- do.call(rbind,PEA)

# Repeating the same process for the second variable
PIA <- list()
PIAcsv <- dir(pattern = "^PIA_")
for (k in 1:length(PIAcsv)){
  PIA[[k]] <- read.csv(PIAcsv[k], sep = ";")
}

variables_PIA  <- cbind("nome","Codigo_6","year","youth_activity_rate")

for (k in 1:27){
  PIA[[k]]$Codigo_6 <- PIA[[k]]$"Cod..Loc."
  PIA[[k]]$nome <- PIA[[k]]$"Divisões.Territoriais"
  PIA[[k]]$"2010" <- PIA[[k]]$"X16.a.29.anos..2010"
  PIA[[k]]$"2000" <- PIA[[k]]$"X16.a.29.anos..2000"
  PIA[[k]] <- gather(PIA[[k]], year, youth_activity_rate, "2010":"2000", factor_key=TRUE)
  PIA[[k]] <- subset(PIA[[k]], select = variables_PIA)
}

for (k in 1:27){
  PIA[[k]] <- merge(PIA[[k]], municipios_cod, by='nome')
  PIA[[k]] = PIA[[k]][PIA[[k]]$codigo_uf == getmode(PIA[[k]]$codigo_uf),]
}

PIA_Complete <- do.call(rbind,PIA)

# Putting both variables into one dataset
PEA_PIA <- merge(PEA_Complete, PIA_Complete)
variables_PEA_PIA <- cbind("nome", "codigo_ibge", "codigo_uf", "year", "youth_employment", "youth_activity_rate")
PEA_PIA <- subset(PEA_PIA, select=variables_PEA_PIA)

setwd("~/Desktop/Capstone Data/Cleaned Data")
write.csv(PEA_PIA, "PEA_PIA.csv")