library(shiny)
library(RCurl)
library(maps)
library(mapproj)
source("helper/helpers.R")

shinyUI(pageWithSidebar(
  headerPanel("Health Insurance Organizations' 2015 Medicare Advantage Market Share by US County"),
  sidebarPanel(
    selectInput("var", 
                label = "Parent Organization:",
                choices = c("Aetna",
                            "Anthem",
                            'CIGNA',
                            'Health Net',
                            'Highmark',
                            'Humana',
                            "Kaiser",
                            "UnitedHealth",
                            'WellCare'),
                selected = "UnitedHealth"),
    
    sliderInput(inputId = "year", 
                label = "Year (After 2015 are predictions):", 
                value = 2015, min = 2010, max = 2020, step = 1, sep = "")
  ),
  mainPanel(
    plotOutput("map")
  )))