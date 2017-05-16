## install & load packages ####
install.packages("arules")
install.packages("arulesViz")

## load data frames ####

# Age numeric w/ no missing values
mpv_4 <- filter(mpv_2, !is.na(age))
unique(mpv_4$age) # no NA's, BUT there is a class called Unknown!
mpv_4.1 <- filter(mpv_4, age != "Unknown")
mpv_4.1$age <- as.numeric(mpv_4.1$age) # should be numeric now
mean(mpv_4.1$age) # is numeric
unique(mpv_4.1$age) # no NA's or Unknowns

mpv_4.2 <- mpv_4.1 # want to preserve mpv_4.1

# Age Groups
mpv_4.2$age <- cut(mpv_4.2$age, 
                   breaks = c(0, 18, 25, 35, 45, 55, 65, 120), 
                   lables = c("0-18 years", "18-25 years", "25-35 years", "35-45 years", "45-55 years", "55-65 years", "66 year or older"),
                   right = FALSE)
levels(mpv_4.2$age)
View(mpv_4.2$age)

## Data Relationships ####




