#Load in required packages (I use pacman to make sure they're in my library)
pacman::p_load(raster, sp, maptools)

# source this script to create a variable "box" that points to each local box directory
box <- c("C:/Users/Matthew/Box Sync/CalDiversity_2018_Box",
#        "David's local box folder",
         "C:/Users/Molly/Box/CalDiversity_2018_Box")
box <- box[dir.exists(box)]
setwd(box)


#Read in specimen data
jepname <- paste0(box, "/Data/specimens/California_Species_clean_All_epsg_3310.Rdata")
#Note that I cannot load this file currently
jep <- load(jepname)
#dim(jep)
#names(jep)

#Set up projection and plot
aea.project <- "+proj=aea +datum=NAD83 +lat_1=34 +lat_2=40.5 +lat_0=0 +lon_0=-120 +x_0=0 +y_0=-4000000"

#jep[1,]
#plot(jep[1:1000,c('x_epsg_3310','y_epsg_3310')],asp=1)



#Read in and plot the baselayer
demname <- paste0(box, "/Data/baselayers/ca_270m_t6.asc")
dem <- raster(demname)
plot(dem)



#Start reading in the climate information

#Helpful notes on files from David
# BCM2014_ppt1981_2010_wy_ave_HST.Rdata
# BCM = basin characterization model
# 2014 is version
# ppt = precipitation
# 1981_2010 = 30 year average
# wy = water yearsd
# ave = average

#Load in all of the Climate Data

#30 year average Precipitation (1981-2010)
ppt8110name <- paste0(box, "/Data/climate/BCM2014_ppt1981_2010_wy_ave_HST.Rdata")
ppt8110 <- readRDS(ppt8110name)
plot(ppt8110)
#points(jep[1:1000,c('x_epsg_3310','y_epsg_3310')],asp=1)


#30 year average Precipitation (1951-1980)
ppt5180name <- paste0(box, "/Data/climate/BCM2014_ppt1951_1980_wy_ave_HST.Rdata")
ppt5180 <- readRDS(ppt5180name)
plot(ppt5180)

#30 year average Climatic Water Deficit (1951-1980)
cwd5180name <- paste0(box, "/Data/climate/BCM2014_cwd1951_1980_wy_ave_HST.Rdata")
cwd5180 <- readRDS(cwd5180name)
plot(cwd5180)

#30 year average Climatic Water Deficit (1981-2010)
cwd8110name <- paste0(box, "/Data/climate/BCM2014_cwd1981_2010_wy_ave_HST.Rdata")
cwd8110 <- readRDS(cwd8110name)
plot(cwd8110)

#30 year average Mean Winter Air Temperature (1951-1980)
djf5180name <- paste0(box, "/Data/climate/BCM2014_djf1951_1980_wy_ave_HST.Rdata")
djf5180 <- readRDS(djf5180name)
plot(djf5180)

#30 year average Mean Winter Air Temperature (1981-2010)
djf8110name <- paste0(box, "/Data/climate/BCM2014_djf1981_2010_wy_ave_HST.Rdata")
djf8110 <- readRDS(djf8110name)
plot(djf8110)

#30 year average Mean Summer Air Temperature (1951-1980)
jja5180name <- paste0(box, "/Data/climate/BCM2014_jja1951_1980_wy_ave_HST.Rdata")
jja5180 <- readRDS(jja5180name)
plot(jja5180)

#30 year average Mean Summer Air Temperature (1981-2010)
jja8110name <- paste0(box, "/Data/climate/BCM2014_jja1981_2010_wy_ave_HST.Rdata")
jja8110 <- readRDS(jja8110name)
plot(jja8110)

#30 year average Actual Evapotranspiration (1951-1980)
aet5180name <- paste0(box, "/Data/climate/BCM2014_aet1951_1980_wy_ave_HST.Rdata")
aet5180 <- readRDS(aet5180name)
plot(aet5180)

#30 year average Actual Evapotranspiration (1981-2010)
aet8110name <- paste0(box, "/Data/climate/BCM2014_aet1981_2010_wy_ave_HST.Rdata")
aet8110 <- readRDS(aet8110name)
plot(aet8110)