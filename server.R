library(shiny)
library(RCurl)
library(maps)
library(mapproj)
library(plyr)
source("helper/helpers.R")

united <- read.csv("Data/united.csv",header=TRUE)
aetna <- read.csv("Data/aetna.csv",header=TRUE)
kaiser <- read.csv("Data/kaiser.csv",header=TRUE)
anthem <- read.csv("Data/anthem.csv",header=TRUE)
humana <- read.csv("Data/humana.csv",header=TRUE)
cigna <- read.csv("Data/cigna.csv",header=TRUE)
wellcare <- read.csv("Data/wellcare.csv",header=TRUE)
healthnet <- read.csv("Data/healthnet.csv",header=TRUE)
highmark <- read.csv("Data/highmark.csv",header=TRUE)

zoom <- c('wisconsin',
          'indiana',
          'ohio',
          'michigan:south','michigan:north',
          'illinois',
          'missouri',
          'iowa',
          'minnesota',
          'north dakota',
          'south dakota',
          'nebraska',
          'kansas',
          'maine',
          'vermont',
          'new hampshire',
          'massachusetts:main',"massachusetts:martha's vineyard",'massachusetts:nantucket',
          'rhode island',
          'connecticut',
          'new york:long island','new york:main',
          'new jersey',
          'pennsylvania',
          'virginia:chesapeake','virginia:main',
          'west virginia',
          'maryland',
          'delaware',
          'florida',
          'georgia',
          'alabama',
          'mississippi',
          'louisiana',
          'arkansas',
          'tennessee',
          'kentucky',
          'texas',
          'oklahoma',
          'new mexico',
          'arizona',
          'colorado',
          'utah',
          'wyoming',
          'nevada',
          'montana',
          'idaho',
          'washington:main','washington:lopez island','washington:san juan island','washington:whidbey island',
          'oregon',
          'california',
          'north carolina:main','north carolina:knotts',
          'south carolina',
          'district of columbia')

function(input, output) {
  output$map <- renderPlot({
    data <- switch(input$var, 
                   "UnitedHealth" = united,
                   "Aetna" = aetna,
                   "Kaiser" = kaiser,
                   "Anthem" = anthem,
                   'Humana'  = humana,
                   'CIGNA'  = cigna,
                   'WellCare'  = wellcare,
                   'Health Net'  = healthnet,
                   'Highmark'  = highmark)

    if (input$year <= 2015) {
      year <- as.character(input$year)
      dset <- data
      sub <- dset[dset$year == year, ]
      sub <- sub[sub$State.Name %in% zoom, ]
      percent_map(sub$percent, "darkgreen", "Market Share", regions = zoom)
    } else {
      dset <- data
      sub <- dset[dset$State.Name %in% zoom, ]
      models <- dlply(sub,"State.Name", function(df)
        lm(percent ~ year, data = df))
      model <- ldply(models,coef)
      colnames(model) <- c('State.Name','int','year')
      model$percent <- model$int + (model$year * input$year)
      model[model < 1] <- 0
      model[model > 99] <- 99
      percent_map(model$percent, "darkgreen", "Market Share", regions = zoom)
    }
  })
}