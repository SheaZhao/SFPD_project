# tutorial: https://www.slideshare.net/rdatamining/association-rule-mining-with-r

## install & load packages ####
library(arules)
library(arulesViz)
library(dplyr)

# new model
model_4.3.2 <- apriori(spar_trix_4.3, parameter = list(support=0.1, confidence = 0.10, minlen = 2))

summary(model_4.3.2) #set of 32 rules
inspect(sort(model_4.3.2, by="lift"))

# plots
plot(model_4.3.2) #scatter plot
plot(model_4.3.2, method = "grouped") #clusters matrix
plot(model_4.3.2, method = "graph") # bubble matrix
# parallel coordinates plot for rules
plot(model_4.3.2, method = "paracoord", control = list(reorder = TRUE))


# models by race & cause of death
model_4.3.4 <- apriori(spar_trix_4.3, control = list(verbose =F),
                       parameter = list(support=0.1, confidence = 0.10, minlen = 2),
                       appearance = list(rhs = c("race"), lhs = c("cause_of_death")))

summary(model_4.3.4) # 32 rules

# vizualizing rules
plot(model_4.3.4) # scatter plot for rules
plot(model_4.3.4, method = "grouped") #clusters matrix
plot(model_4.3.4, method = "graph") 
plot(model_4.3.4, method = "graph", control = list(type = "items")) # better b/c fewer rules
# parallel coordinates plot for rules
plot(model_4.3.4, method = "paracoord", control = list(reorder = TRUE))


# breack down race & COD & armed
    ##> unique(mpv_2$cause_of_death)####
    #[1] "Gunshot"                         "Taser"                          
    #[3] "Physical Restraint/Asphyxiation" "Vehicle"                        
    #[5] "Unspecified"                     "Beaten"                         
    #[7] "Medical Emergency"               "Robot Bomb"                     
    #[9] "Pepper Spray"                    "Drowning"                       
    #[11] "Fall to death"                   "Drug Overdose"                  
    #[13] "Suicide"                         "Smoke inhilation"               
    #[15] "Hanging"                         "Negligence/Negligence/Neglect" 
## ####


model_5 <- apriori(spar_trix_5, 
                       parameter = list(support=0.01, confidence = 0.10, minlen = 2))


#"Black", "White", "Hispanic", "Asian",
#"Pacific Islander", "Native American", 
#"Unknown race"

summary(model_5) # set of 82 rules
inspect(sort(model_4.3.5, by="lift"))

# vizualizing rules

plot(model_5) # scatter plot for rules
plot(model_5, method = "grouped") #clusters matrix
plot(model_5, method = "graph") 
plot(model_5, method = "graph", control = list(type = "items"))
# parallel coordinates plot for rules
plot(model_5, method = "paracoord", control = list(reorder = TRUE))


# break down by just race & COD
model_5 <- apriori(spar_trix_5, 
                   parameter = list(support=0.01, confidence = 0.10, minlen = 2))


#"Black", "White", "Hispanic", "Asian",
#"Pacific Islander", "Native American", 
#"Unknown race"

summary(model_5) # set of 82 rules
inspect(sort(model_4.3.5, by="lift"))

# vizualizing rules

plot(model_5) # scatter plot for rules
plot(model_5, method = "grouped") #clusters matrix
plot(model_5, method = "graph") 
plot(model_5, method = "graph", control = list(type = "items"))
# parallel coordinates plot for rules
plot(model_5, method = "paracoord", control = list(reorder = TRUE))

