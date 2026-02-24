library(readxl)
myData <- read_excel("C:/Users/spink/OneDrive/Desktop/Data Minning/Data/Ch2_Q45_Data_File.xlsx")
View(myData)

# Question 31
# part a
myData$DaysSinceLast <- as.numeric(as.Date("2022-01-01") - as.Date(myData$LastTransactionDate))
round(mean(myData$DaysSinceLast), 2)


# b

rBreaks <- quantile(myData$DaysSinceLast, probs=seq(0,1, by=1/5))
myData$R <- cut(myData$DaysSinceLast, breaks=rBreaks, labels=c("5","4","3","2","1"), include.lowest=TRUE, right=TRUE)

fBreaks <- quantile(myData$Frequency, probs=seq(0,1, by=1/5))
myData$F <- cut(myData$Frequency, breaks=fBreaks, labels=c("1","2","3","4","5"), include.lowest=TRUE, right=TRUE)

mBreaks <- quantile(myData$TotalSpending, probs=seq(0,1, by=1/5))
myData$M <- cut(myData$TotalSpending, breaks=mBreaks, labels=c("1","2","3","4","5"), include.lowest=TRUE, right=TRUE)


sum(myData$R == "5" & myData$F == "5" & myData$M == "5")

round(mean(myData$TotalSpending[myData$R == "5" & myData$F == "5" & myData$M == "5"]), 2)

# c

myData$LogSpending <- log(myData$TotalSpending)


myData$LogBinned <- cut(myData$LogSpending, breaks=5, labels=c("1","2","3","4","5"), include.lowest=TRUE)

length(which(myData$LogBinned == 2))

#d
myData$AverageOrderSize <- myData$TotalSpending / myData$Frequency

myData$AvgBinned <- cut(myData$AverageOrderSize, breaks=5, labels=c("1","2","3","4","5"), include.lowest=TRUE)

length(which(myData$AvgBinned == 2))

# Question 32
library(readxl)
myData <- read_excel("C:/Users/spink/Downloads/Ch7_Q17_Data_File.xlsx")
View(myData)

# a
Model <- lm(Salary ~ PC + TD + Age, data = myData)
summary(Model)

#c
predict(Model, data.frame(PC = 70.6, TD = 34, Age = 30))

# d
predict(Model, data.frame(PC = 65.7, TD = 28, Age = 32))

# Question 33
# did by hand with a calcualtor 


# Question 34
library(readxl)
myData <- read_excel("C:/Users/spink/Downloads/Ch9_Q25_v4_Data_File.xlsx")
View(myData)

# part a
Model <- glm(Acceptable ~ Age + Religious, family=binomial, data=myData)
summary(Model)

pLog <- predict(Model, data.frame(Age=50, Religious=1), type="response")
pLog
oLog <- pLog/(1-pLog)
oLog


# b
cf <- coef(Model)
(exp(cf[3])-1)*100









