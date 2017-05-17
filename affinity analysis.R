## install & load packages ####
install.packages("arules")
install.packages("arulesViz")
library(arules)
library(arulesViz)

## load data as sparce matrix & then load data frames ####

# Age numeric w/ no missing values
mpv_4 <- filter(mpv_2, !is.na(age))
unique(mpv_4$age) # no NA's, BUT there is a class called Unknown!
mpv_4.1 <- filter(mpv_4, age != "Unknown")
mpv_4.1$age <- as.numeric(mpv_4.1$age) # should be numeric now
mean(mpv_4.1$age) # is numeric
unique(mpv_4.1$age) # no NA's or Unknowns

mpv_4.2 <- mpv_4.1 # want to preserve mpv_4.1

# Age Groups
mpv_4.2$age <- cut(mpv_4.2$age, 
                   breaks = c(0, 18, 25, 35, 45, 55, 65, 120), 
                   lables = c("0-18 years", "18-25 years", "25-35 years", "35-45 years", "45-55 years", "55-65 years", "66 year or older"),
                   right = FALSE)
levels(mpv_4.2$age)
View(mpv_4.2$age)

# make 4.1 & 4.2 csv's so I can import them as sparce matrisis
write.csv(mpv_4.1, file = "mpv_4.1.csv", row.names = FALSE)
write.csv(mpv_4.2, file = "mpv_4.2.csv", row.names = FALSE)

# reload data as sparce matrisis
# path: ~/Documents/stanford_classes/data_sci/Mapping_Police_Violence/mpv_4.1.csv

spar_trix_4.1 <- read.transactions("~/Documents/stanford_classes/data_sci/Mapping_Police_Violence/mpv_4.1.csv", sep = ",")
spar_trix_4.2 <- read.transactions("~/Documents/stanford_classes/data_sci/Mapping_Police_Violence/mpv_4.2.csv", sep = ",")



## Data Relationships ####

colnames(mpv_4.2) # can't use this for sparce matrix
#[1] "name"                   "age"                    "gender"                
#[4] "race"                   "URL"                    "date"                  
#[7] "address"                "city"                   "state"                 
#[10] "zip_code"               "county"                 "agency_responsible"    
#[13] "cause_of_death"         "description"            "justification_of_death"
#[16] "charges_brought"        "link_news_doc"          "mental_illness"        
#[19] "armed_unarmed"   

# need inspectFrequency to look at col.s & rows
itemFrequency(spar_trix_4.1[, 1]) # all rows, first col.

itemFrequencyPlot(spar_trix_4.1, support = 0.10) # cool!!!
# items that have a min of 10% support

itemFrequencyPlot(spar_trix_4.1, topN = 20)

itemFrequencyPlot(data, topN = 5) 
# top items ranked in order! consistent w/ Chaya's findings/data!


## Build a Model ####

model_4.1 <- apriori(spar_trix_4.1, parameter = list(support=0.007, confidence = 0.10, minlen = 2))
model_4.1 #28,790 rules!
summary(model_4.1)
#SUMMARY
# max lift = 124.4595
# 9422 rules w/ length of 4 (mode)
# 50% of rules have 4-5 length (1stQ-3rdQ)
# max rule length = 8, min is 2
# median rule length = 4, mean = 4.409 - so basically normal distribution
# max confidence is 1 - wow
# 1stQ = 50% conf, 3rdQ = 97% conf - so 50% of distribution has relatively high confidence


## DETAILS ####
# rule length distribution (lhs + rhs):sizes
# 2    3    4    5    6    7    8 
# 1070 5130 9422 8345 3839  904   80 

# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 2.000   4.000   4.000   4.409   5.000   8.000 

# summary of quality measures:
#    support           confidence          lift         
# Min.   :0.007166   Min.   :0.1000   Min.   :  0.1767  
# 1st Qu.:0.008252   1st Qu.:0.5060   1st Qu.:  1.0105  
# Median :0.010424   Median :0.8432   Median :  1.0474  
# Mean   :0.020510   Mean   :0.7263   Mean   :  4.9800  
# 3rd Qu.:0.016287   3rd Qu.:0.9737   3rd Qu.:  1.2013  
# Max.   :0.908361   Max.   :1.0000   Max.   :124.4595  

# mining info:
#    data ntransactions support confidence
# spar_trix_4.1          4605   0.007        0.1


## Sort model rules by lift ####

#inspect(model_4.1, by = "lift")[1:10] # just look at top 10
inspect(sort(model_4.1, by="lift")[1:100])







