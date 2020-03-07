# Loading the already cleaned datasets for the School Census, post-2007 and pre-2007
# Pre-2007 required a lot of manual cleaning because survey changed every year in terms of:
# Variable names, variable type, encoding

setwd("~/Desktop/Capstone Data/Data Sources/Censo Escolar/")
schools_post <- read.csv("schools_post2.csv", sep = ",")
schools_pre <- read.csv("schools_post1.csv", sep = ",")

# Recoding municipalities because codes pre-2007 are different than post-2007
schools_pre$CODMUNIC <- as.character(schools_pre$CODMUNIC)

fun  <- function(x) {
  # Find the correct positions
  s_chars <- strsplit(x, "")[[1]]
  
  # Put all chars into a vector
  vector_chars <- c(s_chars[c(1,2)], s_chars[seq(8, 12)])
  
  # Paste them onto a string
  out <- paste(vector_chars, collapse="")
  return(out)
}

schools_pre$CODMUNIC <- sapply(schools_pre$CODMUNIC, fun)

# Standardizing variable names
schools_post$year <- schools_post$NU_ANO_CENSO
schools_post$school_code <- schools_post$CO_ENTIDADE
schools_post$state <- schools_post$CO_UF
schools_post$municipality <- schools_post$CO_MUNICIPIO
schools_post$school_type <- schools_post$TP_DEPENDENCIA
schools_post$school_location <- schools_post$TP_LOCALIZACAO
schools_post$sewage <- rep(0, length(schools_post$IN_ESGOTO_REDE_PUBLICA))
schools_post$sewage[which(schools_post$IN_ESGOTO_REDE_PUBLICA == 1)] <- 1
schools_post$sewage[which(schools_post$IN_ESGOTO_FOSSA == 1)] <- 2
schools_post$sewage[which(schools_post$IN_ESGOTO_INEXISTENTE == 1)] <- 0
schools_post$computer_num <- schools_post$QT_COMPUTADOR
schools_post$highschool_reg <- schools_post$IN_COMUM_MEDIO_MEDIO
schools_post$vet <- schools_post$IN_COMUM_PROF
schools_post$EJA <- schools_post$IN_EJA
schools_post$staff_num <- schools_post$QT_FUNCIONARIOS
schools_post$internet <- schools_post$IN_INTERNET
schools_post$highschool_tech_int <- schools_post$IN_COMUM_MEDIO_INTEGRADO
schools_post$water_treated <- schools_post$IN_AGUA_FILTRADA
schools_post$EJA_fund <- schools_post$IN_COMUM_EJA_FUND
schools_post$EJA_highschool <- schools_post$IN_COMUM_EJA_MEDIO
schools_post$prison <- schools_post$IN_LOCAL_FUNC_UNID_PRISIONAL
schools_post$private_type <- schools_post$TP_CATEGORIA_ESCOLA_PRIVADA
schools_post$private_systems <- schools_post$IN_MANT_ESCOLA_PRIVADA_SIND
schools_post$private_systems[which(is.na(schools_post$private_systems))] <- 0

schools_pre$year <- schools_pre$ANO
schools_pre$school_code <- schools_pre$MASCARA
schools_pre$state <- schools_pre$UF
schools_pre$municipality <- schools_pre$CODMUNIC
schools_pre$school_type <- schools_pre$DEP
schools_pre$school_location <- schools_pre$LOC
schools_pre$sewage <- rep(0, length(schools_pre$ESG_PUB))
schools_pre$sewage[which(schools_pre$ESG_PUB == 's')] <- 1
schools_pre$sewage[which(schools_pre$ESG_FOSS == 's')] <- 2
schools_pre$sewage[which(schools_pre$ESG_INEX == 's')] <- 0
schools_pre$computer_num <- schools_pre$num_computadores
schools_pre$highschool_reg <- schools_pre$NIVELMED
schools_pre$vet <- schools_pre$IN_COMUM_PROF
schools_pre$EJA <- schools_pre$SUPL_AVA
schools_pre$staff_num <- schools_pre$FUNCION
schools_pre$internet <- schools_pre$INTERNET
schools_pre$highschool_tech_int <- schools_pre$NIVM_INT
schools_pre$water_treated <- schools_pre$AGUA_FIL
schools_pre$EJA_fund <- schools_pre$ID_EJA_FUNDAMENTAL
schools_pre$EJA_highschool <- schools_pre$ID_EJA_MEDIO
schools_pre$prison <- schools_pre$ID_LOCAL_FUNC_PRISIONAL
schools_pre$private_type <- schools_pre$DESC_CATEGORIA_ESCOLA_PRIVADA
schools_pre$private_systems <- schools_pre$ID_MANT_ESCOLA_PRIVADA_SIND
schools_pre$private_systems[which(is.na(schools_pre$private_systems))] <- 0

# Selecting the final variables
variables_final  <- cbind("year","school_code","state","municipality","school_type","school_location","sewage","computer_num","highschool_reg","vet","staff_num","EJA","internet","highschool_tech_int","water_treated", "EJA_fund", "EJA_highschool", "prison", "private_type", "private_systems")
schools_post <- subset(schools_post, select=variables_final)
schools_pre <- subset(schools_pre, select=variables_final)

