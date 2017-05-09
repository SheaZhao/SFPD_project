class(mpv_2$age) # character, but I already have a dataframe where it's numeric:

# I've made lot's of changes to mpv_2 since I made mpv_4, so first I'll re-run
# the code below

mpv_4 <- filter(mpv_2, !is.na(age))
unique(mpv_4$age) # no NA's, BUT there is a class called Unknown!
mpv_4.1 <- filter(mpv_4, age != "Unknown")
mpv_4.1$age <- as.numeric(mpv_4.1$age) # should be numeric now
mean(mpv_4.1$age) # is numeric
unique(mpv_4.1$age) # no NA's or Unknowns

mpv_4K <- filter(mpv_4.1, age <= 17)
unique(mpv_4K$age)

# add a frequency count

child_deaths <- mpv_4K %>%
    group_by(race) %>%
    summarise(n = n()) %>%
    mutate(freq = n / sum(n))
View(child_deaths)

child_deaths.ggvis <- child_deaths %>%
    ggvis(x = ~race, y = ~freq, fill = ~race) 
child_deaths.ggvis
# Although Whites greatly outnumber Blacks in overall frequency in the data
# young adult blacks are have higher incidence of being killed by cops



# look at young adults 18-25 years - look-up common age ranges used in reasearch
mpv_4YA <- filter(mpv_4.1, age == 18:25)
unique(mpv_4YA$age)

young_adult_deaths <- mpv_4YA %>%
    group_by(race) %>%
    summarise(n = n()) %>%
    mutate(freq = n/ sum(n))
View(young_adult_deaths)
# again young adult blacks are have higher incidence of being killed by cops
# the disparity of deaths amoungst young Black adults increases greatly from child deaths


# adults 26-35 - let's just look at every 10 years to see what happens
mpv_4_26.35 <- filter(mpv_4.1, age == 26:35)
unique(mpv_4_26.35$age)

adult_deaths_26.35 <- mpv_4_26.35 %>%
    group_by(race) %>%
    summarise(n = n()) %>%
    mutate(freq = n/ sum(n))
View(adult_deaths_26.35)
# very interesting - disparity Black-White deaths is now reversed in just 10 years - did not expect this


# adults 36-45 
mpv_4_36.45 <- filter(mpv_4.1, age == 36:45)
unique(mpv_4_36.45$age)

adult_deaths_36.45 <- mpv_4_36.45 %>%
    group_by(race) %>%
    summarise(n = n()) %>%
    mutate(freq = n/ sum(n))
View(adult_deaths_36.45)
# Black & Hispanic deaths are decresing in frequency & White deaths are basically constant


# adults 46-55
mpv_4_46.55 <- filter(mpv_4.1, age == 46:55)
unique(mpv_4_46.55$age)

adult_deaths_46.55 <- mpv_4_46.55 %>%
    group_by(race) %>%
    summarise(n = n()) %>%
    mutate(freq = n/ sum(n))
View(adult_deaths_46.55)
# All deaths are declining in frequency


# adults 56-65
mpv_4_56.65 <- filter(mpv_4.1, age == 56:65)
unique(mpv_4_56.65$age)

adult_deaths_56.65 <- mpv_4_56.65 %>%
    group_by(race) %>%
    summarise(n = n()) %>%
    mutate(freq = n/ sum(n))
View(adult_deaths_56.65)


# adults 66+
mpv_4_66 <- filter(mpv_4.1, age >= 66)
unique(mpv_4_66)

adult_deaths_66 <- mpv_4_66 %>%
    group_by(race) %>%
    summarise(n = n()) %>%
    mutate(freq = n/ sum(n))
View(adult_deaths_66)
# about 67% white



