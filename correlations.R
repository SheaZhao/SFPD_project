# deaths by age, fill & facet race - cut() into age groups first
    # box plot for age categories
    # lm for facets

mpv_4.1 # use this dataframe for age

mpv_4.2 <- mpv_4.1 # want to preserve mpv_4.1

# group ages using cut()
mpv_4.2$age <- cut(mpv_4.2$age, 
               breaks = c(0, 18, 25, 35, 45, 55, 65, 120), 
               lables = c("0-18 years", "18-25 years", "25-35 years", "35-45 years", "45-55 years", "55-65 years", "66 year or older"),
               right = FALSE)
levels(mpv_4.2$age)
View(mpv_4.2$age)

# much broader range for white, black, hispanic levels 
qplot(data = mpv_4.2, age, fill = age,
      facets = race~.)

# so will look at them seperatly
target_WBH <- c("White", "Black", "Hispanic")
WBH_race_age <- filter(mpv_4.2, race %in% target_WBH )
unique(WBH_race_age$race) # it worked

target_OTHER <- c("Asian", "Native American", "Pacific Islander", "Unknown race")
Other_race_age <- filter(mpv_4.2, race %in% target_OTHER)
unique(Other_race_age$race) # it worked

# now let's plot BWH & Other
qplot(data = WBH_race_age, age, fill = age,
      facets = race~.)

qplot(data = Other_race_age, age, fill = age,
      facets = race~.)

# I should change the death counts to death frequency





# deaths by armed/unarmed, fill & facet race
    # box plot for armed categories
    # lm for facets

# COD by race, fill & facet by race
    # box plot for COD, fill = race
    # lm for facets

