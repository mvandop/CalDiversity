# General R setup ----

#Options
options(stringsAsFactors = F)

#Load in required packages (I use pacman to make sure they're in my library)
pacman::p_load(raster, sp, maptools, ggmap, purrr,
               rgdal, broom, rgeos, GISTools, 
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



#Read in specimen data ----
jepname <- paste0(box, "/Data/specimens/California_Species_clean_All_epsg_3310.Rdata")
jep <- readRDS(jepname)

#Set up projection and plot
aea.project <- "+proj=aea +datum=NAD83 +lat_1=34 +lat_2=40.5 +lat_0=0 +lon_0=-120 +x_0=0 +y_0=-4000000"

jep[1,]
plot(jep[1:1000,c('x_epsg_3310','y_epsg_3310')],asp = 1)

#Read in and plot the baselayer
demname <- paste0(box, "/Data/baselayers/ca_270m_t6.asc")
dem <- raster(demname)
plot(dem)

# Read in Raster Layers of Climate Variables ----

#Helpful notes on files from David
# BCM2014_ppt1981_2010_wy_ave_HST.Rdata
# BCM = basin characterization model
# 2014 is version
# ppt = precipitation
# 1981_2010 = 30 year average
# wy = water yearsd
# ave = average


#30 year average Precipitation (1981-2010)
ppt8110 <- readRDS(paste0(box, "/Data/climate/BCM2014_ppt1981_2010_wy_ave_HST.Rdata"))
plot(ppt8110)
points(jep[1:1000,c('x_epsg_3310','y_epsg_3310')],asp = 1)
#30 year average Precipitation (1951-1980)
ppt5180 <- readRDS(paste0(box, "/Data/climate/BCM2014_ppt1951_1980_wy_ave_HST.Rdata"))
#30 year average Climatic Water Deficit (1951-1980)
cwd5180 <- readRDS(paste0(box, "/Data/climate/BCM2014_cwd1951_1980_wy_ave_HST.Rdata"))
#30 year average Climatic Water Deficit (1981-2010)
cwd8110 <- readRDS(paste0(box, "/Data/climate/BCM2014_cwd1981_2010_wy_ave_HST.Rdata"))
#30 year average Mean Winter Air Temperature (1951-1980)
djf5180 <- readRDS(paste0(box, "/Data/climate/BCM2014_djf1951_1980_wy_ave_HST.Rdata"))
#30 year average Mean Winter Air Temperature (1981-2010)
djf8110 <- readRDS(paste0(box, "/Data/climate/BCM2014_djf1981_2010_wy_ave_HST.Rdata"))
#30 year average Mean Summer Air Temperature (1951-1980)
jja5180 <- readRDS(paste0(box, "/Data/climate/BCM2014_jja1951_1980_wy_ave_HST.Rdata"))
#30 year average Mean Summer Air Temperature (1981-2010)
jja8110 <- readRDS(paste0(box, "/Data/climate/BCM2014_jja1981_2010_wy_ave_HST.Rdata"))
#30 year average Actual Evapotranspiration (1951-1980)
aet5180 <- readRDS(paste0(box, "/Data/climate/BCM2014_aet1951_1980_wy_ave_HST.Rdata"))
#30 year average Actual Evapotranspiration (1981-2010)
aet8110 <- readRDS(paste0(box, "/Data/climate/BCM2014_aet1981_2010_wy_ave_HST.Rdata"))





# Extracting data from an example raster and plotting information----

#Setting up jep for the raster::extract function
jep %<>% tbl_df()
#Define the coordinates
coordinates(jep) <- ~ x_epsg_3310 + y_epsg_3310
#Assign a CRS to the data
proj4string(jep) <- aea.project


pptextract81 <- raster::extract(x = ppt8110, y = jep, fun = mean, na.rm = T, sp = T)
pptextract81 %<>% tbl_df()
names(pptextract81)[names(df) == 'layer'] <- 'ppt81'

#Looking at Average Precipitation Across the Dataset
ggplot() +
  geom_density(data = filter(pptextract81, current_name_binomial == "Juncus covillei"),
               aes(x = layer, color = "Juncus covillei", fill = "Juncus covillei"),
               alpha = 0.6) +
  geom_density(data = filter(pptextract81, current_name_binomial == "Physocarpus capitatus"),
               aes(x = layer, color = "Physocarpus capitatus", fill = "Physocarpus capitatus"),
               alpha = 0.6) +
  geom_density(data = filter(pptextract81, current_name_binomial == "Phoradendron californicum"),
               aes(x = layer, color = "Phoradendron californicum", fill = "Phoradendron californicum"),
               alpha = 0.6) +
  ylab("Density") +
  xlab("Average Precipitation 1981-2010") +
  theme_ed +
  scale_color_viridis("", discrete = T) +
  scale_fill_viridis("", discrete = T)

# Adding all raster information to the database -----

jep %<>% tbl_df()
jepcoords <- jep %>% filter(x_epsg_3310, y_epsg_3310)
#Define the coordinates
coordinates(jepcoords) <- ~ x_epsg_3310 + y_epsg_3310
#Assign a CRS to the data
proj4string(jepcoords) <- aea.project

extractmultiple <- function(rasterlayer, layername){
  extraction <- raster::extract(x = rasterlayer, y = jep, fun = mean, na.rm = T, sp = T)
  extraction %<>% tbl_df()
  names(extraction)[names(extraction) == 'layer'] <- layername
  return(extraction) %>% select(layername)
}

extractioncli <- raster::extract(x = ppt5180, y = jep, fun = mean, na.rm = T, sp = T)


rasterlayers <- c(ppt5180, ppt8110, cwd5180, cwd8110, aet5180, aet8110, djf5180, djf8110, jja5180, jja8110)
layernames <- c('ppt5180', 'ppt8110', 'cwd5180', 'cwd8110', 'aet5180', 'aet8110', 'djf5180', 'djf8110', 'jja5180', 'jja8110')

rasters <- map2_dfc(rasterlayers, layernames, extractmultiple)

jep <- jep %<>% tbl_df()
jepfull <- cbind(jep, rasters)

#Saving jepfull

saveRDS(jepfull, file = paste0(box, "/Data/jepclimeraster.RData"))
