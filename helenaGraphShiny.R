library(shiny)
library(ggplot2)
library(RColorBrewer)
library(dplyr)
library(plotly)

ui = fluidPage(
  titlePanel("How has happiness evolved over time for each continent?"),
  sidebarLayout(
    sidebarPanel(
      
      selectInput("select", "Select:", c("Continent", "Country"), selected = "Continent"), 
      
      conditionalPanel(
        condition = "input.select == 'Country'",
        selectInput(inputId = "y",
                    label = "Y-Axis:",
                    choices = c("South America", "Oceania", "North America", "Europe","Asia","Africa"),selected = "North America"
                    )
      ),
  
      
    ), #sidebar panel
    mainPanel(plotOutput("dynamicHeatmap")
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
    if (input$select == "Country") {
      Cleaned_Combined_Dataset_v2 %>%
        filter(Continent == input$y) %>%
        group_by(Country, Year) %>%
        summarize(avgHappiness = mean(Happiness.Score, na.rm = TRUE)) %>%
        ungroup()
    } else {
      overall_dataset()
    }
  })
  
  #render heat map 
  output$dynamicHeatmap <- renderPlot({
    if(input$select == "Continent") {
    ggplot(selected_continent_dataset(), aes(x=Year, y=Continent, fill=avgHappiness))+geom_raster()+scale_fill_viridis_c(option="viridis")
    }
    else if (input$select == "Country"){
      ggplot(selected_continent_dataset(), aes(x=Year, y=Country, fill=avgHappiness))+geom_raster()+scale_fill_viridis_c(option="viridis")
    }
    
  })
  
  
} #function


shinyApp(ui, server) 