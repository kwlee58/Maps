library(mdsr) ## mdsr 패키지 텁재 
library(sp)  ## sp 패키지 탑재 
rm(list = ls())
head(CholeraDeaths)
str(CholeraDeaths)
plot(CholeraDeaths) ## mdsr 패키지에 있는 John Snow 의 콜레라 데이터 산점도 
library(rgdal) ## rgdal 패키지 탑재. GDAL : Geospatial Data Abstraction Library
# download.file("http://rtwilson.com/downloads/SnowGIS_SHP.zip", ".data/SnowGIS_SHP.zip")
dsn <- "../data/SnowGIS_SHP" ## Data Source Name, John Snow 1854, cholera outbreak killed 127.
                             ## SHP : shape file 
                             ## KML : Keyhole Markup Language 
                             ## ESRI : Environmental Systems Research Institute, ArcView
list.files(dsn) ## dsn의 파일 리스트
ogrListLayers(dsn)
ogrInfo(dsn, layer = "Cholera_Deaths")
readOGR(dsn, "Pumps")
CholeraDeaths <- readOGR(dsn, layer = "Cholera_Deaths")
Pumps <- readOGR(dsn, layer = "Pumps")
summary(CholeraDeaths)
summary(Pumps)
str(CholeraDeaths@data)
str(Pumps@data)
spplot(CholeraDeaths) ## Plots for both id and Count
coordinates(CholeraDeaths)
cholera_coords <- as.data.frame(coordinates(CholeraDeaths))
(m0 <- ggplot(cholera_coords) + 
  geom_point(aes(x = coords.x1,  ## figure 14.2 를 그리기 위한 전 단계
                 y = coords.x2))) 
(m1 <- m0 +  
    coord_quickmap())  ## Figure 14.2 
(m2 <- m0 + 
    coord_map()) ## Not working
library(ggmap)
m <- get_map("John Snow, London, England", ## roadmap through get_map()
             zoom = 17, 
             maptype = "roadmap")
plot(m)
ggmap(m)
ggmap(m) +
  geom_point(data = as.data.frame(CholeraDeaths), # All the points are out of bounds
             aes(x = coords.x1,
                 y = coords.x2,
                 size = Count))
head(as.data.frame(CholeraDeaths))
str(m)
attr(m, "bb") # coordinates are at different units, bounding box. 
library(maps)
map("world")
map("world", projection = "cylequalarea", param = 45, wrap = TRUE)
map("state", projection = "lambert",
    parameters = c(lat0 = 20, lat1 = 50), wrap = TRUE)
map("state", projection = "albers",
    parameters = c(lat0 = 20, lat1 = 50), wrap = TRUE)
proj4string(CholeraDeaths) %>% strwrap() ## tmerc : Transverse Mercator projection
CRS("+init=epsg:4326") ## Coordinate Reference System, European Petroleum Survey Group
CRS("+init=epsg:3857")
CRS("+init=epsg:27700")
cholera_latlong <- CholeraDeaths %>% spTransform(CRS("+init=epsg:4326"))
bbox(cholera_latlong)
ggmap(m) +
  geom_point(data = as.data.frame(cholera_latlong),
             aes(x = coords.x1, 
                 y = coords.x2,
                 size = Count))
help("spTransform-methods", package = "rgdal")
CholeraDeaths %>% proj4string() %>% showEPSG()
proj4string(CholeraDeaths) <- CRS("+init=epsg:27700")
cholera_latlong <- CholeraDeaths %>%
  spTransform(CRS("+init=epsg:4326"))
snow <- ggmap(m) +
  geom_point(data = as.data.frame(cholera_latlong),
             aes(x = coords.x1,
                 y = coords.x2,
                 size = Count))
snow
pumps <- readOGR(dsn, layer = "Pumps")
proj4string(pumps) <- CRS("+init=epsg:27700")
pumps_latlong <- pumps %>% spTransform(CRS("+init=epsg:4326"))
snow + 
  geom_point(data = as.data.frame(pumps_latlong),
             aes(x = coords.x1,
                 y = coords.x2,
                 size = 3, 
                 colour = "red")) +
#  scale_colour_manual(guide = NULL)
  guides(colour = "none")
