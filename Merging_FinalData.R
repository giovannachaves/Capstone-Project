setwd("~/Desktop/Capstone Data/Cleaned Data")
library(readr)
library(dplyr)
library(tidyr)
library(reshape2)

# Final Atlas data
Atlas <- read_csv("Atlas.csv")
Atlas$code <- Atlas$Codmun7
Atlas$year <- Atlas$ANO
Atlas$name <- Atlas$Município
Atlas$state <- Atlas$UF

vars_atlas <- c("year","code", "name", "state", "Codmun6", "GINI","pesotot", "pesoRUR", "pesourb", "MULH15A19", "MULH20A24", "MULH25A29", "HOMEM15A19", "HOMEM20A24", "HOMEM25A29", "IDHM", "IDHM_E", "IDHM_R", "MULHERTOT", "HOMEMTOT", "T_MED18A24", "T_FREQ18A24", "RDPC", "RDPC1", "RDPC2", "RDPC3", "RDPC4", "RDPC5", "RDPC10", "PIND", "PMPOB", "T_DES1517", "T_DES1824", "T_DES2529", "TRABCC", "P_FORMAL")
Atlas <- subset(Atlas, select = vars_atlas)

# Final CCE data
CCE <- read_csv("CCE.csv")
CCE$name <- toupper(CCE$nome)
CCE$code <- CCE$codigo_ibge
CCE$state <- CCE$codigo_uf
CCE$privatesector_employment_count <- CCE$`Pessoal ocupado assalariado`
CCE$privatesector_monthly_salary <- CCE$`Salário médio mensal`

vars_CCE <- c("year","code", "name", "state", "privatesector_employment_count", "privatesector_monthly_salary")
CCE <- subset(CCE, select = vars_CCE)

# Final IDEB data
Ideb <- read_csv("Ideb.csv")
Ideb$name <- toupper(Ideb$nome)
Ideb$code <- Ideb$codigo_ibge
Ideb$state <- Ideb$codigo_uf
Ideb$Ideb_Level <- Ideb$Level
Ideb$Ideb_School_Federal <- Ideb$Federal
Ideb$Ideb_School_State <- Ideb$Estadual
Ideb$Ideb_School_Municipal <- Ideb$Municipal
Ideb$Ideb_School_Public <- Ideb$Pública

vars_Ideb <- c("year","code", "name", "state", "Ideb_School_Federal", "Ideb_School_State", "Ideb_School_Municipal", "Ideb_School_Public")
Ideb <- subset(Ideb, select = vars_Ideb)

# Final HDI data
IDH <- read_csv("IDH.csv")
IDH$name <- toupper(IDH$nome)
IDH$code <- IDH$codigo_ibge
IDH$state <- IDH$codigo_uf

vars_IDH <- c("year","code", "name", "state", "IDH")
IDH <- subset(IDH, select = vars_IDH)

# Final IFDM data
IFDM <- read_csv("IFDM.csv")
IFDM$name <- toupper(IFDM$Município)
IFDM$Codmun6 <- IFDM$Código

# Using municipality codes 
translate_vars <- c("Codmun6", "code", "name", "state")
translate_df <- subset(Atlas, select = translate_vars)
translate_df <- translate_df %>% distinct()
IFDM <- merge(IFDM, translate_df)

vars_IFDM <- c("year","code", "name", "state", "IFDM", "IFDM_Income")
IFDM <- subset(IFDM, select = vars_IFDM)

# Final School Census municipality-level data
school_data <- read_csv("municipalities.csv")
school_data$code <- school_data$municipality
school_data$school_edtech <- school_data$edtech_share
school_data$school_federal <- school_data$school_type1_share
school_data$school_state <- school_data$school_type2_share
school_data$school_municipal <- school_data$school_type3_share
school_data$school_private <- school_data$school_type4_share
school_data$school_urban <- school_data$school_location1_share
school_data$school_rural <- school_data$school_location2_share
school_data$school_nosewage <- school_data$sewage0_share
school_data$school_publicsewage <- school_data$sewage1_share
school_data$school_simplesewage <- school_data$sewage2_share
school_data$school_computer_count <- school_data$computer_avg
school_data$school_staff_count <- school_data$staff_avg
school_data$school_EJA <- school_data$EJA_share
school_data$school_internet <- school_data$internet_share

school_data <- merge(school_data, translate_df)
vars_school <- c("year","code","name", "state", "school_count","school_edtech","school_federal", "school_state", "school_municipal", "school_private", "school_urban", "school_rural", "school_nosewage", "school_publicsewage", "school_simplesewage", "school_computer_count", "school_staff_count", "school_EJA", "school_internet")
school_data <- subset(school_data, select = vars_school)

