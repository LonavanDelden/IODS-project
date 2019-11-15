#Lona van Delden, November 14th 2019, data wrangling script to merge files for the logistic regression exercise
#Data from UCI Macine Learning Repository: Paulo Cortez, University of Minho, GuimarÃ£es, Portugal, http://www3.dsi.uminho.pt/pcortez
#Reference: P. Cortez and A. Silva. Using Data Mining to Predict Secondary School Student Performance. In A. Brito and J. Teixeira Eds., Proceedings of 5th FUture BUsiness TEChnology Conference (FUBUTEC 2008) pp. 5-12, Porto, Portugal, April, 2008, EUROSIS, ISBN 978-9077381-39-7.

#read in the data sets and explore structure and dimensions
mat <- read.table("student-mat.csv", sep=";", header=TRUE)
por <- read.table("student-por.csv", sep=";", header=TRUE)
str(mat)
str(por)
dim(mat)
dim(por)

#join the data sets using the identifiers stated in the instructions and explore the structure and dimensions of the joint data set
install.packages("dplyr")
library(dplyr)
join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")
mat_por <- inner_join(mat, por, by = join_by, suffix = c(".mat",".por"))
colnames(mat_por)
glimpse(mat_por)

#keep only the students appearing in both data sets???

#create a data frame excluding not joined columns and print columns
alc <- select(mat_por, one_of(join_by))
notjoined_columns <- colnames (mat)[!colnames(mat) %in% join_by]
notjoined_columns

#if-else structure to combine 'dublicated' answers
for(column_name in notjoined_columns) {
  two_columns <- select(mat_por, starts_with(column_name))
  first_column <- select(two_columns, 1)[[1]]
  if(is.numeric(first_column)) {
    alc[column_name] <- round(rowMeans(two_columns))
  } else {
    alc[column_name] <- first_column
  }
}
glimpse(alc)

#'tidyverse' packages
library(dplyr); library(ggplot2)

#create new column to combine two observations, create a new logical column and draw a bar plot per sex
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
g1 <- ggplot(data = alc, aes(x = alc_use), fill = sex)
g1 + geom_bar()
alc <- mutate(alc, high_use = alc_use > 2)
g2 <- ggplot(data = alc, aes(x = high_use))
g2 + geom_bar() + facet_wrap("sex")
glimpse(alc)

#write the modified data set as .csv file into the data folder
setwd("C:/Users/lonav/Documents/IODS-project/data")
#install.packages("openxlsx")
library(openxlsx)
write.table(alc, file = "alc.csv", append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = TRUE, qmethod = "double",
            fileEncoding = "")

#just to check if it worked ok
alc_1 <- read.csv("alc.csv", sep = ",", header = TRUE)
glimpse(alc_1)
