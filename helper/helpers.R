# Note: percent map is designed to work with the counties data set
# It may not work correctly with other data sets if their row order does 
# not exactly match the order in which the maps package plots counties
percent_map <- function(var, color, legend.title, min = 0, max = 100, regions = ".") {

  # generate vector of fill colors for map
  shades <- colorRampPalette(c("white", color))(100)

  # constrain gradient to percents that occur between min and max
  #percents <- as.integer(cut(var, 100, include.lowest = TRUE, ordered = TRUE))
  fills <- shades[var+1]

  # plot choropleth map
  map("state", regions = regions, fill = TRUE, col = fills, 
    resolution = 0, lty = 0, projection = "polyconic", 
    myborder = 0, mar = c(0,0,0,0))
  
  # overlay state borders
  map("state", regions = regions, col = "black", fill = FALSE, add = TRUE,
    lty = 1, lwd = 1, projection = "polyconic", 
    myborder = 0, mar = c(0,0,0,0))

  # add a legend
  inc <- (max - min) / 4
  legend.text <- c( paste0(min),
                    paste0(inc, "%"),
                    paste0(2 * inc, "%"),
                    paste0(3 * inc, "%"),
                    paste0(max, "%"))
  
  legend("bottomleft", 
    legend = legend.text, 
    fill = shades[c(1, 25, 50, 75, 100)], 
    title = legend.title)
}