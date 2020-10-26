library(tidyverse)
library(maps)

# Arrest data
data("USArrests")
USArrests = USArrests %>% 
    mutate(region = str_to_lower(rownames(USArrests)))

# State latitude and longitude information
us_map = map_data("state")
# Heatmap colors for different crime types
gradient_fill = c(Murder = "viridis", Assault = "magma", Rape = "plasma")

# Define UI
ui = fluidPage( 
    titlePanel("1973 Violent Crime Arrests in the United States"),
    
    # Sidebar
    sidebarLayout(
        
        # Widgets for selection
        sidebarPanel(
            # Explanatory text
            p("This Shiny app uses the", code("USArrests"), "dataset to 
              examine the variability in violent arrest statistics across 
              states in the US."),
            
            br(),
            
            # Radio buttons that allows the user to choose a crime
            radioButtons(inputId = "crime", label = "Select a crime",
                         choices = c("Murder", "Assault", "Rape")),
            
            # Dropdown menu that allows the user to choose a point color for 
            # the scatterplot
            selectInput(inputId = "color", label = "Choose a point color",
                        choices = c(Black = "black", Blue = "blue", 
                                    Red = "red", Green = "green")),
            
            # Radio buttons for the user to choose a scatterplot or heatmap
            radioButtons(inputId = "plot_type", label = "What kind of plot?",
                         choices = c("Scatterplot", "Heatmap"))
        ),
        
        # Main panel
        mainPanel(
            # Plot
            plotOutput("plot"),
            br(), 
            # Message about the state with the most arrests per capita
            textOutput("top_state")
        )
    )
)

# Define server logic
server = function(input, output){
    # Reactive dataset for mapping
    arrests_map = reactive(USArrests %>% select("region", input$crime) %>% 
                               right_join(us_map, by = "region"))
    
    # Make the selected plot for the selected crime
    output$plot = renderPlot({
        if (input$plot_type == "Scatterplot"){
            # Scatterplot for the selected crime
            ggplot(USArrests, aes_string(x = "UrbanPop", y = input$crime)) + 
                geom_point(color = input$color) + 
                scale_y_log10(limits = c(0.5, 340)) + 
                xlab("Percent urban population in state") +
                ylab(paste(input$crime, "arrests per 100,000 (log scale)"))
            
        } else if (input$plot_type == "Heatmap"){
            # Heatmap for the selected crime
            arrests_map() %>% ggplot(aes(x = long, y = lat, group = group)) +
                geom_polygon(aes_string(fill = input$crime), color = "white") +
                scale_fill_viridis_c(name = paste(input$crime, 
                                                  "arrests \n per 100,000"), 
                                     option = gradient_fill[input$crime]) + 
                theme(panel.grid.major = element_blank(), 
                      panel.background = element_blank(),
                      axis.title = element_blank(), 
                      axis.text = element_blank(),
                      axis.ticks = element_blank())
        }
    })
    
    # Identify the state with the most arrests per capita for the selected crime
    output$top_state = renderText({
        top_state = USArrests %>% 
            slice_max(order_by=!!as.name(input$crime), n=1) %>% 
            select(region) %>% str_to_title()
        paste0("The state with the most ", tolower(input$crime), 
               " arrests per capita is ", top_state, ".")
    })
}

shinyApp(ui = ui, server = server)
