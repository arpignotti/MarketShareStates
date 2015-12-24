library(shiny)
library(RCurl)
library(maps)
library(mapproj)
source("helper/helpers.R")

shinyUI(fluidPage(
  headerPanel("Health Insurance Organizations' 2015 Medicare Advantage Market Share by US County"),
  sidebarPanel(
    selectInput("var", 
                label = "Parent Organization:",
                choices = c("Aetna",
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
    tabsetPanel(
      tabPanel("Instructions",
               p("<- Select a parent organization/health insurance company that offers Medicare Advantage.
                     Parent Organization is the title given the company manages plans of various names"),
               p("<- Select a year to examine. 2010-2015 will use historical Medicare Advantage enrollment data from
                 the Centers for Medicare and Medicare Serices. The enrollment data is publicly available ",
                 a("here", href="https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/MCRAdvPartDEnrolData/Monthly-MA-Enrollment-by-State-County-Contract.html", target="_blank"),
                 "For years 2016-2020, a linear model generated from the historical data is applied to each state
                 to generate future parent organization market shares in each state"),
               p(strong("Output : "), "A choropleth US state map is generated that shows a parent organization's market share
                 in each state. Market share is defined as the percent from the parent organization's MA enrollment in the state
                 divided by the total MA enrollment in the state."),
               helpText(a("For more information on Medicare Advantage and application, click here", href="http://rpubs.com/arpignotti/MAMarketShareMap", target="_blank")
          )),
      tabPanel("Map", plotOutput("map"))
    )
  )
))