# Final unemployment data
PEA_PIA <- read_csv("PEA_PIA.csv")
PEA_PIA$name <- toupper(PEA_PIA$nome)
PEA_PIA$code <- PEA_PIA$codigo_ibge
PEA_PIA$state <- PEA_PIA$codigo_uf

vars_PEAPIA <- c("year","code", "name", "state", "youth_employment", "youth_activity_rate")
PEA_PIA <- subset(PEA_PIA, select = vars_PEAPIA)

# Final GDP data
PIB <- read_csv("PIB.csv")
PIB$year <- PIB$Ano
PIB$name <- toupper(PIB$`Nome do Município`)
PIB$code <- PIB$`Código do Município`
PIB$state <- PIB$`Código da Unidade da Federação`
PIB$GDP <- PIB$`Produto Interno Bruto, a preços correntes(R$ 1.000)`
PIB$GDP_capita <- PIB$`Produto Interno Bruto per capita, a preços correntes(R$ 1,00)`
PIB$GDP_farming <- PIB$`Valor adicionado bruto da Agropecuária, a preços correntes(R$ 1.000)`
PIB$GDP_industry <- PIB$`Valor adicionado bruto da Indústria,a preços correntes(R$ 1.000)`
PIB$GDP_services <- PIB$`Valor adicionado bruto dos Serviços,a preços correntes - exceto Administração, defesa, educação e saúde públicas e seguridade social(R$ 1.000)`
PIB$GDP_government <- PIB$`Valor adicionado bruto da Administração, defesa, educação e saúde públicas e seguridade social, a preços correntes(R$ 1.000)`

vars_PIB <- c("year","code", "name", "state", "GDP", "GDP_capita", "GDP_farming", "GDP_industry", "GDP_services", "GDP_government")
GDP <- subset(PIB, select = vars_PIB)

# Final population data
population <- read_csv("population.csv")
population$name <- toupper(population$municipality_name)
population$name <- gsub("\\(.{2}\\)$", "", population$name)
population$code <- population$municipality_cod
population$population <- as.numeric(population$population)
population$name <- trimws(population$name, "r")
population <- merge(translate_df, population)

vars_population <- c("year","code","name","state","population")
population <- subset(population, select = vars_population)

# Final RAIS data
RAIS <- read_csv("RAIS.csv")
RAIS$Codmun6 <- RAIS$Município
RAIS$youth_employment_count <- RAIS$youth_employment_total
RAIS$total_employment_count <- RAIS$employment_total

vars_RAIS <- c("year","Codmun6", "youth_employment_count", "total_employment_count")
RAIS <- subset(RAIS, select = vars_RAIS)

# Adding 7-digit code to RAIS
RAIS <- merge(RAIS, translate_df)
vars_RAIS <- c("year","code","name","state","youth_employment_count", "total_employment_count")
RAIS <- subset(RAIS, select = vars_RAIS)
RAIS$youth_employment_share <- RAIS$youth_employment_count / RAIS$total_employment_count

vars_atlas2 <- c("year","code", "name", "state","GINI","pesotot", "pesoRUR", "pesourb", "MULH15A19", "MULH20A24", "MULH25A29", "HOMEM15A19", "HOMEM20A24", "HOMEM25A29", "IDHM", "IDHM_E", "IDHM_R", "MULHERTOT", "HOMEMTOT", "T_MED18A24", "T_FREQ18A24", "RDPC", "RDPC1", "RDPC2", "RDPC3", "RDPC4", "RDPC5", "RDPC10", "PIND", "PMPOB", "T_DES1517", "T_DES1824", "T_DES2529", "TRABCC", "P_FORMAL")
Atlas <- subset(Atlas, select = vars_atlas2)

# Now that all dataframes have the same identifying variables, we can merge
final_data <- merge(Atlas, IDH)
final_data <- merge(final_data, PEA_PIA, all = TRUE)
final_data <- merge(final_data, RAIS, all = TRUE)
final_data <- merge(final_data, school_data, all = TRUE)
final_data <- merge(final_data, IFDM, all = TRUE)
final_data <- merge(final_data, population, all = TRUE)
final_data <- merge(final_data, GDP, all = TRUE)
final_data <- merge(final_data, Ideb, all = TRUE)
final_data <- merge(final_data, CCE, all = TRUE)

# Saving final dataset
write.csv(final_data, "final_data.csv")