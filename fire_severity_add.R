# General R setup ----

#Options
options(stringsAsFactors = F)

#Load in required packages (I use pacman to make sure they're in my library)
pacman::p_load(raster, sp, maptools, ggmap, purrr, EBImage, tiff,
               rgdal, broom, rgeos, GISTools, bioimagetools,
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

#Read in and plot the baselayer
demname <- paste0(box, "/Data/baselayers/ca_270m_t6.asc")
dem <- raster(demname)

#Read in the tif files
tif1984 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/1984/mtbs_CA_1984/mtbs_CA_1984.tif"))
tif1985 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/1985/mtbs_CA_1985/mtbs_CA_1985.tif"))
tif1986 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/1986/mtbs_CA_1986/mtbs_CA_1986.tif"))
tif1987 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/1987/mtbs_CA_1987/mtbs_CA_1987.tif"))
tif1988 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/1988/mtbs_CA_1988/mtbs_CA_1988.tif"))
tif1989 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/1989/mtbs_CA_1989/mtbs_CA_1989.tif"))
tif1990 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/1990/mtbs_CA_1990/mtbs_CA_1990.tif"))
tif1991 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/1991/mtbs_CA_1991/mtbs_CA_1991.tif"))
tif1992 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/1992/mtbs_CA_1992/mtbs_CA_1992.tif"))
tif1993 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/1993/mtbs_CA_1993/mtbs_CA_1993.tif"))
tif1994 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/1994/mtbs_CA_1994/mtbs_CA_1994.tif"))
tif1995 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/1995/mtbs_CA_1995/mtbs_CA_1995.tif"))
tif1996 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/1996/mtbs_CA_1996/mtbs_CA_1996.tif"))
tif1997 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/1997/mtbs_CA_1997/mtbs_CA_1997.tif"))
tif1998 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/1998/mtbs_CA_1998/mtbs_CA_1998.tif"))
tif1999 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/1999/mtbs_CA_1999/mtbs_CA_1999.tif"))
tif2000 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/2000/mtbs_CA_2000/mtbs_CA_2000.tif"))
tif2001 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/2001/mtbs_CA_2001/mtbs_CA_2001.tif"))
tif2002 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/2002/mtbs_CA_2002/mtbs_CA_2002.tif"))
tif2003 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/2003/mtbs_CA_2003/mtbs_CA_2003.tif"))
tif2004 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/2004/mtbs_CA_2004/mtbs_CA_2004.tif"))
tif2005 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/2005/mtbs_CA_2005/mtbs_CA_2005.tif"))
tif2006 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/2006/mtbs_CA_2006/mtbs_CA_2006.tif"))
tif2007 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/2007/mtbs_CA_2007/mtbs_CA_2007.tif"))
tif2008 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/2008/mtbs_CA_2008/mtbs_CA_2008.tif"))
tif2009 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/2009/mtbs_CA_2009/mtbs_CA_2009.tif"))
tif2010 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/2010/mtbs_CA_2010/mtbs_CA_2010.tif"))
tif2011 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/2011/mtbs_CA_2011/mtbs_CA_2011.tif"))
tif2012 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/2012/mtbs_CA_2012/mtbs_CA_2012.tif"))
tif2013 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/2013/mtbs_CA_2013/mtbs_CA_2013.tif"))
tif2014 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/2014/mtbs_CA_2014/mtbs_CA_2014.tif"))
tif2015 <- raster(paste0(box, "/Data/MTBS/composite_data/MTBS_BSmosaics/2015/mtbs_CA_2015/mtbs_CA_2015.tif"))


jepname <- paste0(box, "/Data/jepclimeraster.Rdata")
jep <- readRDS(jepname)

#Set up projection and plot
aea.project <- "+proj=aea +datum=NAD83 +lat_1=34 +lat_2=40.5 +lat_0=0 +lon_0=-120 +x_0=0 +y_0=-4000000"


#Setting up jep for the raster::extract function
jep %<>% tbl_df()
#Define the coordinates
coordinates(jep) <- ~ x_epsg_3310 + y_epsg_3310
#Assign a CRS to the data
proj4string(jep) <- aea.project

proj4string(tif1984) <- aea.project
proj4string(tif1985) <- aea.project
proj4string(tif1986) <- aea.project
proj4string(tif1987) <- aea.project
proj4string(tif1988) <- aea.project
proj4string(tif1989) <- aea.project
proj4string(tif1990) <- aea.project
proj4string(tif1991) <- aea.project
proj4string(tif1992) <- aea.project
proj4string(tif1993) <- aea.project
proj4string(tif1994) <- aea.project
proj4string(tif1995) <- aea.project
proj4string(tif1996) <- aea.project
proj4string(tif1997) <- aea.project
proj4string(tif1998) <- aea.project
proj4string(tif1999) <- aea.project
proj4string(tif2000) <- aea.project
proj4string(tif2001) <- aea.project
proj4string(tif2002) <- aea.project
proj4string(tif2003) <- aea.project
proj4string(tif2004) <- aea.project
proj4string(tif2005) <- aea.project
proj4string(tif2006) <- aea.project
proj4string(tif2007) <- aea.project
proj4string(tif2008) <- aea.project
proj4string(tif2009) <- aea.project
proj4string(tif2010) <- aea.project
proj4string(tif2011) <- aea.project
proj4string(tif2012) <- aea.project
proj4string(tif2013) <- aea.project
proj4string(tif2014) <- aea.project
proj4string(tif2015) <- aea.project


extractmultiple <- function(rasterlayer, layername){
  extraction <- raster::extract(x = rasterlayer, y = jep, fun = mean, na.rm = T, sp = T)
  extraction %<>% tbl_df()
  return(extraction) %>% select(layername)
}



rasterlayers <- c(tif1984, tif1985, tif1986, tif1987, tif1988, tif1989, tif1990, tif1991, tif1992, tif1993, tif1994, tif1995, tif1996, tif1997, tif1998, tif1999, tif2000, tif2001, tif2002, tif2003, tif2004, tif2005, tif2006, tif2007, tif2008, tif2009, tif2010, tif2011, tif2012, tif2013, tif2014, tif2015)
layernames <- c('mtbs_CA_1984', 'mtbs_CA_1985', 'mtbs_CA_1986', 'mtbs_CA_1987', 'mtbs_CA_1988', 'mtbs_CA_1989', 'mtbs_CA_1990', 'mtbs_CA_1991', 'mtbs_CA_1992', 'mtbs_CA_1993', 'mtbs_CA_1994', 'mtbs_CA_1995', 'mtbs_CA_1996', 'mtbs_CA_1997', 'mtbs_CA_1998', 'mtbs_CA_1999', 'mtbs_CA_2000', 'mtbs_CA_2001', 'mtbs_CA_2002', 'mtbs_CA_2003', 'mtbs_CA_2004', 'mtbs_CA_2005', 'mtbs_CA_2006', 'mtbs_CA_2007', 'mtbs_CA_2008', 'mtbs_CA_2009', 'mtbs_CA_2010', 'mtbs_CA_2011', 'mtbs_CA_2012', 'mtbs_CA_2013', 'mtbs_CA_2014', 'mtbs_CA_2015')


rasters <- map2_dfc(rasterlayers, layernames, extractmultiple)

rasters$numfires <- 32 - rowSums(is.na(rasters))
rastersmess <- rasters 
rastersmess <- within(rastersmess, rm(numfires))

rastersmess[rastersmess==5] <- NA 
rastersmess[rastersmess==6] <- NA 
rastersmess <- rastersmess %>% mutate(maxSev = pmax(mtbs_CA_1984, mtbs_CA_1985,
                                                 mtbs_CA_1986, mtbs_CA_1987, 
                                                 mtbs_CA_1988, mtbs_CA_1989,
                                                 mtbs_CA_1990, mtbs_CA_1991, 
                                                 mtbs_CA_1992, mtbs_CA_1993, 
                                                 mtbs_CA_1994, mtbs_CA_1995, 
                                                 mtbs_CA_1996, mtbs_CA_1997, 
                                                 mtbs_CA_1998, mtbs_CA_1999,
                                                 mtbs_CA_2000, mtbs_CA_2001,
                                                 mtbs_CA_2002, mtbs_CA_2003,
                                                 mtbs_CA_2004, mtbs_CA_2005, 
                                                 mtbs_CA_2006, mtbs_CA_2007,
                                                 mtbs_CA_2008, mtbs_CA_2009,
                                                 mtbs_CA_2010, mtbs_CA_2011, 
                                                 mtbs_CA_2012, mtbs_CA_2013,
                                                 mtbs_CA_2014, mtbs_CA_2015, na.rm = T))

rastersmess <- rastersmess %>% rowwise() %>% mutate(aveSev = mean(c(mtbs_CA_1984, mtbs_CA_1985,
                                                    mtbs_CA_1986, mtbs_CA_1987, 
                                                    mtbs_CA_1988, mtbs_CA_1989,
                                                    mtbs_CA_1990, mtbs_CA_1991, 
                                                    mtbs_CA_1992, mtbs_CA_1993, 
                                                    mtbs_CA_1994, mtbs_CA_1995, 
                                                    mtbs_CA_1996, mtbs_CA_1997, 
                                                    mtbs_CA_1998, mtbs_CA_1999,
                                                    mtbs_CA_2000, mtbs_CA_2001,
                                                    mtbs_CA_2002, mtbs_CA_2003,
                                                    mtbs_CA_2004, mtbs_CA_2005, 
                                                    mtbs_CA_2006, mtbs_CA_2007,
                                                    mtbs_CA_2008, mtbs_CA_2009,
                                                    mtbs_CA_2010, mtbs_CA_2011, 
                                                    mtbs_CA_2012, mtbs_CA_2013,
                                                    mtbs_CA_2014, mtbs_CA_2015), na.rm = T))

rasters$maxSev <- rastersmess$maxSev
rasters$aveSev <- rastersmess$aveSev

jep <- jep %<>% tbl_df()
jepfull <- cbind(jep, rasters)



saveRDS(jepfull, file = paste0(box, "/Data/jepclimefireraster.RData"))
