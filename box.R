# source this script to create a variable "box" that points to your local box directory

box <- c("C:/Users/Matthew/Box Sync/CalDiversity_2018_Box",
                 "David's local box folder",
                 "Molly's local box folder")
box <- box[dir.exists(box)]