# Homework 3 Solutions

library(shiny)

library(tidyverse)
library(forcats)

library(dslabs)
data(gapminder)


# Define UI
ui = fluidPage(

   # Application title
   titlePanel("Life expectancy around the world"),

   # Create an app with 2 tabs
   tabsetPanel(
     # First tab: time series plot that compares life expectancy in the US
     # with a user-selected country
     tabPanel("Time series plot",
       sidebarLayout(
         sidebarPanel(
           # Sidebar with a select list input widget for country
           selectInput("country2", label = "Second country",
                       choices = as.list(levels(gapminder$country)))
         ),

         # Show a time series plot for the two countries
         mainPanel(
           plotOutput("linePlot")
         )
       )),
     # Second tab: scatterplot of life expectancy against fertility,
     # restricted to only the user-selected year and colored by continent
     # Print information about the most recently clicked point
     tabPanel("Scatterplot against fertility",
       sidebarLayout(
         sidebarPanel(
           # Sidebar with a slider input widget for the year
           sliderInput("year",
                       label = "Year",
                       min = min(gapminder$year),
                       max = max(gapminder$year),
                       value = 2000,
                       step=1, ticks=FALSE, sep="")
         ),

         # Show a scatterplot of life expectancy plotted against fertility
         # Print information about the most recently clicked point
         mainPanel(
           plotOutput("scatterPlot", click = "plotClick"),
           verbatimTextOutput("clickInfo")
         )
       ))
   )
)


# Define server logic
server = function(input, output) {

  # For the first tab: time series plot.
  # Use fct_relevel from the forcats package to relevel country so that 
  # the United States is always first and appears as the same color, 
  # no matter what country2 is.
  output$linePlot = renderPlot({
    gapminder %>% filter(country %in% c("United States", input$country2)) %>%
      mutate(country = fct_relevel(country, "United States")) %>%
      ggplot(aes(x = year, y = life_expectancy, color = country)) +
      geom_line() +
      xlab("Year") + ylab("Life expectancy (years)") +
      scale_color_discrete(name = "Country") +
      ggtitle(paste("Life expectancy in the United States and", 
                    input$country2))
  })

  # For the second tab: scatterplot
  output$scatterPlot = renderPlot({
    filter(gapminder, year == input$year) %>%
      ggplot(aes(x = fertility, y = life_expectancy, color = continent)) +
      geom_point() +
      xlab("Fertility (avg. children / woman)") +
      ylab("Life expectancy (years)") +
      scale_color_discrete(name = "Continent") +
      ggtitle(sprintf("Life expectancy vs. fertility in %d", input$year))
  })
  # Print information about the most recently clicked point
  output$clickInfo = renderPrint({
    nearPoints(filter(gapminder, year == input$year) %>%
                 select(life_expectancy, fertility,
                        country, continent),
               input$plotClick)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
