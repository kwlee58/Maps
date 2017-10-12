## Maps
# install.packages("tidyverse",
#                 repos = "https://cran.rstudio.com")
library(tidyverse)
# install.packages("maps",
#                 repos = "https://cran.rstudio.com")
library(maps)
us_map <- map_data("state") ## ggplot2에 들어 있음.
head(us_map)
str(us_map)
table(us_map$region)
(g0 <- us_map %>%
  filter(region %in% c("north carolina", "south carolina")) %>%
  ggplot(aes(x = long, y = lat)))
g0
(g1 <- g0 +
  geom_point())
# g1
(g2 <- g0 +
  geom_path())
# g2
(g3 <- g0 +   
    geom_polygon())
# g3
(g4 <- g0 +
  geom_path(aes(x = long, 
                y = lat, 
                group = group)))
# g4
(g5 <- g0 +
    geom_polygon(aes(x = long, 
                     y = lat, 
                     group = group), 
                 fill = "white", 
                 colour = "black"))
g5 + theme_void()
us_map %>%
  ggplot(aes(x = long, 
             y = lat, 
             group = group)) +
  geom_polygon(fill = "grey", 
               colour = "black") +
  coord_map("mercator") +
  theme_void()
library(viridis)
head(votes.repub)
votes.df <- votes.repub %>%
  as_tibble() %>%
  mutate(state = rownames(votes.repub),
         state = tolower(state)) %>%
  right_join(us_map, 
             by = c("state" = "region")) 
ggplot(data = votes.df, 
       aes(x = long, 
           y = lat, 
           group = group, 
           fill = `1976`)) + # `1976`은 tbl 숫자 변수명 표시 방법
  geom_polygon(colour = "black") +
  theme_void() +
    scale_fill_viridis(name = "Republican\nvotes (%)") +
  coord_map("mercator")

## USArrests

str(USArrests)
crimes <- data.frame(state = tolower(rownames(USArrests)), #% US_map의 region에 맞춤.
                     USArrests, 
                     stringsAsFactors = FALSE, #% 꼭 필요한 설정임.
                     row.names = NULL)
str(crimes) #%
crime_map <-merge(us_map, 
                  crimes, 
                  by.x = "region", 
                  by.y = "state")
str(crime_map) # order changed!
head(crime_map)
tail(crime_map)
crime_map <- arrange(crime_map, group, order)
str(crime_map)
#% Alternatively, 
crime_map <- crimes %>%
  as_tibble() %>%
  mutate(state = rownames(USArrests), 
         state = tolower(state)) %>% 
  right_join(us_map, by = c("state" = "region")) 
str(crime_map)
head(crime_map)
tail(crime_map)
ggplot(data = crime_map, 
       mapping = aes(x = long,
                     y = lat,
                     group = group,
                     fill = Assault)) +
  geom_polygon(colour = "black") +
  coord_map("polyconic")

### scale_fill_gradient

ggplot(data = crimes,
       mapping = aes(map_id = state, 
                     fill = Assault)) +
  geom_map(map = us_map,
           colour = "black") +
  scale_fill_gradient2(low = "#559999",
                       mid = "grey99",
                       high = "#BB650B",
                       midpoint = median(crimes$Assault)) +
  expand_limits(x = us_map$long,
                y = us_map$lat) +
  coord_map("polyconic")

## ggmap
# library(devtools)
# install_github("dkahle/ggmap") # ggplot 2.2.0 needed. panel.margin vs panel.spacing
# install.packages(c("RgoogleMaps", "png", "jpeg"))
# sudo yum install libjpeg-turbo-devel libpng-devel

library(ggmap) # RgoogleMaps, jpeg, png needed. libjpeg-turbo-devel, libpng-devel 
beijing <- get_map("Beijing", 
                   zoom = 12)
ggmap(beijing) +
  theme_void() +
  labs(title = "Beijing, China")

## Estes Park

map_1 <- get_map("Estes Park",
                 zoom = "auto",
                 maptype = "terrain",
                 source = "google") %>%
  ggmap(extent = "device")

map_2 <- get_map("Estes Park",
                 zoom = "auto",
                 maptype = "watercolor",
                 source = "google") %>%
  ggmap(extent = "device")

map_3 <- get_map("Estes Park",
                 zoom = "auto",
                 maptype = "hybrid",
                 source = "google") %>%
  ggmap(extent = "device")
library(gridExtra)
grid.arrange(map_1, map_2, map_3, nrow = 1)

## Maryland Serial Data

serial <- read_csv(paste0("https://raw.githubusercontent.com/",
                          "dgrtwo/serial-ggvis/master/input_data/",
                          "serial_podcast_data/serial_map_data.csv"))
head(serial, 3)
serial <- serial %>%
  mutate(long = -76.8854 + 0.00017022 * x,
         lat = 39.23822 + 1.371014e-04 * y,
         tower = Type == "cell-site")
serial %>%
  slice(c(1:3, (n() - 3):(n())))
maryland <- map_data("county", region = "maryland")
head(maryland)
baltimore <- maryland %>%
  filter(subregion %in% c("baltimore city", "baltimore"))
head(baltimore, 3)
g0 <- ggplot(baltimore, 
             aes(x = long, 
                 y = lat, 
                 group = group))
(g1 <- g0 +
  geom_polygon(fill = "lightblue", 
               colour = "black"))
(g2 <- g1 +
    theme_void()) 
(g3 <- g1 +
  geom_point(data = serial, 
             aes(group = NULL,
                 colour = tower)))
(g4 <- g2 +
    geom_point(data = serial, 
               aes(group = NULL,
                   colour = tower)))
(g5 <- g4 +
    scale_colour_manual(name = "Cell Tower", 
                        values = c("black", "red")))

## Baltimore + Serial

(map_base <- get_map("Baltimore County",
                    zoom = 10,
                    source = "stamen",
                    maptype = "toner") %>%
  ggmap())
(map_baltimore <- map_base +
    geom_polygon(data = baltimore,
                 aes(x = long,
                     y = lat, 
                     group = group),
                 colour = "navy",
                 fill = "lightblue",
                 alpha = 0.2))
(map_final <- map_baltimore + 
    geom_point(data = serial,
               aes(x = long, 
                   y = lat, 
                   colour = tower)) +
    theme_void() +
    scale_colour_manual(name = "Cell Tower", 
                        values = c("black", "red")))

## Chuncheon 

# library(OpenStreetMap)

get_map("Chuncheon", 
        #       zoom = 12, 
        #       maptype = "terrain",
        source = "google") %>%
  ggmap()
get_map("Chuncheon", 
        #       zoom = 12, 
        maptype = "satellite",
        source = "google") %>%
  ggmap()
get_map("Chuncheon", 
        #       zoom = 12, 
        maptype = "roadmap",
        source = "google") %>%
  ggmap()
get_map("Chuncheon", 
        #       zoom = 12, 
        maptype = "hybrid",
        source = "google") %>%
  ggmap()
get_map("Chuncheon", 
        maptype = "watercolor",
        source = "stamen") %>%
  ggmap()
get_map("Chuncheon", 
        maptype = "toner",
        #       zoom = 12,
        source = "stamen") %>%
  ggmap()
get_map("Baltimore",  ## Error
        source = "osm") %>%
  ggmap()
(cc.geocode <- geocode("Chuncheon"))
geocode("춘천시 근화길15번길 26")
