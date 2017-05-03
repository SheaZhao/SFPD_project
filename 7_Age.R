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

