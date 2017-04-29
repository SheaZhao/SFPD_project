## install and load packages ####
install.packages("littler")
install.packages(c("dplyr", "ggplot2", "igraph"))

my_packages <- c("littler", "dplyr", "ggplot2", "igraph", "magrittr")

lapply(my_packages, require, character.only = TRUE)

installed.packages() # show loaded packages


# first I'll load & explore a few different data sets

## SFPD Incidents data ####

library(readr)
SFPD_Incidents_from_1_January_2003 <- read_csv("~/Documents/stanford_classes/data_sci/SFPD_project_final/data/SFPD_Incidents_-_from_1_January_2003.csv")
View(SFPD_Incidents_from_1_January_2003)

incident.data <- data.frame(SFPD_Incidents_from_1_January_2003)

str(incident.data) # data frame w/ 2049678 obs. of  13 variables

head(incident.data)

colnames(incident.data)

## DOJ arrest data ####

library(readr)
arrest_data <- read_csv("~/Documents/stanford_classes/data_sci/SFPD_project_final/data/arrest_data_2005-2014.csv")
View(arrest_data_2005_2014)

str(arrest_data) # Classes ‘tbl_df’, ‘tbl’ and 'data.frame':238685 obs.of 82 variables

colnames(arrest_data)

# there are a bunch of weird variable names: "SCO01_sum" etc.
# downloaded arrest variables discriptions

# But to gain a more complete picture of what happens when police are called,
# especially, when people are taken into custody, other data is needed


## Mapping Police Violence data ####

library(readxl)
mpv <- read_excel("~/Documents/stanford_classes/data_sci/SFPD_data/MPVDatasetDownload.xlsx")
View(MPVDatasetDownload)

str(mpv)

colnames(mpv) # 19 usable variables, col 20:46 are empty variables: full of "NA"

# it's basically imposible to manipulate the data b/c col 20:46 have the same 
# name: "NA". there is nothing in them, except more "NA", so I'm goind to filter 
# them out

# but first, I need to rename them so they all have different names & don't keep
# getting an error telling me that there are col w/ the same name

names(mpv) <- c("name", "age", "gender", "race", "URL", "date", "address",
                    "city", "state", "zip_code", "county", "agency_responsible", 
                    "cause_of_death", "description", "justification_of_death",
                    "charges_brought", "link_news_doc", "mental_illness", 
                    "armed_unarmed", "empty_20", "empty_21","empty_22","empty_23",
                    "empty_24", "empty_25","empty_26","empty_27","empty_28",
                    "empty_29","empty_30","empty_31","empty_32", "empty_33",
                    "empty_34","empty_35","empty_36","empty_37","empty_38",
                    "empty_39","empty_40","empty_41","empty_42","empty_43",
                    "empty_44","empty_45","empty_46"
                )

colnames(mpv) # it worked



#  now, I can filter out the NA columns

mpv_2 <- select(mpv, name : armed_unarmed) # I just want to the first 19 variables
colnames(mpv_2) # it works




## Exploring the MPV Variables ####
# now I can begin to sort the Monitoring Polic Violence data before I graph it
# first, how many different subsets for each variable are working with?



unique(mpv_2$gender) 
# 5 gender categories:"Male", Female", NA, "Transgender", & "Unknown" 

unique(mpv_2$race) 
# 7 race classifications: White, Black, Hispanic, Native American, Asian,
# Unknown race, & Pacific Islander

unique(mpv_2$cause_of_death)
# 47 causes of death categoreis with obvious overlap - cleaning needed

unique(mpv_2$description)
# 3,500+ descriptions (in paragraph form) of a death. maybe able to catagorize these?

unique(mpv_2$justification_of_death)
# 52 unique subcatagories with obvious overlap - cleaning needed

unique(mpv_2$charges_brought)
# 12 unique subcatagories, 11 of which are different types of charges 
# 1 subcatagory = "No Known Charges"

