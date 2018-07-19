# CalDiversity
Summer 2018 RET Work

This repository contains the code for the creation of the new fire database for plant communities in California. The database uses Jepson eFlora data on specimens in California and adds in climate variables, fires that occurred in the range of each specimen, and the average severity of the fires. The data is then collapsed to the species level, providing insight on how plant species live in conjunction with fire. 

## Data used
* Jepson eFlora
* Basin Characterization Model (version 7) 
* Fire and Resource Assessment Program (FRAP) Fire Perimeters Version 17_1. The FRAP fire perimeters data is a nulti-agency dataset dating back to 1920. For Cal Fire, timber fires of at least 10 acres, brush fires of at least 30 acres, and grass fires of at least 300 acres are included in the dataset. The USFS data has a 10 acres minimum size for fires, since 1950.
* Monitoring trends in Burn Severity (MTBS) Burn Severity Mosaics (1984-2015)
* Fire traits data: Compiled by Jens Stevens and Matthew Kling of traits associated with fire resistence of 29 conifer species in the western US, including bark thickness, maximum tree height, degree of self-pruning, flame length, and flame duration. 

## Files
This repository contains several files, including:
* climate_raster-add.R: This is the code that takes climate rasters from the Basin Characterization Model (version 7), and extracts the value from each climate raster for each specimen (with a 1 km radius). The climate layers included are thirty year averages of precipitation (1951-1980; 1981-2010), climatic water deficit (1951-1980; 1981-2010), actual evapotranspiration (1951-1980; 1981-2010), mean winter air temperature (1951-1980; 1981-2010), and mean summer air temperature (1951-1980; 1981-2010). The output is an R dataset, of the Jepson data, with the average climate values for each specimen.
* fire_polygons.R: this is the code that takes in the FRAP fire polygons data, turns it into a raster that counts the number of fire occurrances in each cell, and then extracts the average number of fires for each specimen in the Jepson eFlora database. 
* fire_severity_add.R: This code reads the MTBS fire severity tif files in as rasters, reprojects them to the projection +proj=aea +datum=NAD83 +lat_1=34 +lat_2=40.5 +lat_0=0 +lon_0=-120 +x_0=0 +y_0=-4000000, calculates the average number of fires in each raster cell, caculates the average fire severity for each raster cell, and extracts the the average number of fires, and the average fire severity for each specimen in the Jepsen database 9with a 1 km buffer). 
* fire_traits_add.R: Adds the fire traits data to the Jepsen eFlora data for the 29 conifer species
