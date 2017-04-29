## install and load packages ####
install.packages("littler")
install.packages(c("dplyr", "ggplot2", "tidyr", "base"))

my_packages <- c("littler", "dplyr", "ggplot2", "tidyr", "base")

lapply(my_packages, require, character.only = TRUE)

installed.packages() # show loaded packages

