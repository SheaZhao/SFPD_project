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











