# deaths by age, fill & facet race - cut() into age groups first
    # box plot for age categories
    # lm for facets

mpv_4.1 # use this dataframe for age

# group ages using cut()
cut_age <- cut(mpv_4.1$age, 
               breaks = c(0, 18, 25, 35, 45, 55, 65, 120), 
               lables = c("0-18 years", "18-25 years", "25-35 years", "35-45 years", "45-55 years", "55-65 years", "66 year or older"),
               right = FALSE)
levels(cut_age)
View(cut_age)

age_rangesBYrace.box <- ggplot()

# deaths by armed/unarmed, fill & facet race
    # box plot for armed categories
    # lm for facets

# COD by race, fill & facet by race
    # box plot for COD, fill = race
    # lm for facets

