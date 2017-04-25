## let's sort the Monitoring Polic Violence data before we graph it ####


## deaths by race ####
# first, how many different subsets are working with?

unique(mpv_race)

#mpv..Victim.s.race.
#1                White
#5                Black
#11            Hispanic
#12     Native American
#21               Asian
#27        Unknown race
#65    Pacific Islander


death_race <- summarize(mpv_race,
                        Total = n(),
                        White = n_distinct(Victims.s.race)
                        )
death_race

head(mpv_race)
tail(mpv_race)


head(mpv_cities)


filter(mpv, Location.of.death..city.)

colnames(mpv)



# going to try saving mpv dataset as csv, importing it again, and trying dplyr functions


# also going to restart rstudio b/c i'm having trouble pushing to github

