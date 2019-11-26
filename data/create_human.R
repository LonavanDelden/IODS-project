#Lona van Delden
#19/11/2019
#Data wrangling for the next weeks

#read in the data and explore
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")
str(hd)
str(gii)
dim(hd)
dim(gii)
summary(hd)
summary(gii)

#Rename variables
library(tidyverse)
library(dplyr)
names(hd)
hd_1 <- hd %>% 
  rename(
    hdi.rank = HDI.Rank,
    hdi = Human.Development.Index..HDI.,
    life = Life.Expectancy.at.Birth,
    exp_edu = Expected.Years.of.Education,
    mean_edu = Mean.Years.of.Education,
    GNI = Gross.National.Income..GNI..per.Capita,
    GNI_rank = GNI.per.Capita.Rank.Minus.HDI.Rank
    )
names(hd_1)
names(gii)
gii_1 <- gii %>% 
  rename(
    gii.rank = GII.Rank,
    gii = Gender.Inequality.Index..GII.,
    mat.mor_rat = Maternal.Mortality.Ratio,
    birth.rate = Adolescent.Birth.Rate,
    par.repr = Percent.Representation.in.Parliament,
    f.sec_edu = Population.with.Secondary.Education..Female.,
    m.sec_edu = Population.with.Secondary.Education..Male.,
    f.labour = Labour.Force.Participation.Rate..Female.,
    m.labour = Labour.Force.Participation.Rate..Male.
  )
names(gii_1)

# Create two new variables "f_m.sec_edu" and "f_m.labour"
gii_1$f_m.sec_edu <- gii_1$f.sec_edu / gii_1$m.sec_edu
gii_1$f_m.labour <- gii_1$f.labour / gii_1$m.labour
str(gii_1)

#join the data sets with "Country" as the identifier to become "human" data sets
join_by <- "Country"
human <- inner_join(hd_1, gii_1, by = join_by)
str(human)
setwd("C:/Users/lonav/Documents/IODS-project/data")
library(openxlsx)
write.table(human, file = "human.csv", append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = TRUE, qmethod = "double",
            fileEncoding = "")

#continue the data wrangling in chapter 5
setwd("C:/Users/lonav/Documents/IODS-project/data")
library(openxlsx)
human <- read.csv("human.csv", sep = ",", header = TRUE)
library(dplyr)
colnames(human)
dim(human)
str(human)
#Observations: 195, Variables: 9
#The variables are:
#"Country" = Country name
#"hdi" = Human Development Index
#"GNI" = Gross National Income per capita
#"gii" = Gender Inequality Idex
#"life" = Life expectancy at birth
#"exp_edu" = Expected years of schooling
#"mean_edu" = Average years of schooling
#"mat.mor_rat" = Maternal mortality ratio
#"birth.rate" = Adolescent birth rate
#"par.repr" = Percetange of female representatives in parliament
#"f.sec_edu" = Proportion of females with at least secondary education
#"m.sec_edu" = Proportion of males with at least secondary education
#"f.labour" = Proportion of females in the labour force
#"m.labour" = Proportion of males in the labour force
#"f_m.sec_edu" = f.sec_edu / m.sec_edu
#"f_m.labour" = f.labour / m.labour

#Mutate GNI variabel to numerical with string manipulation,...
library(stringr)
HUMAN <- human %>% 
  mutate(GNI = str_replace(GNI, pattern=",", replace ="") %>% as.numeric)

#select specific variables, ...
keep <- c("Country", "f_m.sec_edu", "f_m.labour", "life", "exp_edu", "GNI", "mat.mor_rat", "birth.rate", "par.repr")
HUMAN <- dplyr::select(HUMAN, one_of(keep))
head(HUMAN)

#filter missing data out, ...
complete.cases(HUMAN)
data.frame(HUMAN[-1], comp = complete.cases(HUMAN))
HUMAN_ <- filter(HUMAN, complete.cases(HUMAN))

#remove region related observations and ...
tail(HUMAN_, n = 10)
last <- nrow(HUMAN_) - 7
HUMAN1 <- HUMAN_[1:last, ]

#define row names by country.
rownames(HUMAN1) <- HUMAN1$Country
HUMAN2 <- select(HUMAN1, -Country)
dim(HUMAN2)
#dimensions now: 155 observations, 8 columns

#save the data set including the row names
setwd("C:/Users/lonav/Documents/IODS-project/data")
library(openxlsx)
write.table(human, file = "human.csv", append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = TRUE, qmethod = "double",
            fileEncoding = "")

