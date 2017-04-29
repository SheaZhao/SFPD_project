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
