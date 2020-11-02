# This was the RShiny app that we live-coded during lab. Please see
# step1.R, step2.R, etc for the RShiny apps corresponding to each question in
# the Rmd document.

library(shiny)
library(tidyverse)
library(maps)

data("USArrests")
us_map <- map_data("state")

# make a column in USArrests that we'll use for joining
USArrests <- USArrests %>%
    mutate(region = str_to_lower(rownames(USArrests)))

# merge the arrests with map data
#arrests_map <- right_join(USArrests, us_map, by = "region")
# set up mapping from crime to which type of colors to use
gradient_fill <- c(Murder = "viridis", Assault = "magma", Rape = "plasma")


# Define UI
ui <- fluidPage(
    # Application title
    titlePanel("1973 Violent Crime Arrests in the United States"),

    # first row: interactive elements
    fluidRow(
        # first column: explanatory text
        column(3,
            p("This Shiny app uses the", code("USArrests"), "dataset to
              examine the variability in violent arrest statistics across
              states in the US."),
            br()
        ), # end of first column

        # second column: radio button to choose the crime
        column(3,
            radioButtons(inputId = "crime", label = "Select a crime",
                         choices = c("Murder", "Assault", "Rape"),
                         selected = "Assault")
        ), # end of second column

        # third column: dropdown menu to select the color
        column(3,
            selectInput(inputId = "color", label = "Choose a color:",
                        choices = list("Black" = "black", "Blue" = "blue",
                                       "Red" = "red", "Green" = "green"))
        ), # end of third column

        # fourth column: radio button to select scatterplot or heatmap
        column(3,
            radioButtons(inputId = "plot_type", label = "What kind of plot?",
                         choices = c("Scatterplot", "Heatmap"))
        ), # end of fourth column

    ), # end of fluidRow

    # plot output and text output
    fluidRow(
        column(9,
            plotOutput("plot")
        ), # end of column 1
        column(3,
            textOutput("top_state")
        ) # end of column 2
    ) # end of fluidRow
) # fluidPage

# Define server logic
server <- function(input, output) {
    arrests_map <- reactive({
        USArrests %>%
            select("region", input$crime) %>%
            right_join(us_map, by = "region")
    })

    output$plot <- renderPlot({
        if (input$plot_type == "Scatterplot") {
            # make a scatter plot of murder vs urbanpop
            ylabel <- paste(input$crime, "arrests per 100,000")
            ggplot(USArrests, aes_string(x = "UrbanPop", y = input$crime)) +
                geom_point(color = input$color) +
                xlab("Percent urban population in state") +
                ylab(ylabel) +
                scale_y_log10(limits = c(0.5, 340))
        } else if (input$plot_type == "Heatmap") {
            #print(input$crime)
            arrests_map() %>%
                ggplot(aes(x = long, y = lat, group = group)) +
                geom_polygon(aes_string(fill = input$crime), color = "white") +
                scale_fill_viridis_c(option = gradient_fill[input$crime],
                                     name = paste(input$crime,
                                                  "arrests\nper 100,000")) +
                theme(panel.grid.major = element_blank(),
                      panel.background = element_blank(),
                      axis.title = element_blank(),
                      axis.text = element_blank(),
                      axis.ticks = element_blank())
        }
    }) # end of renderPlot

    output$top_state <- renderText({
        crime <- input$crime
        max_idx <- which.max(USArrests[, crime])
        max_state <- USArrests$region[max_idx]
        max_state
        paste0("The state with the most ", tolower(input$crime),
               " arrests per capita is ", str_to_title(max_state), ".")
    })
}

# Run the application
shinyApp(ui = ui, server = server)

