## convert mpv to csv ####

install.packages('rio')

library(rio)

# create file to convert, then convert

export(mpv, "mpv.xlsx")

convert("mpv.xlsx", "mpv.csv")

str(mpv)




