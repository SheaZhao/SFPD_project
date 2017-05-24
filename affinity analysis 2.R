## install & load packages ####
install.packages("arules")
install.packages("arulesViz")
library(arules)
library(arulesViz)
library(dplyr)

## load data as sparce matrix & then load data frames ####

# Age numeric w/ no missing values
mpv_4 <- filter(mpv_2, !is.na(age))
unique(mpv_4$age) # no NA's, BUT there is a class called Unknown!
mpv_4.1 <- filter(mpv_4, age != "Unknown")
mpv_4.1$age <- as.numeric(mpv_4.1$age) # should be numeric now
mean(mpv_4.1$age) # is numeric
unique(mpv_4.1$age) # no NA's or Unknowns

mpv_4.2 <- mpv_4.1 # want to preserve mpv_4.1

colnames(mpv_4.2) # remove some of these
#[1] "name"                   "age"                    "gender"                
#[4] "race"                   "URL"                    "date"                  
#[7] "address"                "city"                   "state"                 
#[10] "zip_code"               "county"                 "agency_responsible"    
#[13] "cause_of_death"         "description"            "justification_of_death"
#[16] "charges_brought"        "link_news_doc"          "mental_illness"        
#[19] "armed_unarmed"  

# remove URL, description, link_news_doc

mpv_4.3 <- select(mpv_4.2, - c(URL, description, link_news_doc))
View(mpv_4.3)


# make 4.1 & 4.2 csv's so I can import them as sparce matrisis
write.csv(mpv_4.3, file = "mpv_4.3.csv", row.names = FALSE)

# reload data as sparce matrisis
# path: ~/Documents/stanford_classes/data_sci/Mapping_Police_Violence/mpv_4.1.csv
spar_trix_4.3 <- read.transactions("~/Documents/stanford_classes/data_sci/Mapping_Police_Violence/mpv_4.3.csv", sep = ",")

## Data Relationships ####

# need inspectFrequency to look at col.s & rows
itemFrequency(spar_trix_4.3[, 1]) # all rows, first col.

itemFrequencyPlot(spar_trix_4.3, support = 0.10) # cool!!!
# items that have a min of 10% support

itemFrequencyPlot(spar_trix_4.3, topN = 20)

itemFrequencyPlot(spar_trix_4.3, topN = 5) 
# top items ranked in order! consistent w/ Chaya's findings/data!


## Build a Model ####

model_4.3 <- apriori(spar_trix_4.3, parameter = list(support=0.007, confidence = 0.10, minlen = 2))
model_4.3 #28,790 rules!
summary(model_4.3)
##SUMMARY ####
# Apriori
# 
# Parameter specification:
#     confidence minval smax arem  aval originalSupport maxtime support minlen maxlen target   ext
# 0.1    0.1    1 none FALSE            TRUE       5   0.007      2     10  rules FALSE
# 
# Algorithmic control:
#     filter tree heap memopt load sort verbose
# 0.1 TRUE TRUE  FALSE TRUE    2    TRUE
# 
# Absolute minimum support count: 31 
# 
# set item appearances ...[0 item(s)] done [0.00s].
# set transactions ...[16374 item(s), 4565 transaction(s)] done [0.03s].
# sorting and recoding items ... [143 item(s)] done [0.00s].
# creating transaction tree ... done [0.00s].
# checking subsets of size 1 2 3 4 5 6 7 8 done [0.03s].
# writing ... [30344 rule(s)] done [0.02s].
# creating S4 object  ... done [0.02s].
# > model_4.3 #28,790 rules!
# set of 30344 rules 
# > summary(model_4.3)
# set of 30344 rules
# 
# rule length distribution (lhs + rhs):sizes
# 2    3    4    5    6    7    8 
# 1104 5363 9930 8873 4063  931   80 
# 
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 2.000   4.000   4.000   4.413   5.000   8.000 
# 
# summary of quality measures:
#     support           confidence          lift         
# Min.   :0.007010   Min.   :0.1000   Min.   :  0.1737  
# 1st Qu.:0.008105   1st Qu.:0.5068   1st Qu.:  0.9997  
# Median :0.010077   Median :0.8421   Median :  1.0388  
# Mean   :0.020075   Mean   :0.7271   Mean   :  5.0034  
# 3rd Qu.:0.015991   3rd Qu.:0.9740   3rd Qu.:  1.1921  
# Max.   :0.921577   Max.   :1.0000   Max.   :123.3784  
# 
# mining info:
#     data ntransactions support confidence
# spar_trix_4.3          4565   0.007        0.1



## Sort model rules by lift ####

#inspect(model_4.1, by = "lift")[1:10] # just look at top 10
inspect(sort(model_4.3, by="lift")[1:100])








