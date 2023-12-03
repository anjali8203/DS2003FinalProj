library(shiny)
library(ggplot2)
library(RColorBrewer)
library(plotly)

ui = fluidPage(
  titlePanel("How has happiness evolved over time for each continent?"),
  sidebarLayout(
    sidebarPanel(
      
      selectInput("select", "Select:", c("Overall", "Continent"), selected = "Overall"), 
      
      conditionalPanel(
        condition = "input.select == 'Continent'",
        selectInput(inputId = "y",
                    label = "Y-Axis:",
                    choices = c("South America", "Oceania", "North America", "Europe","Asia","Africa"),
                    selected = "North America")
      ),
      
      
    ), #sidebar panel
    mainPanel(plotOutput("heatmap")
    )
  )
)

server = function(input,output){
  
  overall_dataset <- reactive({
    Cleaned_Combined_Dataset_v2 %>%
      group_by(Continent, Year) %>%
      summarize(avgHappiness = mean(Happiness.Score, na.rm = TRUE)) %>%
      ungroup()
  })
  
  selected_continent_dataset <- reactive({
    if (input$select == "Continent") {
      Cleaned_Combined_Dataset_v2 %>%
        filter(Continent == input$select) %>%
        group_by(Country, Year) %>%
        summarize(avgHappiness = mean(Happiness.Score, na.rm = TRUE)) %>%
        ungroup()
    } else {
      overall_dataset()
    }
  })
  
  #render heat map 
  output$heatmap <- renderPlotly({
    plot_ly(
      selected_continent_dataset(),
      x = ~Year,
      y = ~get(input$y),
      z = ~avgHappiness,
      type = "heatmap",
      colorscale = "Viridis",
      colorbar = list(title = "Average Happiness Score"),
    ) %>%
      layout(
        xaxis = list(title = "Year"),
        yaxis = list(title = input$y),
        title = "Average Happiness Scores Over Time",
        showlegend = TRUE
      )
  })
  
  
} #function


shinyApp(ui, server) 