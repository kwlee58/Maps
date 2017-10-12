p <- c("ggmap", "rgdal", "rgeos", "maptools", "dplyr", "tidyr", "tmap")
install.packages(p,
                 repos = "https://cran.rstudio.com")
lapply(p, library, character.only = TRUE)
