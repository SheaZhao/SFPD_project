# tutorial: https://www.slideshare.net/rdatamining/association-rule-mining-with-r

## install & load packages ####
library(arules)
library(arulesViz)
library(dplyr)

# new model
model_4.3.2 <- apriori(spar_trix_4.3, parameter = list(support=0.1, confidence = 0.50, minlen = 2))

summary(model_4.3.2) #set of 598 rules
inspect(sort(model_4.3.2, by="lift")[1:100])

plot(model_4.3.2) #scatter plot
plot(model_4.3.2, method = "grouped") #clusters matrix
plot(model_4.3.2, method = "graph") # bubble matrix - not helpful as is

# models by race
model_4.3.4 <- apriori(spar_trix_4.3, control = list(verbose =F),
                       parameter = list(support=0.1, confidence = 0.10, minlen = 2),
                       appearance = list(rhs = c("Black"), default = "lhs"))

summary(model_4.3.4) # 35 rules

# vizualizing rules

plot(model_4.3.4) # scatter plot for rules

plot(model_4.3.4, method = "grouped", interactive = TRUE) #clusters matrix

plot(model_4.3.4, method = "graph") 

plot(model_4.3.4, method = "graph", control = list(type = "items")) # better b/c fewer rules

# parallel coordinates plot for rules
plot(model_4.3.4, method = "paracoord", control = list(reorder = TRUE))





model_4.3.5 <- apriori(spar_trix_4.3, control = list(verbose =F),
                       parameter = list(support=0.1, confidence = 0.10, minlen = 2),
                       appearance = list(rhs = c("Black", "White"), lhs = c("state")))

summary(model_4.3.5) # 35 rules

# vizualizing rules

plot(model_4.3.5) # scatter plot for rules

plot(model_4.3.5, method = "grouped") #clusters matrix

plot(model_4.3.5, method = "graph") 

plot(model_4.3.5, method = "graph", control = list(type = "items"))

# parallel coordinates plot for rules
plot(model_4.3.5, method = "paracoord", control = list(reorder = TRUE))
