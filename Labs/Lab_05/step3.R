library(tidyverse)

# Arrest data
data("USArrests")

# Define UI
ui = fluidPage( 
    titlePanel("1973 Violent Crime Arrests in the United States"),
    
    # Sidebar
    sidebarLayout(
        
        # Widgets for selection
        sidebarPanel(
            # Radio buttons that allows the user to choose a crime
            radioButtons(inputId = "crime", label = "Select a crime",
                         choices = c("Murder", "Assault", "Rape"))
        ),
        
        # Main panel
        mainPanel(
            # Plot
            plotOutput("plot")
        )
    )
)

# Define server logic
server = function(input, output){
    # Scatterplot for the selected crime
    output$plot = renderPlot({
        ggplot(USArrests, aes_string(x = "UrbanPop", y = input$crime)) + 
            geom_point() + 
            scale_y_log10(limits = c(0.5, 340)) + 
            xlab("Percent urban population in state") +
            ylab(paste(input$crime, "arrests per 100,000 (log scale)"))
    })
}

shinyApp(ui = ui, server = server)
