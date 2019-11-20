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

#just to check if it worked ok
human <- read.csv("human.csv", sep = ",", header = TRUE)
dim(human)


