## install and load packages ####
install.packages("littler")
install.packages(c("dplyr", "ggvis", "ggplot2", "tidyr"))

my_packages <- c("littler", "dplyr","ggvis", "ggplot2", "tidyr")

lapply(my_packages, require, character.only = TRUE)

installed.packages() # show loaded packages

