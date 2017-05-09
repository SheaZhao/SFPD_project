# Import data:
library(readxl)
AFF <- read_excel("~/Desktop/DEC_10_SF1_QTP3_with_ann.xlsx")
View(AFF) # American Fact Finder dataset from Chaya

unique(colnames(AFF)) # Wow, you have 55 columns of race data

# These columns seem to contain the variables we care  about - count & frequency for each race:
    #[1] "Id2"  
    #[6] "Num_White"                                                                                                       
    #[7] "Pct_White"                                                                                                       
    #[8] "Num_Black or African American"                                                                                   
    #[9] "Pct_Black or African American"                                                                                   
    #[10] "Num_American Indian and Alaska Native"                                                                           
    #[11] "Pct_American Indian and Alaska Native"                                                                           
    #[12] "Num_Asian"                                                                                                       
    #[13] "Pct_Asian"                                                                                                       
    #[14] "Num_Native Hawaiian and Other Pacific Islander"                                                                  
    #[15] "Pct_Native Hawaiian and Other Pacific Islander"                                                                  
    #[16] "Num_Some Other Race"                                                                                             
    #[17] "Pct_Some Other Race"                    
    #[30] "Number; HISPANIC OR LATINO - Total population - Hispanic or Latino (of any race)"                                
    #[31] "Percent; HISPANIC OR LATINO - Total population - Hispanic or Latino (of any race)" 

View(AFF$`Percent; HISPANIC OR LATINO - Total population`) # hmm, why are these all 100?
View(AFF$Pct_White) # this one looks right

View(AFF$`Percent; HISPANIC OR LATINO - Total population - Hispanic or Latino (of any race)`)
# this is probably what we need to use

head(AFF$Id2) # and this must be the zip_codes


# before I change the shape of AFF, let's make a new dataframe with only the variables we care about
# we selected variables (columns) by index, instead of name, b/c their names are really long & complicated
AFF2 <- select(AFF, 1,6,7,8,9,10,11,12,13,14,15,16,17,30,31)
View(AFF2) # has only the 15 variables above

# now I can change the shape of AFF2 to match that of mpv_2
# these column names are pretty crazy, so I'm going to avoid using them directly

# rename columns so they're easier to work with - order matters!
names(AFF2) <- c("zip_code","n_white", "freq_white", "n_black", "freq_black", 
                 "n_native american", "freq_native american", "n_asian", "freq_asian",
                 "n_pacific islander", "freq_pacific islander", "n_unknown", "freq_unknown",
                 "n_hispanic", "freq_hispanic")
View(AFF2)





# Now let's look at mpv_2
unique(mpv_2$race) # reminder of the race categories in mpv_2
# [1] "White"            "Black"            "Hispanic"         "Native American" 
# [5] "Asian"            "Unknown race"     "Pacific Islander"


# Structure: I'm going to make mpv_2's race subcategories into columns
View(mpv_2) # before

# since I only care about comparing race & zip code's of CA, I'm excluding everything else
mpv_R <- select(mpv_2, zip_code, state, race)
View(mpv_R) # only race & zip_code by state
mpv_R <- filter(mpv_R, state == "CA") # filtered out all states but CA
View(mpv_R) 

# we don't need the state column anymore - removing it will make it easire to reshape the data
mpv_RCA <- select(mpv_R, zip_code, race)
View(mpv_RCA) # 764 observations



mpv_RCA.2 <- summarise(mpv_RCA, count = n(), freq = n/sum(n) )

# now I need to spread race so that each race category becomes it's own variable/column
mpv_RCA.spread <- spread(mpv_RCA, race, zip_code)
View(mpv_RCA.spread) # frequency of each race per zip code is automatically calculated in the rows

View(AFF)


# now I need to spread race so that each race category becomes it's own variable/column
mpv_R.spread <- spread(mpv_R, zip_code, race)
View(mpv_R.spread) # frequency of each race per zip code is automatically calculated in the rows

# now that we have freq of each race by zip code, we need the count 
mpv_R.spread.2 <- mutate(mpv_R.spread, n_white = White/sum(White))
View(mpv_R.spread.2)




mpv_R <- mpv_2 %>%
    group_by(zip_code, race) %>%
    summarise(n = n(zip_code)) %>%       # I add total counts for race
    mutate(freq = n / sum(zip_code))    # I add total frequencies for race
View(mpv_R) # only race, zip_code

# now I change the shape of mpv_R
mpv_R.spread <- spread(mpv_R, race, freq)
View(mpv_R.spread) # after - each race is it's own column. racial division by zip_code is obvious.

# remove the count
mpv_R.spread <- select(mpv_R.spread, -(n)) 
U.mpv_R.spread <- summarise(mpv_R.spread,
                            unique_race = n_distinct(race))
View(U.mpv_R.spread)










