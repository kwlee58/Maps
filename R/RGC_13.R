# Creating a Map
library(tidyverse)
library(maps)
# library(ggplot2) #% map_data()를 불러오려면 ggplot2 가 올라와 있어야 함.
states_map <- map_data("state")
head(states_map)
g0 <- ggplot(data = states_map,
             mapping = aes(x = long,
                           y = lat, 
                           group = group))
g0 + 
  geom_polygon(fill = "white",
               colour = "black")
g0 + 
  geom_path() +
  coord_map("mercator")
world_map <- map_data("world")
head(world_map)
sort(unique(world_map$region))
east_asia <- map_data("world", 
                      region = c("Japan", "China", "North Korea", "South Korea"))
h0 <- ggplot(data = east_asia,
             mapping = aes(x = long,
                           y = lat, 
                           group = group,
                           fill = region))
h0 + 
  geom_polygon(colour = "black") +
  scale_fill_brewer(name = "국명", 
#                    limits = c("North Korea", "China", "Japan", "South Korea"),
                    labels = c("중국", "일본", "북한", "남한"), 
                    palette = "RdYlBu")
nz1 <- map_data("world", 
                region = "New Zealand")
nz1 <- subset(nz1, 
              long > 0 & lat > -48)
ggplot(data = nz1,
       mapping = aes(x = long,
                     y = lat,
                     group = group)) +
  geom_path()
nz2 <- map_data("nz")
ggplot(data = nz2,
       mapping = aes(x = long,
                     y = lat,
                     group = group)) +
  geom_path()

## Choropleth Map

str(USArrests)
crimes <- data.frame(state = tolower(rownames(USArrests)), 
                     USArrests, 
                     stringsAsFactors = FALSE,
                     row.names = NULL)
str(crimes)
states_map <- map_data("state")
str(states_map)
head(states_map, n = 20)
tail(states_map, n = 20)
crime_map <-merge(states_map, 
                  crimes, 
                  by.x = "region", 
                  by.y = "state")
str(crime_map) # order changed!
head(crime_map)
tail(crime_map)
crime_map <- arrange(crime_map, group, order)
str(crime_map)
# Alternatively, 
crime_map <- crimes %>%
  as_tibble() %>%
#  mutate(state = rownames(crimes), 
#         state = tolower(state)) %>% 
  right_join(states_map, by = c("state" = "region")) 
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
