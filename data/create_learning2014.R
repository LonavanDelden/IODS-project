#Lona van Delden, 6/11/2019, script for exercise 2

#Read in the data set
learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=T)

#Dimensions of data set
dim(learning2014)

#Look at the data
str(learning2014)
summary(learning2014)

#Look at the header
head(learning2014)

#Access deeper learning library 
library(dplyr)

# divide each number in a vector
c(1,2,3,4,5) / 2

#change of coloumns while creating new dataset
lrn14 <- learning2014 

#questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

head(lrn14)

#several things can be done to the same data set but only calling it once using '%>%' and change them using 'mutate'
lrn14 <- learning2014 %>% mutate(
  attitude=Attitude/10,
  deep=rowMeans(deep_columns,na.rm=T),
  surf=rowMeans(surface_columns,na.rm=T),
  stra=rowMeans(strategic_columns,na.rm=T))

#create analysis dataset
keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")
lrn14 <- select(lrn14, one_of(keep_columns))

head(lrn14)

# change colnames

head(lrn14)
colnames(lrn14)[2] <- "age"
colnames(lrn14)[3] <- "attitude"
colnames(lrn14)[7] <- "points"

head(lrn14)
lrn14$attitude <- lrn14$attitude / 10


#exclude observations where exam points are zero
lrn14 <- filter(lrn14, Points > 0)
summary(lrn14)
str(lrn14)

#check on current working directory
getwd()
#set the working directory
setwd("C:/Users/lonav/Documents/IODS-project")

install.packages("openxlsx")
library(openxlsx)

#help
?write.csv

# Save the analysis dataset to the ‘data’ folder

library(openxlsx)
write.table(lrn14, file = "learning2014_1.csv", append = FALSE, quote = TRUE, sep = ",",
          eol = "\n", na = "NA", dec = ".", row.names = FALSE,
          col.names = TRUE, qmethod = "double",
          fileEncoding = "")

install.packages("readxl")
library(readxl)

#read the table
learning2014_1 <- read.csv("learning2014_1.csv", header = TRUE, sep = ",")

head(learning2014_1)
library("dplyr")

str(learning2014_1) 
learning2014_1$attitude = attitude/ 10
colnames(learning2014_1)
colnames(learning2014_1)[3] <- "attitude"
colnames(learning2014_1)[2] <- "age"
mutate(learning2014_1, attitude=attitude/10)
str(learning2014_1)