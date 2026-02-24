library(readxl)
myData <- read_excel("C:/Users/spink/Downloads/Ch2_Q36_Data_File (1).xlsx")
View(myData)

x1Bins <- quantile(myData$x1, probs=seq(0, 1, by=1/3))
x1Bins
myData$x1_group <- cut(myData$x1, breaks=x1Bins, labels=c("1", "2", "3"), 
                       include.lowest=TRUE, right=TRUE)
table(myData$x1_group)

myData$x2_group <- cut(myData$x2, breaks=3, labels=c("1", "2", "3"), 
                       include.lowest=TRUE, right=FALSE)
table(myData$x2_group)

myData$x3_group <- cut(myData$x3, breaks=c(0, 50000, 100000, Inf), 
                       labels=c("1", "2", "3"), right=FALSE)
table(myData$x3_group)


#2
library(readxl)
myData1 <- read_excel("C:/Users/spink/Downloads/Ch2_Q53_Data_File (1).xlsx")

myData1$x1_score <- ifelse(myData1$x1 == "S", 1,
                          ifelse(myData1$x1 == "M", 2, 3))
length(which(myData1$x1_score == 3))

myData1$x2_Yes <- ifelse(myData1$x2 == "Yes", 1, 0)

table(myData1$x3)
myData1$x3_new <- ifelse(myData1$x3 %in% c("B", "D"), "E", myData1$x3)
table(myData1$x3_new)
length(which(myData1$x3_new == "E"))

# 3
library(readxl)
myData3<- read_excel("C:/Users/spink/Downloads/Ch4_Q7_Data_File (1).xlsx")

Quality_Frequency <- table(myData3$Quality)
Quality_Frequency


# 4
myData4 <- read_excel("C:/Users/spink/Downloads/Ch4_Q19_Data_File (1).xlsx")

intervals <- seq(0, 600000, by=100000)
HouseValue.cut <- cut(myData4$House_Value, intervals, left=FALSE, right=TRUE)
HouseValue.frequency <- table(HouseValue.cut)
HouseValue.frequency

length(which(myData4$House_Value <= 300000))

hist(myData4$House_Value, breaks=intervals, right=TRUE, main="Histogram for Median House Values", xlab="House Value ($)", col="blue")
