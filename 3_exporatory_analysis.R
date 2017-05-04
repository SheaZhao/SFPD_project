## Exploratory Analysis ####
# 2 parts:
    # exploring variables
    # exploratory plots - w/ possible next steps commented 


## Exploring Variables ####

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




## Exploritory Plots ####

## deaths by race ####
deaths_by_race.qplot <- qplot(race, data = mpv_2, fill = race)
deaths_by_race.qplot 
# death rates by race in descending frequency: 
# white, black, hispanic, unknown race, asian, native american, pacific islander


# deaths by age
deaths_by_age.qplot <- qplot(age, data = mpv_2, fill = age)
deaths_by_age.qplot 
# pretty, but just realized that age is a character the plot is crap: 
# it's ploting ages as ordinal characters: 1, 10, 110,...2,20,21

typeof(mpv_2$age)

# I need to change it to numeric class before I can plot it properly

mpv_4 <- filter(mpv_2, !is.na(age))
unique(mpv_4$age) # no NA's, BUT there is a class called Unknown!
mpv_4.1 <- filter(mpv_4, age != "Unknown")
mpv_4.1$age <- as.numeric(mpv_4.1$age) # should be numeric now
mean(mpv_4.1$age) # is numeric
unique(mpv_4.1$age) # no NA's or Unknowns

summary(mpv_4.1$age)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 1.00   26.00   34.00   36.56   45.00  107.00 

# reploting deaths by age, since age is numeric, fill doesn't work the same :(
deaths_by_age_2.qplot <- qplot(age, data = mpv_4.1, color = "black", fill = "white")
deaths_by_age_2.qplot # why are my colors weird?


# plotting density vs. mean 
ggplot(mpv_4.1, aes(x = age)) + 
    geom_histogram(aes(y = (..density..))) +
    geom_density() +
    stat_function(fun = dnorm, colour = "red", 
                  args = list(mean = mean(mpv_4.1$age, na.rm = TRUE),
                              sd = sd(mpv_4.1$age, na.rm = TRUE))) 


ggplot(mpv_4.1, aes(x = age)) + 
    geom_density() +
    stat_function(fun = dnorm, colour = "red",
                  args = list(mean = mean(mpv_4.1$age, na.rm = TRUE),
                              sd = sd(mpv_4.1$age, na.rm = TRUE))) 
# this took a really long time to figure out
# And it tells us that the mean is ~ 37, but the highest density of deaths 
    # happen between the ages of 20- 30 it looks like
# So I should readjust my bins



## deaths by gender ####
# 5 gender categories:"Male", Female", NA, "Transgender", & "Unknown" 

class(mpv_2$gender) #is a character, should probably make it a factor
mpv_2$gender <- as.factor(mpv_2$gender) # now it's a factor

deaths_by_gender.qplot <- qplot(gender, data = mpv_2, fill = gender)
deaths_by_gender.qplot # looks good, but consider putting %'s on each column


## deaths by date ####


deaths_by_date.qplot <- qplot(date, data = mpv_2)
deaths_by_date.qplot # looks relatively steady - break down my year & by month


## deaths by city - too big, maybe just try CA ####

#deaths_by_city.qplot <- qplot(city, data = mpv_2)
#deaths_by_city.qplot


## deaths by state ####

deaths_by_state.qplot <- qplot(state, data = mpv_2, fill = state)
deaths_by_state.qplot # CA is by far the highest, about twice as many deaths as 
# the second highest

# Maybe do something w/ zip codes just in CA? 4638 for whole US
str(mpv_2$zip_code)

CA <- filter(mpv_2, state == "CA")
str(CA) # 764 obs.
CA # that's do-able

zip_CA <-arrange(CA, desc(zip_code)) 
# may be useful for identifying racially divided neighborhoods when combined w/
# census data
View(zip_CA) # would like to plot this like a heat map


## deaths by agency ####

summary(mpv_2$agency_responsible) #4638 obs., character
summary(unique(mpv_2$agency_responsible)) # 2091 unique obs., character

# try just looking at CA?
CA # 764 obs., from zip_code (above)
CA$agency_responsible

CA_agency <- arrange(CA, agency_responsible)

ggplot(CA_agency, aes(agency_responsible)) + geom_bar() # crappy looking but informative
# there are definately a few outlier agencies in CA - I'm guessing these are in
# cities w/ larger populations??