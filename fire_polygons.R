# General R setup ----

#Options
options(stringsAsFactors = F)

#Load in required packages (I use pacman to make sure they're in my library)
pacman::p_load(raster, sp, maptools, ggmap, purrr, readr,
               rgdal, broom, rgeos, GISTools, tidyr, stringr,
               dplyr, ggplot2, ggthemes, magrittr, viridis)

# My ggplot2 theme
theme_ed <- theme(
  legend.position = "bottom",
  panel.background = element_rect(fill = NA),
  axis.ticks = element_line(color = "grey95", size = 0.3),
  panel.grid.major = element_line(color = "grey95", size = 0.3),
  panel.grid.minor = element_line(color = "grey95", size = 0.3),
  legend.key = element_blank())


# source this script to create a variable "box" that points to each local box directory
box <- c("C:/Users/Matthew/Box Sync/CalDiversity_2018_Box",
         #        "David's local box folder",
         "C:/Users/Molly/Box/CalDiversity_2018_Box")
box <- box[dir.exists(box)]
setwd(box)

#Read in data of interest
firep17_1 <- sf::st_read(dsn = paste0(box, "/Data/fire17_1.gdb"), layer = "firep17_1")
fire_geom <- st_geometry(firep17_1)


#Bring in the baselayer
demname <- paste0(box, "/Data/baselayers/ca_270m_t6.asc")
dem <- raster(demname)

#Code from David--using the sp geometries and the rasterize function
# fc1920_1929 <- setValues(dem,rep(0,length(dem)))
# fc1930_1939 <- fc1920_1929
# fc1940_1949 <- fc1920_1929
# fc1950_1959 <- fc1920_1929
# fc1960_1969 <- fc1920_1929
# fc1970_1979 <- fc1920_1929
# fc1980_1989 <- fc1920_1929
# fc1990_1999 <- fc1920_1929
# fc2000_2009 <- fc1920_1929
# fc2010_2016 <- fc1920_1929
# fc_decade <- stack(fc1920_1929,fc1930_1939,fc1940_1949,fc1950_1959,fc1960_1969,fc1970_1979,fc1980_1989,fc1990_1999,fc2000_2009,fc2010_2016)
# 
# badRows <- c(1068,6541,10538,16168,16346,17613,17690,19149,19152)
# 
# fewPoints <- c()
# i=1
# print(nrow(firep17_1))
# for (i in c(1:nrow(firep17_1))) {
#   
#   if (i %% 1000 == 0) print(i)
#   nPoints <- nrow(coordinates(firep17_1@polygons[[i]]@Polygons[[1]]))
#   if (nPoints < 4) fewPoints <- c(fewPoints,i)
#   if (nPoints>=3 & !(i %in% badRows)) {
#     fyear <- firep17_1$YEARn[i]
#     layer <- floor(fyear/10) - 191
#     if (!is.na(fyear)) 
#       if (fyear >=1921) 
#       {
#         fras <- rasterize(firep17_1[i,],dem)
#         fras[is.na(fras)] <- 0
#         fc_decade[[layer]] <- fc_decade[[layer]] + fras
#       }
#   }
# }


#Write a function dropping the rows that have too few points
#Such that no polygon can be formed

fewPoints <- c()

for (i in c(1:nrow(firep17_1))) {
  elementlength <- length(fire_geom[[i]][[1]])
  nPoints <- nrow(fire_geom[[i]][[1]][[1]])
  if (elementlength > 1) {
    for (j in 2:elementlength){
    nPoints <- min(nPoints, nrow(fire_geom[[i]][[1]][[j]]))
    }
  }
  nPoints <- ifelse(length(nPoints) == 0,0,nPoints)
  if (nPoints < 4){
    fewPoints <- c(fewPoints, i)
  }
}

#This is a list of rows that David identified previously as ones that cause a break
badRows <- c(1068,6541,10538,16168,16346,17613,17690,19149,19152)

wrongclass <- c()
for (i in c(1:nrow(firep17_1))) {
  
  if (class(fire_geom[[i]][[1]]) != "list"){
    wrongclass <- c(wrongclass, i)
  }
}

firep17_filtered <- firep17_1[-c(fewPoints, badRows, wrongclass),] 
#Creating this to be able to check the class later
fire_geomfil <- st_geometry(firep17_filtered)


firep <- fasterize(firep17_filtered, dem, fun = "sum")


#Extract and plot for jepspecies

jepname <- paste0(box, "/Data/jepclimefireraster.RData")
jep <- readRDS(jepname)

#Setting up jep for the raster::extract function
jep %<>% tbl_df()
#Define the coordinates
coordinates(jep) <- ~ x_epsg_3310 + y_epsg_3310
#Assign a CRS to the data
aea.project <- "+proj=aea +datum=NAD83 +lat_1=34 +lat_2=40.5 +lat_0=0 +lon_0=-120 +x_0=0 +y_0=-4000000"
proj4string(jep) <- aea.project

firecountextract <- raster::extract(x = firep, y = jep, fun = mean, na.rm = T, sp = T)
firecountextract %<>% tbl_df()
names(firecountextract)[names(firecountextract) == 'layer'] <- 'firecount'

saveRDS(firecountextract, file = paste0(box, "/Data/jepclimefireraster2.RData"))

#Doing some quick visualizations 
cwd5180 <- readRDS(paste0(box, "/Data/climate/BCM2014_cwd1951_1980_wy_ave_HST.Rdata"))
cwd_firestack <- stack(firep, cwd5180)
tbl <- as_data_frame(getValues(cwd_firestack))
sample <- sample_n(tbl, 10000)
plot(sample)
