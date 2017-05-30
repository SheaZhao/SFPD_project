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

# remove some variables
mpv_4.3 <- select(mpv_4.2, - c(name, age, URL, date, zip_code, county, 
                               agency_responsible, description, justification_of_death,
                               charges_brought, link_news_doc, address, gender, 
                               mental_illness))
colnames(mpv_4.3)
#[1] "race" "city" "state"  "cause_of_death" "armed_unarmed" 

mpv_5 <- select(mpv_4.3, - c(city, state))
colnames(mpv_5)
# [1] "race" "cause_of_death" "armed_unarmed" 


# make 4.1 & 4.2 csv's so I can import them as sparce matrisis
write.csv(mpv_4.3, file = "mpv_4.3.csv", row.names = FALSE)
write.csv(mpv_5, file = "mpv_5.csv", row.names = FALSE)

# reload data as sparce matrisis
# path: ~/Documents/stanford_classes/data_sci/Mapping_Police_Violence/mpv_4.1.csv
spar_trix_4.3 <- read.transactions("~/Documents/stanford_classes/data_sci/Mapping_Police_Violence/mpv_4.3.csv", sep = ",")
spar_trix_5 <- read.transactions("~/Documents/stanford_classes/data_sci/Mapping_Police_Violence/mpv_5.csv", sep = ",")

itemFrequencyPlot(spar_trix_5, support = 0.10) # cool!!!

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
summary(model_4.3) # set of 654 rules

#Sort model rules by lift

#inspect(model_4.1, by = "lift")[1:10] # just look at top 10
inspect(sort(model_4.3, by="lift")[1:100]) # much better after removing more variabls