unique(mpv_2$mental_illness)
# 8 subcatagories with obvious overlap - cleaning neeeded
# some variation of: Yes, No, Unknown, NA, Drug or alcohol use

unique(mpv_2$armed_unarmed)
# 4 subcatagories: "Unarmed", "Allegedly Armed", "Unclear"& "Vehicle" 




## exploritory plots ####

pdf("figures/Deaths_By_Race")
deaths_by_race.qplot <- qplot(race, data = mpv_2, fill = race)
dev.off()

deaths_by_race.qplot 
# death rates by race in descending frequency: 
# white, black, hispanic, unknown race, asian, native american, pacific islander

#pdf("figures/Deaths_By_Age")
#deaths_by_age.qplot <- qplot(age, data = mpv_2, fill = age)
#dev.off()

#deaths_by_age.qplot 
# pretty, but since age is a character the plot is crap: 1, 10, 110,...2,20,21

typeof(mpv_2$age)

# it says that age is a character, I need to change it to numeric class before
# I can plot it properly w/ ggplot

mpv_4 <- filter(mpv_2, !is.na(age))
unique(mpv_4$age) # no NA's, BUT there is a class called Unknown!
mpv_4.1 <- filter(mpv_4, age != "Unknown")
mean(mpv_4.1$age) # works
unique(mpv_4.1$age) # no NA's or Unknowns

mpv_4.1$age <- as.numeric(mpv_4.1$age) # now I can make it numeric

summary(mpv_4.1$age)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 1.00   26.00   34.00   36.56   45.00  107.00 

# reploting deaths by age, since age is numeric, fill doesn't work the same :(
pdf("figures/Deaths_By_Age")
deaths_by_age_2.qplot <- qplot(age, data = mpv_4.1, color = "black", fill = "white")
dev.off()

deaths_by_age_2.qplot # why are my colors always weird?


#p <- ggplot(mpv_4, aes(x = age)) + 
    #geom_histogram(aes(y = ..count..)) +
    #stat_function(fun = dnorm, colour = "red",
   # arg = list(mean = mean(mpv_4$age),
              # sd = sd(mpv_4$age)) )

#p # Warning message: Removed 74 rows containing non-finite values (stat_bin)
#I can't get the curve to show the normal distribution; should fun = dnorm?



str(mpv_4.1) #4564 obs. of 19 variables, but what should binwindth be?

p <- ggplot(mpv_4.1, aes(x = age)) + 
    geom_histogram(aes(y = ..ncount..)) +
    geom_density(aes(y = ..scaled..)) +
    stat_function(fun = dnorm, colour = "red", args = list(mean = mean(mpv_4.1$age,
            na.rm = TRUE),
            sd = sd(mpv_4.1$age, na.rm = TRUE))) 


# help lab

ggplot(mpv_4.1, aes(x = age)) + 
    geom_histogram(aes(y = (..density..))) +
    geom_density() +
    stat_function(fun = dnorm, colour = "red", args = list(mean = mean(mpv_4.1$age,
                                                                       na.rm = TRUE),
                                                           sd = sd(mpv_4.1$age, na.rm = TRUE))) 


ggplot(mpv_4.1, aes(x = age)) + 
    geom_density() +
    stat_function(fun = dnorm, colour = "red", args = list(mean = mean(mpv_4.1$age,
                                                                       na.rm = TRUE),
                                                           sd = sd(mpv_4.1$age, na.rm = TRUE))) 



p # this took a really long time to figure out

mean(mpv_4.1$age)

# TRY THIS NEXT (but don't spend too much time):

#In this case, with N = 164 and the bin width as 0.1, the aesthetic for y in the smoothed line should be:
     y = ..density..*(164 * 0.1)
#Thus the following code produces a "density" line scaled for a histogram measured in frequency (aka count).

