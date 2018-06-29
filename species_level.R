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



#Read in specimen data ----

jepname <- paste0(box, "/Data/jepclimefire.RData")
jep <- readRDS(jepname)


#Collapse into various species
jepspecies <- jep %>% group_by(current_name_binomial) %>% 
  # select(ppt5180, ppt8110, aet5180, aet8110, jja5180, jja8110, 
  #        djf5180, djf8110, cwd5180, cwd8110)  %>% 
  summarize(meanppt5180 = mean(ppt5180, na.rm = T), meanppt8110 = mean(ppt8110, na.rm = T), 
            meanaet5180 = mean(aet5180, na.rm = T), meanaet8110 = mean(aet8110, na.rm = T), 
            meanjja5180 = mean(jja5180, na.rm = T), meanjja8110 = mean(jja8110, na.rm = T), 
            meandjf5180 = mean(djf5180, na.rm = T), meandjf8110 = mean(djf8110, na.rm = T), 
            meancwd5180 = mean(cwd5180, na.rm = T), meancwd8110 = mean(cwd8110, na.rm = T), 
            meanfire = mean(firecount, na.rm = T))
jepspecies$current_name_binomial <- str_replace_all(jepspecies$current_name_binomial, " ", "_")
  
 
  
#Add in fire_traits information
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

fire_traits <- fire_traits %>% mutate(current_name_binomial = paste0(current_genus, "_", current_species))


fire_traits_num <- fire_traits %>%
  group_by(current_genus, current_species) %>% 
  select_if(is.numeric) %>% summarize_all( mean, na.rm = T)


jepspecies_fire <- jepspecies %>% left_join(fire_traits, by = "current_name_binomial")


