# How Technical Education Can Foster Regional Development: An Evaluation of Brazil’s Pronatec Program

This repository includes all the data cleaning, merging and analyses that were done for my Capstone project (undergraduate thesis) at Minerva Schools at KGI, submitted March 2020.  
My goal with this project was to implement a difference-in-differences method to measure the impact of Pronatec on GDP per capita, youth employment, inequality and high school graduation rate at the municipal level in Brazil.

## Table of Contents

1. Data Cleaning
2. Creating Final Dataset
3. Difference-in-Differences Analysis

## Content Summary
**1. Data Cleaning**
The data cleaning folder contains all code to clean the data originally gathered from the Brazilian government in multiple sources. [Atlas of Human Development](https://github.com/giovannachaves/Capstone-Project/blob/113114f90afe768c0f8a156e56a4234e20ac13d7/Data%20Cleaning/Atlas%20of%20Human%20Development.R) explains how data from the Brazilian Atlas of Human Development (2000, 2010) was cleaned. [CCE](https://github.com/giovannachaves/Capstone-Project/blob/master/Data%20Cleaning/CCE.R) does the same for the Central Business Registry (Cadastro Central de Empresas, 2006-2017), [Censo Escolar](https://github.com/giovannachaves/Capstone-Project/blob/master/Data%20Cleaning/Censo%20Escolar.R) for the School Census (1996-2017), [FIRJAN](https://github.com/giovannachaves/Capstone-Project/blob/master/Data%20Cleaning/FIRJAN.R) for the FIRJAN Index for Municipal Development (2005-2016), [GDP](https://github.com/giovannachaves/Capstone-Project/blob/master/Data%20Cleaning/GDP.R) for municipality GDP (2002-2017), [Ideb](https://github.com/giovannachaves/Capstone-Project/blob/master/Data%20Cleaning/Ideb.R) for the Basic Education Development Index (2005-2017), [HDI](https://github.com/giovannachaves/Capstone-Project/blob/master/Data%20Cleaning/HDI.R) for the Human Development Index (1991 - 2010), [PEA and PIA](https://github.com/giovannachaves/Capstone-Project/blob/master/Data%20Cleaning/PEA%20and%20PIA.R) for the Economically Active Population and Working Age Population, respectively. Finally, [Population](https://github.com/giovannachaves/Capstone-Project/blob/master/Data%20Cleaning/Population.R) explains how population data gathered from IBGE (2001-2019) was cleaned, and [RAIS](https://github.com/giovannachaves/Capstone-Project/blob/master/Data%20Cleaning/RAIS.R) for the Annual Social Information Report, one of two databases from the Ministry of Labor and Employment that reports on the labor market.

**2. [Creating Final Dataset](https://github.com/giovannachaves/Capstone-Project/blob/master/Creating%20Final%20Dataset.R)**
Merges all of the aforementioned data to create the base dataset used in the analysis.

**3. [Difference-in-Differences Analysis](https://github.com/giovannachaves/Capstone-Project/blob/master/Difference-in-Differences%20Analysis.R)**
Run a DID model for a continuous treatment definition, looking at the outcome GDP per capita. Analyses for the binary treatment definition and other important outcomes to be included soon.
