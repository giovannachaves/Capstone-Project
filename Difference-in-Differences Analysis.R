# Loading all required libraries
library(readr)
library(skimr)
library(ggplot2)
library(knitr)
library(plyr)
library(sandwich)
library(lmtest)
library(tidyverse)
library(caret)
library(glmnet)
library(olsrr)
library(mdscore)
library(car)
library(quantreg)

setwd("~/Desktop/Capstone Data/Cleaned Data")

# Outcomes: GDP per capita (2002 - 2017)

final_data <- read_csv("final_data.csv")

# Dropping observations prior to 1997 since there is no treatment data
final_data <- final_data[which(final_data$year != 1991),]
final_data <- final_data[which(final_data$year != 2018),]
final_data <- final_data[which(final_data$year != 2019),]

# Creating a time dummy for pre- and post-treatment years
final_data$pre_post = ifelse(final_data$year >= 2008, 1, 0)

# The difference-in-differences estimator is the interaction between treatment and post-period
# Since treatment is continuous, we interact it with the treatment variable (edtech)
final_data$did_continuous = final_data$pre_post * final_data$school_edtech

# Testing common trends assumption!
ggplot(data = final_data, aes(year, GDP_capita_ln, color = treated_unit_factor)) + stat_summary(geom = 'line') + geom_vline(xintercept = 2008) + xlim(2000, 2016) + xlab("Year") + ylab("Log GDP per capita") + theme_minimal()
ggplot(final_data, aes(year, GDP_capita_ln, color = treated_unit_factor)) + scale_color_brewer() + geom_jitter(size=1) + ggtitle("Distribution of GDP per capita pre- and post-treatment") + xlab("0 Pre-Treatment vs. Post-Treatment 1") + ylab("Log GDP per capita") + theme_minimal()

# Testing the homoskedasticity and normality assumptions
reg = lm(GDP_capita ~ did_continuous, data = final_data)
summary(reg)
plot(reg) #diagnostic plots
bptest(reg) # formally detects heteroskedasticity, still present

# Density plot
ggplot(final_data, aes(x=GDP_capita)) + geom_density(alpha=0.6) + ggtitle("Distribution of GDP per capita") + xlab("GDP per capita") + ylab("Density") + theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Descriptive Stats
na_rm = TRUE
quantile(final_data$GDP_capita, na.rm=na_rm)
mean(final_data$GDP_capita, na.rm=na_rm)
median(final_data$GDP_capita, na.rm=na_rm)

# Creating log variable
final_data$GDP_capita_ln <- log(final_data$GDP_capita)
final_data$GDP_capita_ln[which(is.nan(final_data$GDP_capita_ln))] = NA

# New density plot
ggplot(final_data, aes(x=GDP_capita_ln)) + geom_density(alpha=0.6) + ggtitle("Distribution of log GDP per capita") + xlab("Log GDP per capita") + ylab("Density") + theme(axis.text.x = element_text(angle = 25, hjust = 1))

# Testing for autocorrelation
reg_Log = lm(GDP_capita_ln ~ did_continuous, data = final_data)
durbinWatsonTest(reg_Log)
# Yes, we should use time and space fixed effects and HAC SE.

# Model with ln(GDP)!
summary(reg_Log)
coeftest(reg_Log, vcov = vcovHAC(reg_Log))

# Log model with municipality and year fixed effects, robust standard errors
reg_fixed = lm(GDP_capita_ln ~ did_continuous + year + code, data = final_data)
summary(reg_fixed)
coeftest(reg_fixed, vcov = vcovHAC(reg_fixed))

# Pariwise correlation matrix to check if any variables are particularly strong predictors
sapply(final_data, class)
cor_matrix <- cor(final_data[sapply(final_data, function(x) !is.factor(x) & !is.character(x))], use = "pairwise.complete.obs")

# Can't use Atlas covariates as they are only available in 2000 and 2010, so they limit my analysis to only 2 years.
# school_municipal as a proxy for poverty (if high, poverty is high!)
# school_urban as a proxy for % of population in urban and rural areas
# school_publicsewage as proxy for extreme poverty in the city (if low, poverty is high!)
# GDP_farming/GDP (% of GDP that comes from farming) 
final_data$GDP_farming_share <- final_data$GDP_farming / final_data$GDP
# GDP_industry/GDP (% of GDP that comes from industry) 
final_data$GDP_industry_share <- final_data$GDP_industry / final_data$GDP
# GDP_services/GDP (% of GDP that comes from services) 
final_data$GDP_services_share <- final_data$GDP_services / final_data$GDP
# private_sector_employment_count / total_employment_count (share of private sector employment as a proxy for private sector investment)
final_data$privatesector_employment_share <- (final_data$privatesector_employment_count)/(final_data$total_employment_count)
final_data$privatesector_employment_share[which(is.nan(final_data$privatesector_employment_share))] = NA
final_data$privatesector_employment_share[which(final_data$privatesector_employment_share == Inf)] = NA
# IDEB_Public measures quality of education, proxy for qualification of high school graduates 

# Log model with all covariates!
reg_cov = lm(GDP_capita_ln ~ did_continuous + year + code + school_municipal + school_urban + school_publicsewage + GDP_farming_share + GDP_industry_share + privatesector_employment_share + Ideb_School_Public, data = final_data)
summary(reg_cov)
coeftest(reg_cov, vcov = vcovHAC(reg_cov))

# VIF - Multicollinearity
vif(reg_cov)

# Calculating means
na_rm = TRUE
mean(final_data$GDP_capita, na.rm=na_rm)
mean(final_data$school_edtech, na.rm=na_rm)
mean(final_data$GDP_capita[which(final_data$school_edtech > 0)], na.rm=na_rm)
mean(final_data$population[which(final_data$school_edtech > 0)], na.rm=na_rm)

# Calculating quantile regression
qs <- 1:9/10
qr2 <- rq(GDP_capita_ln ~ did_continuous + year + code + school_municipal + school_urban + school_publicsewage + GDP_farming_share + GDP_industry_share + privatesector_employment_share + Ideb_School_Public, data = final_data, tau = qs)
summary(qr2)
coef(qr2)

# Quantile vs. Coeff plot
ggplot(final_data, aes(did_continuous,GDP_capita_ln)) + geom_point() + geom_quantile(quantiles = qs) + ggtitle("Quantile regression") + xlab("Share of technical education (% of schools)") + ylab("Log GDP per capita")
plot(summary(qr2), parm="did_continuous", main = "Quantiles vs. Coefficient estimates",)
