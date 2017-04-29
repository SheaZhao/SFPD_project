## Exploratory Analysis ####
# 2 parts:
    # exploring variables
    # exploratory plots


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




## Exploritory Plots ####

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