# tutorial: https://www.slideshare.net/rdatamining/association-rule-mining-with-r

## install & load packages ####
install.packages("arules")
install.packages("arulesViz")
library(arules)
library(arulesViz)
library(dplyr)

# new model
model_4.3.2 <- apriori(spar_trix_4.3, parameter = list(support=0.007, confidence = 0.10, minlen = 2),
                       control = list(verbose = F), appearance = list(rhs = c("race"),
                                         lhs = c("armed_unarmed","cause_of_death",
                                                 "city", "state", "gender",
                                                 "mental_illness", "charges_brought")))

summary(model_4.3.2) # set of 30344 rules rules


model_4.3.3 <- apriori(spar_trix_4.3, parameter = list(support=0.007, confidence = 0.10, minlen = 2),
                       control = list(verbose = F),
                       appearance = list(rhs = c("armed_unarmed","cause_of_death",
                                                 "city", "state", "gender",
                                                 "mental_illness", "charges_brought"),
                                         lhs = c("race")))

summary(model_4.3.3) # set of 30344 rules


model_4.3.4 <- apriori(spar_trix_4.3, parameter = list(support=0.007, confidence = 0.10, minlen = 2),
                       appearance = list(rhs = c("race")))

summary(model_4.3.4) #set of 30344 rules



# interpreting rules
inspect(sort(model_4.3.2, by="lift")[1:100])

inspect(sort(model_4.3.3, by="lift")[1:100])

inspect(sort(model_4.3.4, by="lift")[1:100])

# vizualizing rules -- take out all?

plot(model_4.3.2.all) # scatter plot for 27 rules

plot(model_4.3.2.all, method = "grouped") #clusters matrix

plot(model_4.3.2.all, method = "graph")

plot(model_4.3.2.all, method = "graph", control = list(type = "items"))

# parallel coordinates plot for 27 rules
plot(model_4.3.2.all, method = "paracoord", control = list(reorder = TRUE))



