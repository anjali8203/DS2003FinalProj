# Load necessary libraries
library(shiny)
library(ggplot2)
library(dplyr)
library(viridis) 
library(maps)

df <- read.csv("/Users/Anisha/Desktop/DS 2003/version3.csv")
data <- na.omit(df)
new_column_names <- c("Country", "Continent", "Happiness.Rank", "Happiness.Score",
                      "GDP.per.capita", "Life.Expectancy", "Freedom",
                      "Perception.of.Corruption", "Generosity", "Year")
colnames(data) <- new_column_names
world_map <- map_data("world")


# UI
ui <- fluidPage(
  titlePanel("World Map Visualization"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("year", "Select Year", 
                  min = min(data$Year), 
                  max = max(data$Year), 
                  value = min(data$Year),
                  step = 1, 
                  sep=""),
      selectInput("variable", "Select Variable", 
                  choices = c("Happiness.Score", "GDP.per.capita", "Life.Expectancy", 
                              "Freedom", "Perception.of.Corruption", "Generosity"), 
                  selected = "Happiness.Score"),
      selectizeInput("color_gradient", "Select Color Gradient", 
                     choices = c("viridis", "magma", "plasma", "inferno"), 
                     selected = "viridis"), 
      width=3
    ),
    mainPanel(
      plotOutput("worldMap", height = "600px", width = "1000px"), 
      style = "position: fixed; bottom: 3; left: 60%; transform: translateX(-50%);")
  )
)

# Server
server <- function(input, output) {
  output$worldMap <- renderPlot({
    filtered_data <- data %>%
      filter(Year == input$year)
    
    ggplot(filtered_data, aes(fill = .data[[input$variable]], map_id = Country)) +
      geom_map(map = world_map, aes(map_id = Country), color = "black") +
      expand_limits(x = world_map$long, y = world_map$lat) +
      scale_fill_viridis_c(option = input$color_gradient, name = input$variable) +
      theme_minimal() +
      labs(title = paste("World Map -", input$variable, "-", input$year))
  })
}

# Run the application
shinyApp(ui = ui, server = server)

