setwd("~/Desktop/Capstone Data/Data Sources/Ideb")

# Using the same mode function as before
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

# Loading the municipality codes
municipios_cod <- read_csv("~/Desktop/Capstone Data/Cleaned Data/municipios_cod.csv")

# Loading IDEB scores
# IDEB[[k]] = IDEB_state
IDEB <- list()
listcsv <- dir(pattern = "*.csv")
for (k in 1:length(listcsv)){
  IDEB[[k]] <- read.csv(listcsv[k], sep = ",")
}

# Adjust data
for (k in 1:27){
  IDEB[[k]]$nome <- Ideb[[k]]$Localidade
  IDEB[[k]] <- merge(IDEB[[k]], municipios_cod, by='nome')
  IDEB[[k]] = IDEB[[k]][IDEB[[k]]$codigo_uf == getmode(IDEB[[k]]$codigo_uf),]
}
 
# Merging all the state data
IDEB <- do.call(rbind,IDEB)

library(tidyr)

# Transforming from wide to long format, to be compatible with independent variables
IDEB <- gather(IDEB, year, Ideb, "2005.0":"2017.0", factor_key=TRUE)

# Keeping relevant variables
variables <- cbind("nome", "codigo_ibge", "codigo_uf", "year", "Ideb","Level","Nome")
IDEB <- subset(IDEB, select=variables)
IDEB <- IDEB[!(IDEB$Level=='Anos iniciais'),]

# Converting from long to wide the subset of school types
Ideb <- spread(Ideb, Nome, Ideb)

# Saving the dataset
setwd("~/Desktop/Capstone Data/Cleaned Data")
write.csv(Ideb,"Ideb.csv")
