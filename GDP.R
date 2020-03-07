# Loading Municipal GDP from 2002-2009 and 2010-2017
PIB_2002_2009 <- read_excel("Desktop/Capstone Data/PIB Município/PIB dos Municípios - base de dados 2002-2009.xls")
PIB_2010_2017 <- read_excel("Desktop/Capstone Data/PIB Município/PIB dos Municípios - base de dados 2010-2017.xls")

# Keeping the relevant variables and binding into one dataset
variables <- cbind("Ano", "Código da Unidade da Federação", "Código do Município", "Nome do Município", "Hierarquia Urbana", "Produto Interno Bruto, \na preços correntes\n(R$ 1.000)", "Produto Interno Bruto per capita, \na preços correntes\n(R$ 1,00)", "Valor adicionado bruto da Agropecuária, \na preços correntes\n(R$ 1.000)", "Valor adicionado bruto da Indústria,\na preços correntes\n(R$ 1.000)", "Valor adicionado bruto dos Serviços,\na preços correntes \n- exceto Administração, defesa, educação e saúde públicas e seguridade social\n(R$ 1.000)", "Valor adicionado bruto da Administração, defesa, educação e saúde públicas e seguridade social, \na preços correntes\n(R$ 1.000)")
PIB_2002_2009 <- as.data.frame(PIB_2002_2009)
PIB_2010_2017 <- as.data.frame(PIB_2010_2017)
PIB_2002_2009 <- subset(PIB_2002_2009, select=variables)
PIB_2010_2017 <- subset(PIB_2010_2017, select=variables)
PIB <- rbind(PIB_2002_2009, PIB_2010_2017)

# Saving dataset
setwd("~/Desktop/Capstone Data/")
write.csv(PIB, "PIB.csv")
