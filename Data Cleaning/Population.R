# Loading population data
library(readxl)
populacao <- read_excel("~/Desktop/Capstone Data/Data Sources/Population/populacao.xlsx")
populacao <- as.data.frame(populacao)
populacao = populacao[-(1:3),]

# Adjusting variable names
populacao$municipality_cod <- populacao$...2
populacao$municipality_name <- populacao$...3
populacao$populacao2001 <- populacao$...4
populacao$populacao2002 <- populacao$...5
populacao$populacao2003 <- populacao$...6
populacao$populacao2004 <- populacao$...7
populacao$populacao2005 <- populacao$...8
populacao$populacao2006 <- populacao$...9
populacao$populacao2008 <- populacao$...10
populacao$populacao2009 <- populacao$...11
populacao$populacao2011 <- populacao$...12
populacao$populacao2012 <- populacao$...13
populacao$populacao2013 <- populacao$...14
populacao$populacao2014 <- populacao$...15
populacao$populacao2015 <- populacao$...16
populacao$populacao2016 <- populacao$...17
populacao$populacao2017 <- populacao$...18
populacao$populacao2018 <- populacao$...19
populacao$populacao2019 <- populacao$...20

# Selecting variables
variables <- cbind("municipality_cod", "municipality_name", "populacao2001", "populacao2002", "populacao2003", "populacao2004", "populacao2005", "populacao2006", "populacao2008", "populacao2009", "populacao2011", "populacao2012", "populacao2013", "populacao2014", "populacao2015", "populacao2016", "populacao2017", "populacao2018", "populacao2019")
population <- subset(populacao, select=variables)

# Changing data format and deleting white spaces
population <- gather(population, year, population, "populacao2001":"populacao2019", factor_key=TRUE)
population$year <- gsub("populacao", "", population$year)

# Saving dataset
setwd("~/Desktop/Capstone Data/Cleaned Data")
write.csv(population, "population.csv")
