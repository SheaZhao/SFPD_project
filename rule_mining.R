# tutorial: https://www.slideshare.net/rdatamining/association-rule-mining-with-r

# new model
model_4.3.2 <- apriori(spar_trix_4.3, parameter = list(support=0.007, confidence = 0.10, minlen = 2),
                       contorl = list(verbose = F),
                       appearance = list(default = 'none', rhs = c(), lhs = c()))


summary(model_4.3.2)

# interpreting rules
inspect(sort(model_4.3.2, by="lift"))


# vizualizing rules -- take out all?

plot(model_4.3.2.all) # scatter plot for 27 rules

plot(model_4.3.2.all, method = "grouped") #clusters matrix

plot(model_4.3.2.all, method = "graph")

plot(model_4.3.2.all, method = "graph", control = list(type = "items"))

# parallel coordinates plot for 27 rules
plot(model_4.3.2.all, method = "paracoord", control = list(reorder = TRUE))



