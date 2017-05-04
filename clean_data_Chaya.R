## Load & Install Packages####

install.packages("littler")
install.packages(c("dplyr", "ggvis", "ggplot2", "tidyr"))

my_packages <- c("littler", "dplyr","ggvis", "ggplot2", "tidyr")

lapply(my_packages, require, character.only = TRUE)

installed.packages() # show loaded packages - optional


## Import Data ####
# Download the dataset named "mpv_2" & then load it into rstudio:
# https://www.dropbox.com/sh/5ll7c9jivtva5zm/AABiO3GM9iTMN1Uv9Gl8yFG8a?dl=0

# 1.) Why California? 
deaths_by_state.qplot <- qplot(state, data = mpv_2, fill = state)
deaths_by_state.qplot # CA has by far the highest number of deaths, about twice as many deaths as the second highest

str(mpv_2$zip_code) # There are 4638 for whole US - too much given our time the scope of this project

# Maybe we can build a prediction model just using CA data?
CA <- filter(mpv_2, state == "CA") # here I'm making a datafram called CA - all other state's data is removed
str(CA) # it has 764 obs., that's do-able for us


zip_CA <-arrange(CA, desc(zip_code)) # I'm arranging the zip codes in descending order 
# may be useful for identifying racially divided neighborhoods when combined w/ census data
View(zip_CA) # let's look at it


## deaths by agency ####

# Maybe we can build a predicion model for agencies?

summary(mpv_2$agency_responsible) #there are 4638 obs., classified as character
summary(unique(mpv_2$agency_responsible)) # 2091 unique obs., character

# We want to plot death count by agency in CA
# first, I'm going to make a dataframe with all the rows arranged by agency (this just means the agency_responsible column is in alphabetical order)
CA_agency <- arrange(CA, agency_responsible) 
View(CA_agency) # now let's plot it


ggplot(CA_agency, aes(agency_responsible)) + geom_bar() # crappy looking but informative
# there are definately a few outlier agencies in CA - I'm guessing these are in cities w/ larger populations??



