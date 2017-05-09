# Race & COD correlation

# Race & age correlation

# Race & gender correlation

# Age & COD correlation - by race?

# Age & gender correlation - by race?

# Race & state

# Race & agency

# State & armed - by race

# State & charges - by race

# State & mental illness - by race

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