# This code creates a example map using leafgl that I'd like to help understanding how I can speed up the time to load the map. When I tried opening this shiny map in shiny.io it took 2 minutes: 20 seconds. It's amazingly fast once loaded - but I'd like to know how to speed up time it takes to load. I'm concerned that people won't wait over 2 minutes to open this app...

# load libraries
library(leaflet)
library(leafgl)
library(colourvalues)
library(tidyverse)
library(sf)
library(shiny)

# #  First, download the data (as file geodatabase) from https://data-niwa.opendata.arcgis.com/datasets/NIWA::river-lines/about and upload to project directory folder. Then load data and prepare the data for mapping and save. Once this chunk has been run and data.RDS saved, hash it and then click "run App". And publish app to shiny.io (refer https://statisticsnz.shinyapps.io/Leafgl_performance_test/)

# st_read("./f836a785-194b-4d2b-bfcd-a00849d29a43.gdb/") %>%
#   # head(500000) %>%
#   st_transform(4236) %>%
#   st_cast("LINESTRING") %>%
#   saveRDS("data.RDS")

d_ <- readRDS("data.RDS")

cols <- colour_values_rgb(d_$Shape_Leng, palette = "viridis", include_alpha = FALSE)/255

m <- leaflet() %>%
  addProviderTiles(provider = providers$CartoDB.DarkMatter) %>%
  addGlPolylines(data = d_, group = "glpolylines", color = cols) %>%
  setView(lng = 173.5, lat = -40, zoom = 6)

m

# create shiny app
ui <- fluidPage(
  leafglOutput("mymap")
)

server <- function(input, output, session) {
  output$mymap <- renderLeaflet(m)
}

shinyApp(ui, server)
