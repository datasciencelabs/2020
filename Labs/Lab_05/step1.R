library(tidyverse)

# Arrest data
data("USArrests")

# Define UI
ui = fluidPage( 
    # Radio buttons that allows the user to choose a crime
    radioButtons(inputId = "crime", label = "Select a crime",
                 choices = c("Murder", "Assault", "Rape")), 
    
    # Plot
    plotOutput("plot")
)

# Define server logic
server = function(input, output){
    # Scatterplot for the selected crime
    output$plot = renderPlot({
        ggplot(USArrests, aes_string(x = "UrbanPop", y = input$crime)) + 
            geom_point() + 
            xlab("Percent urban population in state") +
            ylab(paste(input$crime, "arrests per 100,000"))
    })
}

shinyApp(ui = ui, server = server)
