#meet_and_repeat
#Lona van Delden
#29/11/19

#load the data
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep=" ", header=T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep="\t", header=T)

#load libraries
library(dplyr)
library(tidyr)
library(ggplot2)

#check BPRS data
dim(BPRS) # 40 obs. of 11 variables
head(BPRS)
str(BPRS)
summary(BPRS)

#check RATS data
dim(RATS) # 16 obs. of 13 variable
head(RATS)
str(RATS)
summary(RATS)

#convert categorical variables to factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

#convert the data sets to long form & and add week variable to BPRS and time variable to RATS
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))
RATSL <-  RATS %>% gather(key = WD, value = rats, -ID, -Group)
RATSL <-  RATSL %>% mutate(time = as.integer(substr(WD,3,3)))

#check the data now, variable names, data content and structure, summaries
glimpse(BPRSL)
glimpse(RATSL)

#write the data into csv files
setwd("C:/Users/lonav/Documents/IODS-project")
library(openxlsx)
write.table(BPRSL, file = "BPRS.csv", append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = TRUE, qmethod = "double",
            fileEncoding = "")
write.table(RATSL, file = "RATS.csv", append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = TRUE, qmethod = "double",
            fileEncoding = "")
