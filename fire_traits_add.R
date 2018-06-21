# General R setup ----

#Options
options(stringsAsFactors = F)

#Load in required packages (I use pacman to make sure they're in my library)
pacman::p_load(raster, sp, maptools, ggmap, purrr, readr,
               rgdal, broom, rgeos, GISTools, tidyr,
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

#Here, I'm not sure why it reads in as jepfull? 
#I know that's what it's called in the previous R Script, but am not totally sure why they are synced. 
jepname <- paste0(box, "/Data/jepclimeraster.RData")
jep <- readRDS(jepname)

#Set up projection and plot
aea.project <- "+proj=aea +datum=NAD83 +lat_1=34 +lat_2=40.5 +lat_0=0 +lon_0=-120 +x_0=0 +y_0=-4000000"

jep[1,]
plot(jep[1:1000,c('x_epsg_3310','y_epsg_3310')],asp = 1)

#Read in the fire_traits data
bark_thickness_traits <- read_csv("fire_traits/data/bark_thickness_traits.csv")
ffe_traits <- read_csv("fire_traits/data/ffe_traits.csv")
flam_traits <- read_csv("fire_traits/data/flam_traits.csv")
S_A_traits <- read_csv("fire_traits/data/S&A_traits.csv")
species_list <- read_csv("fire_traits/data/species_list.csv")
try_traits <- read_csv("fire_traits/data/try_traits.csv")

#Work to match the species names for jep
try_traits <- try_traits %>% separate(col = Scientific_Name, into = c("current_genus", "current_species", "current_subspecies"), sep = "_", remove = FALSE)

#Filter the datasets to get the information we want to join
ffe_traitsfil <- ffe_traits %>% select(Scientific_Name, In.FFE, Bark.Thickness.25.4, Bark.Thickness.Source, Wood.density, Wood.density.Source, Decay.class, Decay.class.Source, Leaf.longevity, Leaf.longevity.Source)
bark_thickness_traitsfil <- bark_thickness_traits %>% select(Scientific_Name, CodeNum, Western, California, Gymno, Bark.Thickness.25.4.FFE2009, Bark.Thickness.Index.FFE2009, Bark.Thickness.Multiplier.FFE2009, Bark.Thickness.25.4.FOFEM2017, Bark.Thickness.Index.FOFEM2017, Bark.Thickness.Multiplier.FOFEM.2017)
flam_traitsfil <- flam_traits %>% select(Scientific_Name, Flame_duration, Flame_duration.Source, Flame_ht, Flame_ht.Source, Pct_consumed, Pct_consumed.Source, Smolder_duration, Smolder_duration.Source)
S_A_traitsfil <- S_A_traits %>% select(Scientific_Name, Serotiny, Serotiny.Source, Self.pruning, Self.pruning.Source)
species_listfil <- species_list %>% select(Scientific_Name, CA_ID, Generic, Subsp, Has_BA)



#Join the fire_traits data together to bring into jep
fire_traits <- try_traits %>% full_join(ffe_traitsfil, by = "Scientific_Name") %>% 
                full_join(bark_thickness_traitsfil, by = "Scientific_Name") %>% 
                full_join(flam_traitsfil, by = "Scientific_Name") %>% 
                full_join(S_A_traitsfil, by = "Scientific_Name") %>% 
                full_join(species_listfil, by = "Scientific_Name")
