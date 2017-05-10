# install & load packages
library(caret)
install.packages("hydroGOF")
library(hydroGOF)

# Race & COD correlation
cor(mpv_2$race, mpv_2$cause_of_death) # can't really use this b/c x must be numeric (y too?)


# data split - split rows by (count by 2 on the row indexes)
colnames(mpv_4.1)
train_race_all <- mpv_2[seq(1, nrow(mpv_2),2), c("race", "cause_of_death", "charges_brought", "armed_unarmed", "age")]
test_race_all <- mpv_2[seq(2, nrow(mpv_2),2), c("race", "cause_of_death", "charges_brought", "armed_unarmed", "age")]

# attmenting to remove NA's : Error in na.fail.default(list(race = c("White", "White", "Black", "White",  : 
# missing values in object

    #na.action=na.omit

    #> D<-data.frame(x=c(NA,2,3,4,5,6),y=c(2.1,3.2,4.9,5,6,7),residual=NA)
    #> Z<-lm(y~x,data=D)
    #> D[names(Z$residuals),"residual"]<-Z$residuals
    #> D
   
    # try taking out charges brought: nope
        train_race_all <- mpv_2[seq(1, nrow(mpv_2),2), c("race", "cause_of_death", "armed_unarmed", "age")]
        test_race_all <- mpv_2[seq(2, nrow(mpv_2),2), c("race", "cause_of_death", "armed_unarmed", "age")]


     # try changing character variables to factor - maybe?
    class(mpv_4.1$age) # this is probably ok
    mpv_4.1$race <- as.factor(mpv_4.1$age)
    mpv_4.1$race <- as.factor(mpv_4.1$armed_unarmed)
    mpv_4.1$race <- as.factor(mpv_4.1$cause_of_death)
    mpv_4.1$race <- as.factor(mpv_4.1$race)
    class(mpv_4.1$race)

model_train_all <- train(race~., data = train_race_all, method = "lm")
    # Error in na.fail.default(list(race = c("White", "White", "Black", "White",  : 
    # missing values in object
predictedMPG_all <- predict(mode_train_alll, test_race_all)
rmse(predictedMPG_all, test_race_all$race)


## Race & age correlation ####

## Race & gender correlation ####

## Age & COD correlation - by race? ####

## Age & gender correlation - by race? ####

## Race & state ####

## Race & agency ####

## State & armed - by race ####

## State & charges - by race ####

## State & mental illness - by race ####

data <- realEstate [, c("price", "sq__ft")] # putting my variables into "data"

model <- train(price~., data = data, method = "lm") # indicate the variable we 
# want to predict (price) & give training model method (lm)

model$finalModel # gives coefficients: int & weight
# Call:
# lm(formula = .outcome ~ ., data = dat)

# Coefficients:
# (Intercept)       sq__ft  
# 162930.16        54.16 

# predict prices
predictedMPG <- predict(model, data)

# calculate MAE
mean(abs(predictedMPG - realEstate$price)) # [1] 95860.15
rmse(predictedMPG, realEstate$price) # [1] 130358.7  

# plot - just for fun
ggplot(realEstate, aes(sq__ft, price)) + geom_point() # positive linear relationship
cor(realEstate$price, realEstate$sq__ft) # [1] 0.333897