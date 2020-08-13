setwd("~/Desktop/Capstone Data/Data Sources/IDH")

# Using the same mode function as before
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

# Loading the municipality codes
municipios_cod <- read_csv("~/Desktop/Capstone Data/Cleaned Data/municipios_cod.csv")

# Loading HDI data
# IDH[[k]] = IDH_State
IDH <- list()
listcsv <- dir(pattern = "*.csv")
for (k in 1:length(listcsv)){
  IDH[[k]] <- read.csv(listcsv[k], sep = ",")
}

# Adjust data
for (k in 1:27){
  IDH[[k]] <- IDH[[k]][-nrow(IDH[[k]]),]
  IDH[[k]]$nome <- IDH[[k]]$Localidade
  IDH[[k]] <- merge(IDH[[k]], municipios_cod, by='nome')
  IDH[[k]] = IDH[[k]][IDH[[k]]$codigo_uf == getmode(IDH[[k]]$codigo_uf),]
}

# Merging all the state data
IDH <- do.call(rbind,IDH)

library(tidyr)

# Transforming from wide to long format, to be compatible with independent variables
IDH <- gather(IDH, year, IDH, "1991":"2010", factor_key=TRUE)

# Keeping relevant variables
variables <- cbind("nome", "codigo_ibge", "codigo_uf", "year", "IDH")
IDH <- subset(IDH, select=variables)

# Saving the dataset
setwd("~/Desktop/Capstone Data/")
write.csv(IDH, "IDH.csv")
