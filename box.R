# source this script to create a variable "box" that points to your local box directory

box <- c("C:/Users/Matthew/Box Sync/CalDiversity_2018_Box",
                 "David's local box folder",
                 "C:\Users\Molly\Box\CalDiversity_2018_Box")
box <- box[dir.exists(box)]