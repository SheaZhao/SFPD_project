# install and load packages
install.packages("littler")
install.packages(c("dplyr", "ggplot2", "igraph"))

my_packages <- c("littler", "dplyr", "ggplot2", "igraph")

lapply(my_packages, require, character.only = TRUE)

installed.packages() # show loaded packages

# load data and store it in a variable

library(readr)
SFPD_Incidents_from_1_January_2003 <- read_csv("~/Documents/stanford_classes/data_sci/SFPD_project_final/data/SFPD_Incidents_-_from_1_January_2003.csv")
View(SFPD_Incidents_from_1_January_2003)

incident.data <- data.frame(SFPD_Incidents_from_1_January_2003)

str(incident.data) # data frame w/ 2049678 obs. of  13 variables

head(incident.data)

colnames(incident.data)
# [1] "IncidntNum" "Category"   "Descript"   "DayOfWeek"  "Date"      
# [6] "Time"       "PdDistrict" "Resolution" "Address"    "X"         
# [11] "Y"          "Location"   "PdId"  

# category, descript, location, & resolution seem interesting

# lets check out some DOJ stats

library(readr)
arrest_data <- read_csv("~/Documents/stanford_classes/data_sci/SFPD_project_final/data/arrest_data_2005-2014.csv")
View(arrest_data_2005_2014)

str(arrest_data) # Classes ‘tbl_df’, ‘tbl’ and 'data.frame':238685 obs.of 82 variables

colnames(arrest_data)

# there are a bunch of weird variable names: "SCO01_sum" etc.
# downloaded arrest variables discriptions

# But to gain a more complete picture of what happens when police are called,
# especially, when people are taken into custody, other data is needed


# data from mapping police violence

library(readxl)
mpv <- read_excel("~/Documents/stanford_classes/data_sci/SFPD_project_final/data/MPVDatasetDownload.xlsx")
View(MPVDatasetDownload)

str(mpv)

colnames(mpv) # quite a few variables

#[1] "Victim's name"                                                 
#[2] "Victim's age"                                                  
#[3] "Victim's gender"                                               
#[4] "Victim's race"                                                 
#[5] "URL of image of victim"                                        
#[6] "Date of injury resulting in death (month/day/year)"            
#[7] "Location of injury (address)"                                  
#[8] "Location of death (city)"                                      
#[9] "Location of death (state)"                                     
#[10] "Location of death (zip code)"                                  
#[11] "Location of death (county)"                                    
#[12] "Agency responsible for death"                                  
#[13] "Cause of death"                                                
#[14] "A brief description of the circumstances surrounding the death"
#[15] "Official disposition of death (justified or other)"            
#[16] "Criminal Charges?"                                             
#[17] "Link to news article or photo of official document"            
#[18] "Symptoms of mental illness?"                                   
#[19] "Unarmed"    




# Also I want to look at violence by gender, age, race, armed, mental illness

unique(mpv$`Location of death (city)`) # any deaths in this dataset from SF?

# OK that's too big too look through. Let's look by state first

unique(mpv$`Location of death (state)`) # wondering how are states codes?

# they are abreviations & we have CA

# dplyr doesn't like the "of" in variable names. keeps giving me this error:
# Error: unexpected symbol in "filter(mpv, Location of"

# so I'm going to make a couple of better named objects to contain these variables

mpv_states <- data.frame(mpv$`Location of death (state)`)

mpv_cities <- data.frame(mpv$`Location of death (city)`)


# OK, dplyr also doesn't like the space in "San Francisco"; so need to make another object

mpv_SF <- data.frame(mpv$`Location of death (city)`, list = character('San Francisco'))

mpv_SF # fyi: [1] "mpv$`Location of death (city)` == \"San\" + \"Francisco\""

# Finally, it works. And apperently I have some NAs to deal with:
    # Error in character("San Francisco") : vector size cannot be NA/NaN
    # In addition: Warning message:
    # In character("San Francisco") : NAs introduced by coercion


# now I need to make objects for gender, race, etc.

mpv_gender <- data.frame(mpv$`Victim's gender`)

mpv_race <- data.frame(mpv$`Victim's race`)

mpv_unarmed <- data.frame(mpv$Unarmed)

mpv_death_cause <- data.frame(mpv$`Cause of death`)

mpv_agency <- data.frame(mpv$`Agency responsible for death`)

mpv_justified <- data.frame(mpv$`Official disposition of death (justified or other)`)

mpv_mental_illness <- data.frame(mpv$`Symptoms of mental illness?`)

mpv_date <- data.frame(mpv$`Date of injury resulting in death (month/day/year)`)

