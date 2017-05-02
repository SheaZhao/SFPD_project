# 1. Do police deaths differ by race/gender/age?

#race - yes

#race - count/frequency####
# a basic plot of death by race makes that obvious
deaths_by_race.qplot <- qplot(race, data = mpv_2, fill = race)
deaths_by_race.qplot 

# But I want to plot the counts & ratios of deaths by race
# first I'll get the counts of death by race
deaths_by_race <- mpv_2 %>%
    group_by(race) %>%
    summarise (count = n())
View(deaths_by_race)


deaths_by_race.2 <- mpv_2 %>%
    group_by(race) %>%
    summarise(n = n()) %>%
    mutate(freq = n / sum(n))
View(deaths_by_race.2)

# plot the rate of death by race
# real count
deaths_by_race.ggvis <- deaths_by_race %>%
    ggvis(x = ~race, y = ~count, fill = ~race) 
deaths_by_race.ggvis

# frequency plot - by race 
deaths_by_race.2.ggvis <- deaths_by_race.2 %>%
    ggvis(x = ~race, y = ~freq, fill = ~race)
deaths_by_race.2.ggvis


#frequency data frame

race_COD <- mpv_2 %>%
    group_by(race, cause_of_death) %>%
    summarise(n = n()) %>%
    mutate(freq = n / sum(n))
View(race_COD)

# freq plot by COD
race_COD.ggvis <- race_COD %>%
    ggvis(x = ~cause_of_death, y = ~freq, fill = ~race) %>%
    layer_points()
race_COD.ggvis # not very clear
# gunshot deaths are an outlier, so let's look at gunshot vs non-gunshot deaths

race_by_COD<- race_COD %>%
    select(race, cause_of_death, freq)
View(race_by_COD)

race_COD_spread <- spread(race_by_COD,cause_of_death, freq)
View(race_COD_spread)  

## each COD ploted by freq, fill = race ####

# plot Gunshot freq by race    
race_COD_Gunshot.ggvis <- race_COD_spread %>%
    ggvis(x = ~race, y = ~Gunshot, fill = ~race)
race_COD_Gunshot.ggvis 
# not a huge difference 


# plot Physical Restraint/Asphyxiation freq by race    
race_COD_PrA.ggvis <- race_COD_spread %>%
    ggvis(x = ~race, y = ~`Physical Restraint/Asphyxiation`, fill = ~race)
race_COD_PrA.ggvis 
# Pacific Islanders have outragiously high incidents of strangulation deaths
# second highest rates are among Blacks


# plot Unspecified freq by race    
race_COD_Unspecified.ggvis <- race_COD_spread %>%
    ggvis(x = ~race, y = ~Unspecified, fill = ~race)
race_COD_Unspecified.ggvis 
# again, pacific Islanders have the outragiously high rates
# followed by Asians, Blacks, Hispanics, Unknown - Whites have the lowest


# plot Medical Emergencyfreq by race    
race_COD_MedE.ggvis <- race_COD_spread %>%
    ggvis(x = ~race, y = ~`Medical Emergency`, fill = ~race)
race_COD_MedE.ggvis 
# again, Pacific Islanders have extremely high rates of Med E compared to others
# followed by Hispanics, Blanks, Unknown - White have lowest


# plot Pepper Spray freq by race    
race_COD_PepSpray.ggvis <- race_COD_spread %>%
    ggvis(x = ~race, y = ~`Pepper Spray`, fill = ~race)
race_COD_PepSpray.ggvis 
# Blacks have the highest rates of deaths by Pepper Spray
# followed closely by Hispanics & Unknown - Whites are lowest
# This is very suspicious COD b/c pepper spray is not leathal!


# plot Taser freq by race    
race_COD_Taser.ggvis <- race_COD_spread %>%
    ggvis(x = ~race, y = ~Taser, fill = ~race)
race_COD_Taser.ggvis 
# Blacks have the highest rates of death followed by Hispanics, Whites,
# Unknown, Asian, Native Americans


# plot Vehicle freq by race - 263 deaths 
race_COD_Vehicle.ggvis <- race_COD_spread %>%
    ggvis(x = ~race, y = ~Vehicle, fill = ~race)
race_COD_Vehicle.ggvis 
# Unknown race has the highest rate of death by vehicle 
# followed by Asian, Black, White, Native American, Hispanic
    # some of these deaths where from crashes - people running from cops
    # there are also a lot of deaths from cops just hitting people
    # might try to look through these subcategories?


# plot Beaten freq by race
race_COD_Beaten.ggvis <- race_COD_spread %>%
    ggvis(x = ~race, y = ~Beaten, fill = ~race)
race_COD_Beaten.ggvis 
# Native Americans have an extremely high incidence of being beaten to death
# followed by Asians, which - after Native Americans, are significantly higher 
# than other races


# Fall to death, Suicide, Hanging, Robot Bomb, Drowning, Drug Overdose,
# Smoke inhilation, & Negligence/Neglect only a couple of incidents each
# so not informative to plot

## Gunshot deaths vs non_Gunshot deaths ####

race_COD_temp <- race_COD

