library(raster)
library(sp)
library(maptools)

jep <- readRDS('/Users/david/Documents/Projects/CalDiversity/CCH_2016_master/California_Species_clean_All_epsg_3310.Rdata')
dim(jep)
names(jep)

aea.project <- "+proj=aea +datum=NAD83 +lat_1=34 +lat_2=40.5 +lat_0=0 +lon_0=-120 +x_0=0 +y_0=-4000000"

jep[1,]

# current_name_binomial - use this name!
# current_genus
# current_species
# x_epsg_3310 - x coordinate = longitude
# y_epsg_3310 - y coordinate = latitude

plot(jep[1:1000,c('x_epsg_3310','y_epsg_3310')],asp=1)

dem <- raster('/Users/Shared/data/BCM/CA2014/baselayers/CA_T6_FIXED/ta_asc/dem/ca_270m_t6.asc')
plot(dem)


# BCM2014_ppt1981_2010_wy_ave_HST.Rdata
# BCM = basin characterization model
# 2014 is version
# ppt = precipitation
# 1981_2010 = 30 year average
# wy = water yearsd
# ave = average
 
tmax <- readRDS('/Users/Shared/data/BCM/CA2014/Summary/Water_years/Normal30_HST_Rdata/BCM2014_ppt1981_2010_wy_ave_HST.Rdata')
plot(tmax)
points(jep[1:1000,c('x_epsg_3310','y_epsg_3310')],asp=1)
