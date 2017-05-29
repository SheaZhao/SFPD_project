# tutorial: https://www.slideshare.net/rdatamining/association-rule-mining-with-r

# interpreting rules
inspect(rules.pruned[1])

apriori(data, parameter = NULL, appearance = NULL, control = NULL)

rules <- apriori(titanic.raw, control = list(verbose = F),
                 parameter = list(minlen = 3, supp = 0.002, conf = 0.2),
                 appearance = list(default = 'none', rhs = c ("Survided = Yes"),
                                   lhs = c("Class = 1st", "Class = 2nd", 
                                           "Class = 3rd", "Age = Child", 
                                           "Age = Adult")))
summary(rules)

rules.sorted <- sort(rules, by = "confidence")
inspect(rules.sorted)

# vizualizing rules

plot(rules.all) # scatter plot for 27 rules

plot(rules.all, method = "grouped") #clusters matrix

plot(rules.all, method = "graph")

plot(rules.all, method = "graph", control = list(type = "items"))

# parallel coordinates plot for 27 rules
plot(rules.all, method = "paracoord", control = list(reorder = TRUE))



