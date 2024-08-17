library(shinycssloaders)
library(dplyr)
library(shinythemes)
library(shinyWidgets)

navbarPage("ShinyCC",
  # Set the theme for the app
  theme = shinytheme("flatly"),
  # single-sample
  tabPanel("Single Sample",
    fluidPage(
      # Sidebar for group and pathway selection
      sidebarPanel(
               # Group selection
               selectizeInput(
                 inputId = "sample_name",
                 label = strong("Select a group/sample:"),
                 choices = names(cellchat.list),
                 selected = "NULL",
               ),
               
               # Pathway selection
               selectizeInput(
                 inputId = 'pathway_name', 
                 label = strong("Select a pathway:"),
                 choices = NULL, 
                 multiple = FALSE, 
                 selected = "NULL",
               ),
               
               # Select plot type
               selectInput(
                 inputId = "plot_type",
                 label = "Select plot type:",
                 choices = c("Interaction strength" = "weight", 
                             "Number of interactions" = "count"),
                 selected = "weight"
               ),
               
               # Checkbox group input for selecting sender cells
               pickerInput('sender_cells', 
                           strong("Select sender cells:"), 
                           choices = NULL,  # Choices will be populated dynamically
                           multiple = TRUE,
                           selected = NULL,
                           options=list(`actions-box` = TRUE,  # Show select all/deselect all options
                                        `live-search` = TRUE)),
               
               # Checkbox group input for selecting receiver cells
               pickerInput('receiver_cells', 
                           strong("Select receiver cells:"), 
                           choices = NULL,  # Choices will be populated dynamically
                           multiple = TRUE,
                           selected = NULL,
                           options=list(`actions-box` = TRUE,  # Show select all/deselect all options
                                        `live-search` = TRUE)),
               # Toggle switch for adjusting plot size
               numericInput("plot_width", "Plot Width (px):", value = 800, min = 240),
               numericInput("plot_height", "Plot Height (px):", value = 600, min = 180),
               sliderInput("plot_cex", "Label size:", min = 0.5, max = 2.0, value = 1.0),
               
               # Action button to update conditions
               actionButton(
                 inputId = "update_plot",
                 label = "Update plot",
                 width = "100%"
               ),
               
             ),
             
             # Layout for plots using fluidRow and column functions
             fluidRow(
               # Main plot area for circle and chord plots
               column(6, 
                      tabsetPanel(id = "mainTab",
                        tabPanel("Aggregated plot", 
                                 uiOutput("aggr_plot_UI") %>% withSpinner(type=7, color="#264653")),          
                        tabPanel("Circle plot", 
                                 uiOutput("circle_plot_UI") %>% withSpinner(type=7, color="#264653")),
                        tabPanel("Chord plot", 
                                 uiOutput("chord_plot_UI") %>% withSpinner(type=7, color="#264653")),
                        tabPanel("Heatmap", 
                                 uiOutput("heatmap_UI") %>% withSpinner(type=7, color="#264653")),
                        tabPanel("L-R bubble plot", 
                                 uiOutput("bubble_plot_UI") %>% withSpinner(type=7, color="#264653"))     
                      ),
               ),
            ),
           
    ),
  ),
  
  # Comparison Panel
  tabPanel("Comparison",
           fluidPage(
             
             h3("This page is under development. Please check back later."),
             
             # Plot area
             sidebarPanel(
               selectizeInput(
                 inputId = "sample1",
                 label = strong("Select first group/sample:"),
                 choices = names(cellchat.list),
                 selected = "NULL"
               ),
               selectizeInput(
                 inputId = "sample2",
                 label = strong("Select second group/sample:"),
                 choices = names(cellchat.list),
                 selected = "NULL"
               ),
               # Pathway selection
               selectizeInput(
                 inputId = 'pathway_name', 
                 label = strong("Select a pathway:"),
                 choices = NULL, 
                 multiple = FALSE, 
                 selected = "NULL",
               ),
               
               # Checkbox group input for selecting sender cells
               pickerInput('sender_cells', 
                           strong("Select sender cells:"), 
                           choices = NULL,  # Choices will be populated dynamically
                           multiple = TRUE,
                           selected = NULL,
                           options=list(`actions-box` = TRUE,  # Show select all/deselect all options
                                        `live-search` = TRUE)),
               
               # Checkbox group input for selecting receiver cells
               pickerInput('receiver_cells', 
                           strong("Select receiver cells:"), 
                           choices = NULL,  # Choices will be populated dynamically
                           multiple = TRUE,
                           selected = NULL,
                           options=list(`actions-box` = TRUE,  # Show select all/deselect all options
                                        `live-search` = TRUE)),
               
               # Action button to update conditions
               #              actionButton(
               #                 inputId = "update",
               #                 label = "Update plot",
               #                 width = "100%"
               #               ),
               
               
               # Toggle switch for adjusting plot size
               numericInput("plot_width", "Plot Width (px):", value = 800, min = 240),
               numericInput("plot_height", "Plot Height (px):", value = 600, min = 180),
               sliderInput("plot_cex", "Label size:", min = 0.5, max = 2.0, value = 1.0),
               
             ),
             
             fluidRow(
               # Main plot area for circle and chord plots
               column(6, 
                      tabsetPanel(id = "mainTab",
                                  tabPanel("Aggregated plot", 
                                           #uiOutput("aggr_plot_UI") %>% withSpinner(type=7, color="#264653")
                                           ),          
                                  tabPanel("Circle plot", 
                                           #uiOutput("circle_plot_UI") %>% withSpinner(type=7, color="#264653")
                                           ),
                                  tabPanel("Chord plot", 
                                           #uiOutput("chord_plot_UI") %>% withSpinner(type=7, color="#264653")
                                           ),
                                  tabPanel("Heatmap", 
                                           #uiOutput("heatmap_UI") %>% withSpinner(type=7, color="#264653")
                                           ),
                                  tabPanel("L-R bubble plot", 
                                           #uiOutput("bubble_plot_UI") %>% withSpinner(type=7)
                                           )     
                      ),
               ),
             ),
           ),
  ),
  tags$footer(p("         ShinyCC is made by Ziyu Zeng."))
)
