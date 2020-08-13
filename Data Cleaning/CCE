setwd("~/Desktop/Capstone Data/Data Sources/Cadastro Central de Empresas/")

# Loading all years of private sector information
# ldf1[[k]] = CCE_state
ldf1 <- list()
list1csv <- dir(pattern = "*.csv")
for (k in 1:length(list1csv)){
  ldf1[[k]] <- read.csv(list1csv[k], sep = ",")
}

# Selecting relevant variables
library(tidyr)
variables  <- cbind("Nome","Localidade","year","valores")

# Transforming from wide to long format only for 
for (k in 1:27){
  ldf1[[k]] <- gather(ldf1[[k]], year, valores, X2006:X2017, factor_key=TRUE)
  ldf1[[k]]$Variables <- rep(0, length(ldf1[[k]]$Localidade))
  ldf1[[k]]$Variables[which(ldf1[[k]]$Nome == "Pessoal ocupado")] <- 1
  ldf1[[k]]$Variables[which(ldf1[[k]]$Nome == "Pessoal ocupado assalariado")] <- 1
  ldf1[[k]]$Variables[which(ldf1[[k]]$Nome == "Salário médio mensal")] <- 1
  ldf1[[k]] <- ldf1[[k]][which(ldf1[[k]]$Variables == 1),]
  ldf1[[k]] <- subset(ldf1[[k]], select = variables)
  ldf1[[k]] <- spread(ldf1[[k]], Nome, valores)
  }

# Loading database with municipality and state codes
library(readr)
municipios_cod <- read_csv("~/Desktop/Capstone Data/Cleaned Data/municipios_cod.csv")
# Creating function to extract the mode
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

# Some municipalities have repeated names across states
# This means when we merge, we have municipality name with more than 1 matching state code
# This loop adds for each k the state code that is the most repeated within ldf1[[k]]
for (k in 1:27){
  ldf1[[k]]$nome <- ldf1[[k]]$Localidade
  ldf1[[k]] <- merge(ldf1[[k]], municipios_cod, by='nome')
  ldf1[[k]] = ldf1[[k]][ldf1[[k]]$codigo_uf == getmode(ldf1[[k]]$codigo_uf),]
}

# Merging all the state data
CCE <- do.call(rbind,ldf1)

# Selecting variables
variables1 <- cbind("nome", "codigo_ibge", "codigo_uf", "year", "Pessoal ocupado", "Pessoal ocupado assalariado", "Salário médio mensal")
CCE <- subset(CCE, select=variables1)

# Removing X from the years
CCE$year <- gsub("X", "", CCE$year)

# Saving dataset
setwd("~/Desktop/Capstone Data/Cleaned Data")
write.csv(CCE, "CCE.csv")
