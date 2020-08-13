setwd("~/Desktop/Capstone Data/Data Sources/Atlas do Desenvolvimento Humano/")

# Loading Atlas 2013 data
library(readxl)
Atlas_2013 <- read_excel("atlas2013_dadosbrutos_pt.xlsx", sheet = "MUN 91-00-10")

# Reducing to relevant variables
vars <- c("ANO", "UF", "Codmun6", "Codmun7", "Município", "GINI","pesotot", "pesoRUR", "pesourb", "MULH15A19", "MULH20A24", "MULH25A29", "HOMEM15A19", "HOMEM20A24", "HOMEM25A29", "IDHM", "IDHM_E", "IDHM_R", "MULHERTOT", "HOMEMTOT", "T_MED18A24", "T_FREQ18A24", "RDPC", "RDPC1", "RDPC2", "RDPC3", "RDPC4", "RDPC5", "RDPC10", "PIND", "PMPOB")
Atlas_2013 <- subset(Atlas_2013, select = vars)

# Loading Atlas 2000 and 1991 data 
AtlasBrasil_Consulta <- read_excel("AtlasBrasil_Consulta.xlsx", sheet = "Atlas Brasil")
AtlasBrasil_Consulta = AtlasBrasil_Consulta[-1,]

AtlasBrasil_Consulta <- AtlasBrasil_Consulta[which((AtlasBrasil_Consulta$year == 2000 & AtlasBrasil_Consulta$year2 == 2000 & AtlasBrasil_Consulta$year3 == 2000 & AtlasBrasil_Consulta$year4 == 2000 & AtlasBrasil_Consulta$year5 == 2000) | (AtlasBrasil_Consulta$year == 1991 & AtlasBrasil_Consulta$year2 == 1991 & AtlasBrasil_Consulta$year3 == 1991 & AtlasBrasil_Consulta$year4 == 1991 & AtlasBrasil_Consulta$year5 == 1991) | (AtlasBrasil_Consulta$year == 2010 & AtlasBrasil_Consulta$year2 == 2010 & AtlasBrasil_Consulta$year3 == 2010 & AtlasBrasil_Consulta$year4 == 2010 & AtlasBrasil_Consulta$year5 == 2010)),]

# Keeping relevant variables
AtlasBrasil_Consulta$Codmun7 <- AtlasBrasil_Consulta$Código
AtlasBrasil_Consulta$ANO <- AtlasBrasil_Consulta$year
AtlasBrasil_Consulta$Município <- AtlasBrasil_Consulta$Espacialidades
vars_ <- c("Codmun7", "ANO", "Município", "T_DES1517", "T_DES1824", "T_DES2529", "TRABCC", "P_FORMAL")
AtlasBrasil_Consulta <- subset(AtlasBrasil_Consulta, select = vars_)
AtlasBrasil_Consulta$Município <- toupper(AtlasBrasil_Consulta$Município)

# Merging and saving dataset
Atlas_2013 <- merge(Atlas_2013, AtlasBrasil_Consulta)
setwd("~/Desktop/Capstone Data/Cleaned Data")
write.csv(Atlas_2013, "Atlas.csv")
