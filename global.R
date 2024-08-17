# Load necessary libraries for Shiny app and data visualization
library(shiny)
library(shinyWidgets)
library(shinythemes)
library(CellChat)
library(ggplot2)
library(ggalluvial)

# Set global options
options(stringsAsFactors = FALSE)

# Load precomputed CellChat object list
# This contains cell communication data for multiple conditions or samples
cellchat.list <- readRDS(file="cellchat_list.rds")

# Note: Ensure that the 'cellchat_list.rds' file is in the correct path or adjust the path accordingly.