df1 <- data.frame(v = rnorm(164, mean = 9, sd = 1.5))
b1 <- seq(4.5, 12, by = 0.1)
hist.1a <- ggplot(df1, aes(x = v)) + 
    geom_histogram(aes(y = ..count..), breaks = b1, 
    fill = "blue", color = "black") + 
    geom_density(aes(y = ..density..*(164*0.1)))



# deaths by gender
# 5 gender categories:"Male", Female", NA, "Transgender", & "Unknown" 

class(mpv_2$gender) #is a character, should probably make it a factor
mpv_2$gender <- as.factor(mpv_2$gender) # now it's a factor

pdf("figures/Deaths_By_Gender")
deaths_by_gender.qplot <- qplot(gender, data = mpv_2, fill = gender)
dev.off()

deaths_by_gender.qplot # looks good, but consider putting %'s on each column


# deaths by date

pdf("figures/Deaths_By_Date")
deaths_by_date.qplot <- qplot(date, data = mpv_2)
dev.off()

deaths_by_date.qplot # break down my year & by month


# deaths by city - too big

#pdf("figures/Deaths_By_City")
#deaths_by_city.qplot <- qplot(city, data = mpv_2)
#dev.off()

#deaths_by_city.qplot

# deaths by state

pdf("figures/Deaths_By_State")
deaths_by_state.qplot <- qplot(state, data = mpv_2, fill = state)
dev.off()

deaths_by_state.qplot # CA is by far the highest, about twice as many deaths as 
# the second highest

# Maybe do something w/ zip codes just in CA? about 4638 for US
str(mpv_2$zip_code)

CA <- filter(mpv_2, state == "CA")
str(CA) # 764 obs.
CA # that's do-able

library(base) # need this for 
zip_CA <-arrange(CA, desc(zip_code)) 
# thinking this may be useful for identifying racially divided neighborhoods
View(zip_CA) # would like to plot this like a heat map


# deaths by agency 

summary(mpv_2$agency_responsible) #4638 obs., character
summary(unique(mpv_2$agency_responsible)) # 2091 obs., character

# try just looking at CA?
CA # 764 obs., from zip_code (above)

CA_agency <- arrange(CA, agency_responsible)

ggplot(CA_agency, aes(agency_responsible)) + geom_bar() # crappy looking but informative
# there are definately a few outlier agencies in CA - I'm guessing these are in
# cities w/ larger populations??


## Collapsing Variable Sub-Categories ####

# cause of death

unique(mpv_2$cause_of_death)
# 47 causes of death categoreis with obvious overlap

# first I'm going to have to combine some categories


# Uspecified COD categories - cause of death is unknown, undetermined, etc.

mpv_2$cause_of_death <-gsub("unknown|Undetermined|Unknown|Unreleased",
                            "Unspecified", mpv_2$cause_of_death)

unique(mpv_2$cause_of_death) # only 43 unique catagories; it worked


# Taser COD categories - it seems like a lot of the taser/beating overlap COD were older

mpv_2$cause_of_death <- gsub( "Taser|Bean bag|Bean bag, taser|Taser, 
                              Medical emergency|Tasered|Taser,
                              Beaten|Taser/Pepper spray/beaten|Pepper sprayed,
                              Taser, Beaten|Taser, Beaten|Taser, Physical Restraint", 
                              "Taser", mpv_2$cause_of_death)

unique(mpv_2$cause_of_death) # 35 unique catogories



# NOTE: for catagories w/ multiple COD, I did my best to read through the COD description
# & find the leading COD. 
# Examples: "Taser/Pepper spray/beaten" & "Gunshot, Taser, Pepper spray"     



# Beaten COD categories

mpv_2$cause_of_death <- gsub("Beating|Baton, Pepper Spray, Physical Restraint",
                             "Beaten", mpv_2$cause_of_death)

unique(mpv_2$cause_of_death) # 33 unique COD


# Gunshot COD categories

