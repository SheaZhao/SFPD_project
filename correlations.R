## deaths by age, fill & facet race - cut() into age groups first ####
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

# I should change the death counts to death frequency - then I can view all races at once
age_race_freq <- mpv_4.2 %>%
    group_by(race, age) %>%
    summarise(n = n()) %>%
    mutate(freq = n/sum(n))
View(age_race_freq)

# For freq deaths by race w/ continuious age, use deaths_by_race.3
deaths_by_race.3 <- mpv_4.1 %>%
    group_by(race, age) %>%
    summarise(n = n()) %>%
    mutate(freq = n / sum(n))
View(deaths_by_race.3)
colnames(deaths_by_race.3)

# may need to take the log of freq
qplot(data = deaths_by_race.3, age, freq, geom = c("point", "smooth"))
qplot(data = deaths_by_race.3, age, freq, geom = c("point", "smooth"), method = "lm")
qplot(data = deaths_by_race.3, age, freq, color = race, geom = "smooth", se = FALSE)
qplot(data = deaths_by_race.3, age, freq, color = race, geom = "smooth", method = "lm", se = FALSE)
#qplot(data = deaths_by_race.3, age, freq, facets = .~ race, color = race, geom = c("point", "smooth"))
#qplot(data = deaths_by_race.3, age, freq, facets = race ~., color = race, geom = c("point", "smooth"))
#qplot(data = age_race_freq, age, freq, color = race, size = freq) # nice
# plot(freq ~ age, data = deaths_by_race.3)
plot(freq ~ age, data = age_race_freq) #YES
#qplot(data = age_race_freq, race, age, color = race, size = freq)
#qplot(data = age_race_freq, race, freq, facets = .~ age, color = race, size = freq) # nice

# CANNOT MAKE A BOXPLOT -let's plot age ranges against freq using box plots
#qplot(data = age_race_freq, aes(x = race, y = freq ) + geom_boxplot())
# boxplot(mpv_2$race)
    #maybe try logs?



## deaths by armed/unarmed, fill & facet race ####
    # box plot for armed categories
    # lm for facets

ggplot(mpv_4.1, aes(armed_unarmed, age)) +
    geom_violin(scale = "area")

ggplot(mpv_4.1, aes(armed_unarmed, age, fill = armed_unarmed)) +
    geom_violin(scale = "area") +
    facet_grid(.~race)

ggplot(mpv_4.1, aes(armed_unarmed, age, fill = armed_unarmed)) +
    geom_boxplot()

# separate armed_unarmed levels, then plot by race
ggplot(mpv_4.1, aes(race, age, fill = race)) +
    geom_boxplot() + 
    facet_grid(armed_unarmed~.)

ggplot(mpv_4.1, aes(armed_unarmed, age, fill = armed_unarmed)) +
    geom_boxplot() +
    facet_grid(.~race)


armed_BY_race_age <- mpv_4.1 %>%
    group_by(armed_unarmed, race, age) %>%
    summarise(n = n()) %>%
    mutate(freq = n / sum(n))
View(armed_BY_race_age)
colnames(armed_BY_race_age)

ggplot(armed_BY_race_age, aes(age, freq)) +
    coord_cartesian(ylim = c(0, .3)) +
    geom_point() +
    geom_smooth(method = "lm") +
    facet_grid(armed_unarmed~race)


## COD by race, fill & facet by race ####
    # box plot for COD, fill = race
    # lm for facets

ggplot(mpv_4.1, aes(cause_of_death, age, fill = cause_of_death)) +
    geom_violin(scale = "area")

ggplot(mpv_4.1, aes(cause_of_death, age, fill = cause_of_death)) +
    geom_boxplot()

#ggplot(mpv_4.1, aes(cause_of_death, age, fill = cause_of_death)) +
    #geom_boxplot() +
    #facet_grid(armed_unarmed~race)