race_COD_temp$cause_of_death <- gsub("Physical Restraint/Asphyxiation %>%
                                     |Unspecified|Medical Emergency %>%
                                     |Pepper Spray|Fall to death|Suicide %>%
                                     |Hanging|Taser|Vehicle|Beaten|Robot Bomb %>%
                                     |Drowning|Drug Overdose|Smoke inhilation %>%
                                     |Negligence/Neglect", 
                                     "non_Gunshot", race_COD_temp$cause_of_death)
# still not working 
# > unique(race_COD_temp$cause_of_death)
# [1] "non_Gunshot"             "Gunshot"                 "non_Gunshot/non_Gunshot"
# [4] "Negligence/non_Gunshot" 

race_COD_temp$cause_of_death <- gsub("non_Gunshot/non_Gunshot|Negligence/non_Gunshot",
                                     "non_Gunshot", race_COD_temp$cause_of_death)

unique(race_COD_temp$cause_of_death) 
# had to do it twice - still having trouble collapsing categories 
# but it's done - just 2 variable: Gunshot & non_Gunshot
View(race_COD_temp) 

# plot Gun deaths vs non_Gundeaths

Gun_nonGun.ggvis <- race_COD_temp %>%
    ggvis(x = ~race, y = ~ freq, fill = ~cause_of_death)
Gun_nonGun.ggvis # not much difference, should just look at non_Gunshot deaths


race_COD_temp_2 <- filter(race_COD_temp, cause_of_death == "non_Gunshot")

non_Gun.ggvis <- race_COD_temp_2 %>%
    ggvis(x = ~race, y = ~ freq, fill = ~race)
non_Gun.ggvis # much better!
# Pacific Islanders, Blacks, & Asians are most likely to have non_Gun COD's
# raltive to Hispanics, Whites, & Native Americans


## armed deaths vs unarmed deaths ####

# > unique(mpv_2$armed_unarmed)
# [1] "Unarmed"         "Allegedly Armed" "Unclear"         "Vehicle"  

# group by armed_unarmed sub-category
armed_unarmed_deaths <- mpv_2 %>%
    group_by(armed_unarmed, race) %>%
    summarise(n = n()) %>%
    mutate(freq = n / sum(n))
View(armed_unarmed_deaths)


# plot armed vs. unarmed by freq, fill = race
armed_unarmed_deaths.ggvis <- armed_unarmed_deaths %>%
    ggvis(x = ~armed_unarmed, y = ~freq, fill = ~race) 
armed_unarmed_deaths.ggvis
# White's overwhelmingly armed



# group by race
races_armed <- spread(armed_unarmed_deaths, race, freq)
View(races_armed)


# plot armed vs. unarmed by race

# Asians
races_armed.ggvis <- races_armed %>%
    ggvis(x = ~armed_unarmed, y = ~Asian, fill = ~armed_unarmed) 
races_armed.ggvis
# Asians have high allegedly armed & unclear
# about 10% were in a vehicle & about 5% were unarmed 
# about 15% die by gunshot


# Blacks
races_armed.ggvis <- races_armed %>%
    ggvis(x = ~armed_unarmed, y = ~Black, fill = ~armed_unarmed) 
races_armed.ggvis
# Blacks are highly unarmed, in a vehicle, or unclear
# less than 25% are armed
# about 17% die by gunshot


# Hispanics
races_armed.ggvis <- races_armed %>%
    ggvis(x = ~armed_unarmed, y = ~Hispanic, fill = ~armed_unarmed) 
races_armed.ggvis
# Hispanics are mostly in the unclear, 
# with about 15%, 16%, & 17% allegedly armed, unarmed, or vehicle, respectively
# between 11-12% die of gunshots


# Native Americans
races_armed.ggvis <- races_armed %>%
    ggvis(x = ~armed_unarmed, y = ~Native Americans, fill = ~armed_unarmed) 
races_armed.ggvis
# Native Americans are classified as about 21.5% unclear
# about 16% Allegedly armed, 17% unclear, 13% vehicle
# about 9.5% die of gunshot


# Pacific Islander
races_armed.ggvis <- races_armed %>%
    ggvis(x = ~armed_unarmed, y = ~`Pacific Islander`, fill = ~armed_unarmed) 
races_armed.ggvis
# Pacific Islanders are mostly in Vehicles when they die
# have the highest rates of death by gunshot

# Unknown races
races_armed.ggvis <- races_armed %>%
    ggvis(x = ~armed_unarmed, y = ~`Unknown race`, fill = ~armed_unarmed) 
races_armed.ggvis
# highly alleged to be armed or are in a vehicle


#Whites
races_armed.ggvis <- races_armed %>%
    ggvis(x = ~armed_unarmed, y = ~White, fill = ~armed_unarmed) 
races_armed.ggvis
# whites are highly armed, but little variation between unarmed, unclear, & vehicle





## mental illness related deaths ####
## intoxication related deaths ####
## ratio of children killed ####
## Deeper look into pepper spray deaths ####

# armed or unarmed?
# mental illness - if time
# intoxication/drugs - if time

