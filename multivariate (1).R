project <- read.csv("C:/Users/Glane/Downloads/project1.csv")
View(project)
str(project)
project_prcomp <- project[,-10]  #removing class column since its not numeric
pca <- prcomp(project_prcomp, scale=TRUE)
summary(pca)

#Here scale= true means we have standardized the input data so that it has zero mean and variance one before doing PCA.

#we can use sdev to compute variance explained by each Principal Component.
var <- pca$sdev^2/sum(pca$sdev^2)
var

#Visualizing the variance will help us identifying how many principal components are needed to explain the variation data
library(factoextra)
fviz_screeplot(pca, ncp=10)

#Looking at the plot we can retain minimum 3 TO 4 and max 7 , as per requirement.


#Question 2 
#splitting project.csv in two sets
x1x1 <- project[,1:5]
x2x2 <- project[,6:9]

library(CCA)

#the canonical correlations
can_cor=cc(x1x1,x2x2)
can_cor
can_cor[3:4]

#the standard deviations between the variables have a large variance between them i.e x1 to x5 and x6 to x9, we need to standardise

#standardizing the first set of canonical coefficients(x1x1)
std_coef1<-diag(sqrt(diag(cov(x1x1))))
std_coef1%*%can_cor$xcoef

#standardizing the second set of canonical coefficients(x2x2)
std_coef1<-diag(sqrt(diag(cov(x2x2))))
std_coef1%*%can_cor$ycoef


#Question 3
library(MASS)
project$Class <- as.factor(project$Class)
train <- project[1:20,]
test <- project[21:40,]

lda_model <- lda(Class ~ X1 + X2 + X3 + X4 + X5 + X6 + X7 + X8 + X9, data = train)
lda_model

#Prior probabilities show66.67% of training observations are group with class A and rest with class B

lda_predict <- predict(lda_model,test)


#QDA
str(train)

qda_model <- qda(Class ~ ., data = train)
qda_model

#Prior probabilities show 52.39% of training observations are group with class A and rest with class B

qda_predict <- predict(qda_model,test)

library(ROCR)
library(dplyr)
#Accuracy lda
prediction(lda_predict$posterior[,2], test$Class) %>%
  performance(measure = "auc") %>%.@y.values

#Accuracy qda
prediction(qda_predict$posterior[,2], test$Class) %>%
  performance(measure = "auc") %>%.@y.values

#Accuracy for LDA is 88% and QDA is 51%


#Increasing the training dataset and reducing test will help us get more accurate QDA

train_1 <- project[1:28,]  #70 % train and 30 % test
test_1 <- project[29:40,]

lda_model_1 <- lda(Class ~ X1 + X2 + X3 + X4 + X5 + X6 + X7 + X8 + X9, data = train_1)
lda_model_1

#Prior probabilities show 48% of training observations are group with class A and rest with class B

lda_predict_1 <- predict(lda_model_1,test_1)


#QDA
qda_model_1 <- qda(Class ~ ., data = train_1)
qda_model_1

#Prior probabilities show 48% of training observations are group with class A and rest with class B

qda_predict_1 <- predict(qda_model_1,test_1)


#Accuracy lda
prediction(lda_predict_1$posterior[,2], test_1$Class) %>%
  performance(measure = "auc") %>%.@y.values

#Accuracy qda
prediction(qda_predict_1$posterior[,2], test_1$Class) %>%
  performance(measure = "auc") %>%.@y.values

#Accuracy for LDA and QDA is 100%