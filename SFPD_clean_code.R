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

pdf("figures/Deaths_By_Age")
deaths_by_age.qplot <- qplot(age, data = mpv_2, fill = age)
dev.off()

deaths_by_age.qplot

typeof(mpv_2$age)

# it says that age is a character, I need to change it to numeric class before
# I can plot it properly w/ ggplot

mpv_4 <- filter(mpv_2, !is.na(age))
unique(mpv_4$age) # no NA's
mean(mpv_4$age) # works


#p <- ggplot(mpv_4, aes(x = age)) + 
    #geom_histogram(aes(y = ..count..)) +
    #stat_function(fun = dnorm, colour = "red",
   # arg = list(mean = mean(mpv_4$age),
              # sd = sd(mpv_4$age)) )

#p # Warning message: Removed 74 rows containing non-finite values (stat_bin)
#I can't get the curve to show the normal distribution; should fun = dnorm?



summary(mpv_2$age)
#  Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
# 1.00   20.00   28.00   31.55   40.00   88.00      11 

p <- ggplot(mpv_4, aes(x = age)) + 
    geom_histogram(aes(y = ..ncount..)) +
    geom_density(aes(y = ..scaled..)) +
    stat_function(fun = dnorm, colour = "red", arg = list(mean = mean(mpv_4$age,
            na.rm = TRUE),
            sd = sd(mpv_4$age, na.rm = TRUE))) 

p # this took a really long time to figure out



# TRY THIS NEXT (but don't spend too much time - also look for inspo):

#In this case, with N = 164 and the bin width as 0.1, the aesthetic for y in the smoothed line should be:
     y = ..density..*(164 * 0.1)
#Thus the following code produces a "density" line scaled for a histogram measured in frequency (aka count).

df1 <- data.frame(v = rnorm(164, mean = 9, sd = 1.5))
b1 <- seq(4.5, 12, by = 0.1)
hist.1a <- ggplot(df1, aes(x = v)) + 
    geom_histogram(aes(y = ..count..), breaks = b1, 
    fill = "blue", color = "black") + 
    geom_density(aes(y = ..density..*(164*0.1)))
                   