# Changing factor levels from character to numeric
schools_pre$state <- as.numeric(as.character(factor(schools_pre$state,levels=c('Rondonia', 'Acre', 'Amazonas', 'Roraima', 'Para', 'Amapa', 'Tocantins', 'Maranhao', 'Piaui', 'Ceara', 'Rio Grande do Norte', 'Paraiba', 'Pernambuco', 'Alagoas', 'Sergipe', 'Bahia', 'Minas Gerais', 'Espirito Santo', 'Rio de Janeiro', 'Sao Paulo', 'Parana', 'Santa Catarina', 'Rio Grande do Sul', 'Mato Grosso do Sul', 'Mato Grosso', 'Goias', 'Distrito Federal'), labels=c(11, 12, 13, 14, 15, 16, 17, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 35, 41, 42, 43, 50, 51, 52, 53))))
schools_pre$school_type <- as.numeric(as.character(factor(schools_pre$school_type,levels=c('Federal', 'Estadual', 'Municipal', 'Particular'), labels=c(1, 2, 3, 4))))
schools_pre$school_location <- as.numeric(as.character(factor(schools_pre$school_location,levels=c('Urbana', 'Rural'), labels=c(1, 2))))
schools_pre$highschool_reg <- as.numeric(as.character(factor(schools_pre$highschool_reg,levels=c('n', 's'), labels=c(0, 1))))
schools_pre$EJA <- as.numeric(as.character(factor(schools_pre$EJA,levels=c('n', 's'), labels=c(0, 1))))
schools_pre$highschool_tech_int <- as.numeric(as.character(factor(schools_pre$highschool_tech_int,levels=c('n', 's'), labels=c(0, 1))))
schools_pre$water_treated <- as.numeric(as.character(factor(schools_pre$water_treated,levels=c('n', 's'), labels=c(0, 1))))

# Merging and saving dataset 
schools <- rbind(schools_pre, schools_post)
setwd("~/Desktop/Capstone Data/Cleaned Data/")
write.csv(schools, "schools_final.csv")

# Defining treatment
schools$internet <- as.numeric(as.character(schools$internet))

# Schools with PBP offer VET OR integrated AS WELL AS regular high school AND ARE NOT System S, Federal or Private!
schools$PBP <- rep(0, length(schools$school_code))
schools$PBP[which((schools$highschool_tech_int==1 | schools$vet==1) & (schools$highschool_reg==1) & (schools$private_systems!=1 & schools$school_type!=1 & schools$school_type!=4))] <- 1

# Creating municipal dataset with the variables we want
municipalities <- schools %>% group_by(year, municipality) %>% dplyr::summarize(school_count = n(), PBP = sum(PBP), sewage0 = sum(sewage==0), sewage1 = sum(sewage==1), sewage2 = sum(sewage==2), school_type1 = sum(school_type==1), school_type2 = sum(school_type==2), school_type3 = sum(school_type==3), school_type4 = sum(school_type==4), school_location1 = sum(school_location==1), school_location2 = sum(school_location==2), computer_num = sum(computer_num), staff_num = sum(staff_num), EJA = sum(EJA), internet = sum(internet), water_treated0 = sum(water_treated == 0) ,water_treated1 = sum(water_treated == 1), water_treated2 = sum(water_treated == 2))

municipalities$edtech_share <- ((municipalities$PBP)/(municipalities$school_count))*100
# percentage of schools in the municipality offering technical education (eligble for PBP)
municipalities$sewage0_share <- ((municipalities$sewage0)/(municipalities$school_count))*100
# percentage of schools in the municipality with no sewage
municipalities$sewage1_share <- ((municipalities$sewage1)/(municipalities$school_count))*100
# percentage of schools in the municipality with public sewage
municipalities$sewage2_share <- ((municipalities$sewage2)/(municipalities$school_count))*100
# percentage of schools in the municipality with fossa sewage
municipalities$school_type1_share <- ((municipalities$school_type1)/(municipalities$school_count))*100
# percentage of schools in the municipality that are federal
municipalities$school_type2_share <- ((municipalities$school_type2)/(municipalities$school_count))*100
# percentage of schools in the municipality that are state
municipalities$school_type3_share <- ((municipalities$school_type3)/(municipalities$school_count))*100
# percentage of schools in the municipality that are municipal
municipalities$school_type4_share <- ((municipalities$school_type4)/(municipalities$school_count))*100
# percentage of schools in the municipality that are private
municipalities$school_location1_share <- ((municipalities$school_location1)/(municipalities$school_count))*100
# percentage of schools in the municipality that are in urban areas
municipalities$school_location2_share <- ((municipalities$school_location2)/(municipalities$school_count))*100
# percentage of schools in the municipality that are in rural areas
municipalities$computer_avg <- ((municipalities$computer_num)/(municipalities$school_count))
# average number of computers per school in the municipality
municipalities$staff_avg <- ((municipalities$staff_num)/(municipalities$school_count))
# average number of staff per school in the municipality
municipalities$EJA_share <- ((municipalities$EJA)/(municipalities$school_count))*100
# percentage of schools in the municipality offering EJA
municipalities$internet_share <- ((municipalities$internet)/(municipalities$school_count))*100
# percentage of schools in the municipality with internet

# Saving dataset at the municipality level
write.csv(municipalities, "municipalities.csv")

# Visually mean of treatment 
library(plyr)
mean_share <-ddply(municipalities, .(year), summarize, mean=mean(edtech_share))
ggplot(mean_share, aes(x=factor(year), y=mean)) + geom_point(size=2) +  ggtitle("Share of technical education schools") + xlab("Year") + ylab("Mean of share of school offering technical education") + theme(axis.text.x = element_text(angle = 45, hjust = 1))
