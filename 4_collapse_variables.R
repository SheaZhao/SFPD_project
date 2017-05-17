#Collapsing Variable Categories & Sub-Categories

## cause of death ####

unique(mpv_2$cause_of_death)
# 47 causes of death categoreis with obvious overlap

# first I'm going to have to combine some categories


# Uspecified COD categories - cause of death is unknown, undetermined, etc.

mpv_2$cause_of_death <-gsub("unknown|Undetermined|Unknown|Unreleased",
                            "Unspecified", mpv_2$cause_of_death)

unique(mpv_2$cause_of_death) # only 43 unique catagories; it worked


# Taser COD categories - it seems like a lot of the taser/beating overlap COD were older

mpv_2$cause_of_death <- gsub( "Taser|Bean bag|Bean bag, taser|Taser, Medical Emergency|Tasered|Taser,
                              Beaten|Taser/Pepper spray/beaten|Pepper Sprayed, Taser, beaten|Taser, Beaten|Taser, Physical Restraint", 
                              "Taser", mpv_2$cause_of_death)

unique(mpv_2$cause_of_death) # 35 unique catogories



# NOTE: for catagories w/ multiple COD, I did my best to read through the COD description
# & find the leading COD. 
# Examples: "Taser/Pepper spray/beaten" & "Gunshot, Taser, Pepper spray"     



## Beaten COD categories ####

mpv_2$cause_of_death <- gsub("Beating|Baton, Pepper Spray, Physical Restraint",
                             "Beaten", mpv_2$cause_of_death)

unique(mpv_2$cause_of_death) # 33 unique COD


## Gunshot COD categories ####

mpv_2$cause_of_death <- gsub("Gunshot, Taser|Gunshot, Vehicle|Gunshot, Stabbed|Gunshot, Taser, Pepper spray",
                             "Gunshot", mpv_2$cause_of_death)

unique(mpv_2$cause_of_death) # 29 unique COD



## Physical restraint & asphyxiation COD categories ####

mpv_2$cause_of_death <- gsub("Physical Restraint|Asphyxiated/Restrained|Death in custody|Physical restraint|Death in Custody|Asphyxiated|Asphyxiation",
                             "Physical Restraint/Asphyxiation", mpv_2$cause_of_death)

unique(mpv_2$cause_of_death) # 23 unique COD

# didn't work quite right - needed grep
mpv_2$cause_of_death[grep("Physical Restraint", mpv_2$cause_of_death)] <- "Physical Restraint/Asphyxiation"

mpv_2$cause_of_death[grep("Asphyxiated ", mpv_2$cause_of_death)] <- "Physical Restraint/Asphyxiation"

mpv_2$cause_of_death[grep("Physical Restraint/Asphyxiation/Physical Restraint/Asphyxiation", mpv_2$cause_of_death)] <- "Physical Restraint/Asphyxiation"



## Vehicle COD categories ####

#  Wow, several of these are where cops are just hitting pedestrians 
# (otherwise, mostly chases ending in crashes)

mpv_2$cause_of_death <- gsub("Vehicle|Struck by vehicle", "Vehicle",
                             mpv_2$cause_of_death)

unique(mpv_2$cause_of_death) # 22 unique COD


## "Other" COD categories - only one incident ####

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


## Medical Emergency COD categories ####

mpv_2$cause_of_death <- gsub("Medical emergency|Medical emergency, Unspecified|Medical emergencys",
                             "Medical Emergency", mpv_2$cause_of_death)

unique(mpv_2$cause_of_death) # 19 unique categories


## Pepper Spray COD categories ####

# VERY suspicious as a COD b/c pepper spray is non-lethal
# plus, descriptions of death indicate other more likely causes of death

mpv_2$cause_of_death <- gsub("Pepper spray", "Pepper Spray", mpv_2$cause_of_death)    

unique(mpv_2$cause_of_death) # 18 unique categories


## Drowning COD categories ####

# "Drowned" was one incident that probably should be reclassified as neglect:
# Brandon Ellingson

# A state trooper handcuffed and arrested Brandon Ellingson for boating while 
# intoxicated. The state trooper handcuffed Ellingson and put the wrong type of 
# life jacket on him. Ellingson drowned in the lake.


mpv_2$cause_of_death <- gsub("Drowned", "Drowning", mpv_2$cause_of_death)

unique(mpv_2$cause_of_death) # 17 unique categories


## Smoke inhilation - one incident: Aaron Dumas ####

# Killed when tactical officers of the Memphis police department threw tear gas
# chemicals into the house where they had chased Dumas, causing the house to 
# catch on fire, and burning him alive. Several neighbors had their house 
# damaged by the flames.


# Hanging - one incident: Zachary Goldson, no description in dataset ####
# Internet search: COD was strangulation; being investigated as homicide
# http://www.walb.com/story/24133833/death-of-brown-county-inmate-zachary-goldson-ruled-a-homicide

# Negligence & Neglect COD categories ####
# will likely add more incidences to this

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

# walk in help
grep() 
mpv_2$charges_brought[grep("Charged, ", mpv_2$charges_brought)] <- "convicted_sentenced"



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
unique(MI_NA) # NA's are listed as: <NA>
tail(MI_NA)
head(MI_NA)


MI_justNA <- filter(mpv_2, mental_illness != "Yes" | "No" | "Drug or alcohol use" | "Unknown")
MI_justNA <- filter(mpv_2, mental_illness == "NA")

View(MI_justNA) # don't know what's happening here; try tidyr?

## walk-in consulting help - maybe need to change it to a data frame?
MI_NA.2 <- as.data.frame(MI_NA)
head(MI_NA.2) #looks fine
class(MI_NA.2) # is a data frame
unique(MI_NA)

MI_whole <- filter(MI_NA.2, !is.na(mental_illness)) # how is mental illness not found?
MI_whole <- na.omit(MI_NA.2)
unique(MI_whole)



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