mpv_2$cause_of_death <- gsub("Gunshot, Taser|Gunshot, Vehicle|Gunshot, Stabbed|Gunshot, Taser, Pepper spray",
                             "Gunshot", mpv_2$cause_of_death)

unique(mpv_2$cause_of_death) # 29 unique COD



# Physical restraint & asphyxiation COD categories

mpv_2$cause_of_death <- gsub("Physical Restraint|Asphyxiated/Restrained|Death in custody|Physical restraint|Death in Custody|Asphyxiated|Asphyxiation",
                             "Physical Restraint/Asphyxiation", mpv_2$cause_of_death)
                             
unique(mpv_2$cause_of_death) # 23 unique COD




# Vehicle COD categories

#  Wow, several of these are where cops are just hitting pedestrians 
# (otherwise, mostly chases ending in crashes)

mpv_2$cause_of_death <- gsub("Vehicle|Struck by vehicle", "Vehicle",
                             mpv_2$cause_of_death)

unique(mpv_2$cause_of_death) # 22 unique COD


# Other COD Categories - only one incident

head(filter(mpv_2, cause_of_death == "Other")) # Micah Xavier Johnson
Micah <- filter(mpv_2, name =="Micah Xavier Johnson")
why_Micah <- select(Micah, -(age:cause_of_death), -(link_news_doc))
print(why_Micah$description) # I remember seeing this in the news

#[1] "Johnson killed five and wounded seven police officers and wounded two 
#non-police at an anti-violence protest, police said. Police killed him with a 
#robot with a bomb on it. More police died in the attack than any since 
#Sept. 11, 2001."

# so in this dataset "Other" = robot bomb

mpv_2$cause_of_death <- gsub("Other", "Robot Bomb", mpv_2$cause_of_death)

unique(mpv_2$cause_of_death) # still 22 unique categories


# Medical Emergency COD categories

mpv_2$cause_of_death <- gsub("Medical emergency|Medical emergency, Unspecified|Medical emergencys",
                             "Medical Emergency", mpv_2$cause_of_death)

unique(mpv_2$cause_of_death) # 19 unique categories


# Pepper Spray COD categories

# VERY suspicious as a COD b/c pepper spray is non-lethal
# plus, descriptions of death indicate other more likely causes of death

mpv_2$cause_of_death <- gsub("Pepper spray", "Pepper Spray", mpv_2$cause_of_death)    
    
unique(mpv_2$cause_of_death) # 18 unique categories


# Drowning COD categories

# "Drowned" was one incident that probably should be reclassified as neglect:
# Brandon Ellingson

# A state trooper handcuffed and arrested Brandon Ellingson for boating while 
# intoxicated. The state trooper handcuffed Ellingson and put the wrong type of 
# life jacket on him. Ellingson drowned in the lake.


mpv_2$cause_of_death <- gsub("Drowned", "Drowning", mpv_2$cause_of_death)

unique(mpv_2$cause_of_death) # 17 unique categories


# Smoke inhilation - one incident: Aaron Dumas 

# Killed when tactical officers of the Memphis police department threw tear gas
# chemicals into the house where they had chased Dumas, causing the house to 
# catch on fire, and burning him alive. Several neighbors had their house 
# damaged by the flames.


# Hanging - one incident: Zachary Goldson, no description in dataset
# Internet search: COD was strangulation; being investigated as homicide
# http://www.walb.com/story/24133833/death-of-brown-county-inmate-zachary-goldson-ruled-a-homicide

# Negligence & Neglect COD categories - will likely add more incidences to this

mpv_2$cause_of_death <- gsub("Negligence, failure to call paramedics when subject could not breathe due to asthma|Neglect",
                             "Negligence/Neglect", mpv_2$cause_of_death)

unique(mpv_2$cause_of_death) # 16 unique COD categories



## charges_brought categories####

# examines whether crimal charges were brought 
    # against victom or police?

