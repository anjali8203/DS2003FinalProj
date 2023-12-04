library(shiny)
library(ggplot2)
library(RColorBrewer)
library(dplyr)
library(plotly)

ui = fluidPage(
  titlePanel("How has happiness evolved over time for each continent?"),
  sidebarLayout(
    sidebarPanel(
      
      radioButtons("select", "Select:", c("Continent", "Country"), selected = "Continent"),
      
      conditionalPanel(
        condition = "input.select == 'Country'",
        selectInput(inputId = "y",
                    label = "Y-Axis:",
                    choices = c("South America", "Oceania", "North America", "Europe","Asia","Africa"),selected = "North America"
        )
      ),
      
     sliderInput("range", "Year Range:", min = 2015, max = 2019, value = c(2015,2019)),
     selectInput(inputId = "color", label = "Color Palette:",
                 choices = c("viridis", "magma", "inferno", "plasma","turbo"), selected = "plasma"),
      
    ), #sidebar panel
    mainPanel(plotOutput("dynamicHeatmap")
    )
  )
)

server = function(input,output){
  
  overall_dataset <- reactive({
    version3 %>%
      filter(Year >= input$range[1] & Year <= input$range[2] & !is.na(Continent)) %>% 
      group_by(Continent, Year) %>%
      summarize(avgHappiness = mean(Happiness.Score, na.rm = TRUE)) %>%
      ungroup()
  })
  
  selected_continent_dataset <- reactive({
    if (input$select == "Country") {
     version3 %>%
        filter(Continent == input$y, Year >= input$range[1] & Year <= input$range[2]) %>%
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
    ggplot(selected_continent_dataset(), aes(x=Year, y=Continent, fill=avgHappiness))+geom_raster()+scale_fill_viridis_c(option=input$color)
    }
    else if (input$select == "Country"){
      ggplot(selected_continent_dataset(), aes(x=Year, y=Country, fill=avgHappiness))+geom_raster()+scale_fill_viridis_c(option=input$color)
    }
    
  })
  
} #function


shinyApp(ui, server) 