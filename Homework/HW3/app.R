# Homework #3 Shiny app
# Due November 9, 2020 by 11:59pm EST

library(shiny)
library(tidyverse)
library(forcats)
library(dslabs)
data(gapminder)

ui <- fluidPage()

server <- function(input, output) {}

# Run the application 
shinyApp(ui = ui, server = server)
