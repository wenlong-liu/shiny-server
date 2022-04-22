#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(plotly)
library(shiny)
library(shinyWidgets)
# load data to show the country list.
load("food_security.rda")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("The food supply against self-sufficient Ratios (SSR) for each country/region from 1960s to 2010s"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       sliderTextInput("Period",
                       "Periods",
                       choices = c("All","1960s", "1970s", "1980s", "1990s", "2000s", "2010s"),
                       grid = TRUE
                   ),
       # Todo:
       # add regions to the plot.
       
       #selectInput("Region",
       #            "Region",
       #            choices = c("All","africa", "asia","australia", "europe" )
       #            ),
       selectInput("Country",
                   "",
                   choices = c("All",unique(ssr$Country)))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotlyOutput('ssr_plot', height = "800px")
    )
  )
))