# Originally 12 subcategories
#collapsing into "charged", "convicted_sentenced", "acquitted", "mistrial" or 
# "No Known Charges"
    # At least one of these seems to be charges brought against POLICE OFFICER,
    # not victom - need to further separate this later

#charged

mpv_2$charges_brought <- gsub("Charged with a crime", "charged", 
                              mpv_2$charges_brought)

unique(mpv_2$charges_brought) # 12 unique subcategories

# convicted_sentenced
# had trouble doing this all at once, so had to collapse a 1-2 at a time

mpv_2$charges_brought <- gsub(
"Charged, Convicted, Sentenced to 5 years in prison|Charged, Convicted to 2.5 years in prison",
                              "convicted_sentenced", mpv_2$charges_brought)

mpv_2$charges_brought <- gsub("Charged, Convicted, Sentenced to 4 years|Charged, Convicted, Sentenced to 6 years",
                              "convicted_sentenced", mpv_2$charges_brought) 


# this one is not collapsing 
mpv_2$charges_brought <- gsub(
"Charged, Convicted (two officers) of cruelty to an inmate, 
public records fraud, and perjury. Sentenced to one month in jail and three years’ probation",
"convicted_sentenced", mpv_2$charges_brought)

mpv_2$charges_brought <- gsub("Charged, Convicted, Sentenced to 5 years probation.|Charged, Convicted,
                              Sentenced to 18 months",
                              "convicted_sentenced", mpv_2$charges_brought)

mpv_2$charges_brought <- gsub("Charged, Convicted, Sentenced to 50 years",
                              "convicted_sentenced", mpv_2$charges_brought)
                              


unique(mpv_2$charges_brought)


# acquitted

# messed this up - accidently had "convicted_sentenced" instead of"aquitted"
# need to reload data to update

mpv_2$charges_brought <- gsub("Charged, Acquitted", "acquitted", 
                              mpv_2$charges_brought)


unique(mpv_2$charges_brought)



# mistrial
mpv_2$charges_brought <- gsub("charged, Mistrial declared", "mistrial",
                              mpv_2$charges_brought)

unique(mpv_2$charges_brought)


# "No Known Charges" - no collapsing needed, but check to see if victom or police



## Mental Illness variable ####

# > unique(mpv_2$mental_illness) 
# "Unknown"             "Yes"                 "Drug or alcohol use" "No"                 
# NA                    "yes"                 "Unknown "            "unknown" 

# 237 classifications of "Drug or alcohol use" under the mental_illness variable
# I will make another variable using tidyr for this b/c it doesn't belong here

# Unknown subcategory

mpv_2$mental_illness <- gsub("Unknown |unknown", "Unknown",
                              mpv_2$mental_illness)



unique(mpv_2$mental_illness) # collapsed from 8 to 6 subcategories


# Yes subcategory

mpv_2$mental_illness <- gsub("yes", "Yes",
                             mpv_2$mental_illness)

unique(mpv_2$mental_illness) # 5 subcategories



# what are these NA's?
MI_NA <- select(mpv_2, (mental_illness), -(name:link_news_doc))
MI_NA
tail(MI_NA)
unique(MI_NA) # NA's are listed as: <NA>


MI_justNA <- filter(mpv_2, mental_illness != "Yes | No | Drug or alcohol use | Unknown")
MI_justNA <- filter(mpv_2, mental_illness == "NA")

View(MI_justNA) # don't know what's happening here; try tidyr



## armed_unarmed variable ####

# seems fine:
# unique(mpv_2$armed_unarmed)
# [1] "Unarmed"         "Allegedly Armed" "Unclear"         "Vehicle"



## gender variable ####

unique(mpv_2$gender)
# [1] Male        Female      <NA>        Transgender Unknown    
# Levels: Female Male Transgender Unknown

# so I have 4 subcategories that I'm happy w/, but need to do something with the NA's
    # maybe add them to Unknown?




