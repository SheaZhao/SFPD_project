# tutorial: https://www.slideshare.net/rdatamining/association-rule-mining-with-r

## install & load packages ####
library(arules)
library(arulesViz)
library(dplyr)

# new model
model_4.3.2 <- apriori(spar_trix_4.3, parameter = list(support=0.007, confidence = 0.10, minlen = 2))

summary(model_4.3.2) #set of 30344 rules
inspect(sort(model_4.3.2, by="lift")[1:100])

# models by race
model_4.3.4 <- apriori(spar_trix_4.3, control = list(verbose =F),
                       parameter = list(support=0.007, confidence = 0.10, minlen = 2),
                       appearance = list(rhs = c("Black"), default = "lhs"))


# vizualizing rules

plot(model_4.3.4) # scatter plot for rules

plot(model_4.3.4, method = "grouped") #clusters matrix

plot(model_4.3.4, method = "graph") # takes a long time to run

plot(model_4.3.4, method = "graph", control = list(type = "items"))

# parallel coordinates plot for rules
plot(model_4.3.4, method = "paracoord", control = list(reorder = TRUE))



