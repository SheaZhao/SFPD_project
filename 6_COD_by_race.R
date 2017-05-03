## Load & Install Packages####

install.packages("littler")
install.packages(c("dplyr", "ggvis", "ggplot2", "tidyr"))

my_packages <- c("littler", "dplyr","ggvis", "ggplot2", "tidyr")

lapply(my_packages, require, character.only = TRUE)

installed.packages() # show loaded packages - optional


## Import Data ####
# You will need to download the following datasets & then load them into rstudio

# these will be used to look at deaths by race, regardless of COD
deaths_by_race  # shows races & death counts
deaths_by_race.2  # shows races, death counts, & death frequencies
mpv_2 # if you'd like to see a cleaned version of the broader data set

# we will use these to take a closer look at correlations between race & COD
race_COD  # variables are race, frequency, n (real count), cause of death
race_COD_spread  # COD's are spread to become variables w/ race

race_COD_temp # just compairing gun deaths to non-gun deaths
race_COD_temp_2 # just compairing gun deaths to non-gun deaths

# these data frames look at whether people were armed or unarmed when they were killed
armed_unarmed_deaths  # race is a variable
races_armed  # race is spread into it's subcategories - White, Black, etc.


## Deaths - real counts vs frequencies ####
# We want to know the real count of deaths by race & the frequency of deaths by race

# real count - just so you can have a look
deaths_by_race <- mpv_2 %>%
    group_by(race) %>%
    summarise (count = n())
View(deaths_by_race)

# frequency - just so you can have a look
deaths_by_race.2 <- mpv_2 %>%
    group_by(race) %>%
    summarise(n = n()) %>%
    mutate(freq = n / sum(n))
View(deaths_by_race.2)


# plot the rate of death by race - real count
deaths_by_race.ggvis <- deaths_by_race %>%
    ggvis(x = ~race, y = ~count, fill = ~race) 
deaths_by_race.ggvis


# plot the rate of death by race - frequency plot
deaths_by_race.2.ggvis <- deaths_by_race.2 %>%
    ggvis(x = ~race, y = ~freq, fill = ~race)
deaths_by_race.2.ggvis


## Research Questions ####

# NOTE: Fall to death, Suicide, Hanging, Robot Bomb, Drowning, Drug Overdose,
# Smoke inhilation, & Negligence/Neglect have only a couple of incidents each
# so not informative to plot

        
# Do deaths differ by race?
    # YES
            
# Are the correlations between COD & race?
        # Plot correlations, preferably w/ regression line
        # If correlations exist, what could this disparity mean?

# Does being armed or unarmed have any impact on death?
    # some races seem more likely to be armed - Whites & Blacks
    # some races seem more likely to be killed regardless of being armed - Blacks   
        # is there a correlation between being race + armed/unarmed & COD?

# Further analyze pepper spray deaths
    # Maybe just do some external research - does pepper spray kill??

# Charges brought? - needs more cleaning
    # unclear who's being charged - police or victim?

# Vehicle deaths - lot's of people just ran over by police
    # need to filter this into at least two sub-categories: crash & run over
