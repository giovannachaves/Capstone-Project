setwd("~/Desktop/Capstone Data/Data Sources/Índice FIRJAN de Desenvolvimento Municipal/")
library(readr)

# Loading IFDM Income score and general IFDM score
IFDM_Income <- read_csv("IFDM - Emprego.xlsx - IFDM_ER.csv")
IFDM <- read_csv("IFDM - Geral.xlsx - IFDM_G.csv")

# Changing data from wide to long
IFDM_Income <- gather(IFDM_Income, year, IFDM_Income, "2005":"2016", factor_key=TRUE)
IFDM <- gather(IFDM, year, IFDM, "2005":"2016", factor_key=TRUE)

# Putting both variables into one dataset
IFDM_Complete <- merge(IFDM, IFDM_Income)

# Keeping relevant variables
vars <- c("nome", "codigo_ibge", "codigo_uf", "year","IFDM")
IDM <- subset(IDM, select = vars)

# Changing 0 to NA to not influence model
IFDM_Complete$IFDM[which(IFDM_Complete$IFDM == 0)] <- NA
IFDM_Complete$IFDM_Income[which(IFDM_Complete$IFDM_Income == 0)] <- NA

# Saving the dataset
setwd("~/Desktop/Capstone Data/Cleaned Data")
write.csv(IFDM_Complete, "IFDM.csv")