
# Question 1
library(readxl)
myData <- read_excel("C:/Users/spink/Downloads/Ch7_Q15_Data_File (1).xlsx")
View(myData)

# a
Model <- lm(Price ~ Sqft + Beds + Baths + Colonial, data = myData)
summary(Model)

# c
predict(Model, data.frame(Sqft = 2500, Beds = 3, Baths = 2, Colonial = 1),
        level=0.95, interval="confidence")

# d
predict(Model, data.frame(Sqft = 2500, Beds = 3, Baths = 2, Colonial = 1),
        level=0.95, interval="prediction")

# Question 2
library(readxl)
myData <- read_excel("C:/Users/spink/Downloads/Ch7_Q25_Data_File.xlsx")
View(myData)

Model <- lm(Return ~ PE + PS, data = myData)
summary(Model)
predict(Model, data.frame(PE = 10, PS = 2))

# Question 4
library(readxl)
myData <- read_excel("C:/Users/spink/Downloads/Ch9_Q13_Data_File.xlsx")
View(myData)

Model <- glm(STEM ~ GPA + SAT + White + Female + Asian, family=binomial, data=myData)
summary(Model)
predict(Model, newdata=data.frame(GPA=3.4, SAT=1400, White=1, Female=0, Asian=0), type="response")

# b2
predict(Model, newdata=data.frame(GPA=3.4, SAT=1400, White=0, Female=0, Asian=1), type="response")
predict(Model, newdata=data.frame(GPA=3.4, SAT=1400, White=0, Female=0, Asian=0), type="response")

# c1
predict(Model, newdata=data.frame(GPA=3.4, SAT=1400, White=1, Female=1, Asian=0), type="response")

# c2
predict(Model, newdata=data.frame(GPA=3.4, SAT=1400, White=0, Female=1, Asian=1), type="response")
predict(Model, newdata=data.frame(GPA=3.4, SAT=1400, White=0, Female=1, Asian=0), type="response")

# Question 5
library(readxl)
myData <- read_excel("C:/Users/spink/Downloads/Ch9_Q21_Data_File.xlsx")
View(myData)

Model <- glm(Complication ~ Weight + Age + Diabetes, family=binomial, data=myData)
summary(Model)

# a
pLog <- predict(Model, data.frame(Weight=180, Age=60, Diabetes=1), type="response"); pLog
oLog <- pLog/(1-pLog); oLog

#b
pLog <- predict(Model, data.frame(Weight=180, Age=60, Diabetes=0), type="response"); pLog
oLog <- pLog/(1-pLog); oLog

#c
cf <- coef(Model)
(exp(cf[4])-1)*100


