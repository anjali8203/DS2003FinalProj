# Project # 2: World Happiness Report 
#loading the libraries 
library(shiny)
library(ggplot2)
library(plotly)
library(RColorBrewer)
library(dplyr)

#load the happiness data: 
happiness <- read.csv("/Users/daphnepfoser/Documents/DS 2003( communicating with data)/Cleaned_Combined_Dataset_v2.csv")
# 1. making the continent csv a dataset:
continent <- read.csv("/Users/daphnepfoser/Documents/DS 2003( communicating with data)/version3 (1).csv")
# 2 combining continent and happiness:
continent_combined <- merge(happiness, continent)

# UI
ui <- fluidPage(
  titlePanel("Which of These Factors is Most Strongly Associated with World Happiness? "),
  sidebarLayout(
    sidebarPanel(
      sliderInput("year", "Select the Year:", 
                  min = ifelse(is.null(continent_combined$Year) || any(is.na(continent_combined$Year)), 0, min(continent_combined$Year)), 
                  max = ifelse(is.null(continent_combined$Year) || any(is.na(continent_combined$Year)), 0, max(continent_combined$Year)), 
                  value = ifelse(is.null(continent_combined$Year) || any(is.na(continent_combined$Year)), 0, 2019), 
                  step = 1,
                  sep = ""),
      selectInput("xcol", "Happiness", c("Happiness.Rank", "Happiness.Score"), selected = "Happiness.Score"),
      radioButtons("ycol", "vs. Factor:", 
                   choices = c("Life.Expectancy", "Freedom", "Perception.of.Corruption", "Generosity", "GDP.per.capita"), 
                   selected = "Life.Expectancy"),
      selectInput("size", "Additional Variable (Circle Size):", 
                  choices = c("Life.Expectancy", "Freedom", "Perception.of.Corruption", "Generosity", "GDP.per.capita"), 
                  selected = "Generosity"),
      selectInput("palette", "Select Color Palette:", 
                  choices = c("Brewer Set1" = "Set1", 
                              "Brewer Set2" = "Set2",
                              "Brewer Set3" = "Set3",
                              "Paired" = "Paired",
                              "Accent" = "Accent")), 
      hr(),  
      h4("Summary of visualization"),
      textOutput("dynamicText")  
    ),
    mainPanel(
      plotlyOutput("staticPlot"), 
      hr(),
      h3(style = "font-size: smaller;", "In summary, the bubble plot analysis suggests that GDP per capita is a likely factor strongly associated with overall world happiness, while life expectancy, freedom, perception of corruption, and generosity demonstrate a more complex relationship with happiness. Understanding these patterns is important for policymakers, communities, and individuals."),
      p("")
    )
  )
)

# Server
server <- function(input, output) {
  output$staticPlot <- renderPlotly({
    continent_combined <- na.omit(continent_combined[continent_combined$Year == input$year, ])
    
    # Custom tooltip content
    tooltip_content <- paste("<br>Country:",  continent_combined$Country,
                             "<br>",input$xcol,":", continent_combined[[input$xcol]], 
                             "<br>",input$ycol,":", continent_combined[[input$ycol]], 
                             "<br>",input$size,":", continent_combined[[input$size]]
    )
    
    ggplotly(
      ggplot(continent_combined, aes_string(x = input$xcol, y = input$ycol, size = input$size, color = "Continent", text="tooltip_content")) +
        geom_point(alpha = 0.5) +
        scale_color_brewer(palette = input$palette),
      tooltip = "text"
    )
  })
  
  output$dynamicText <- renderText({
    paste("Comparing", input$xcol, "to", input$ycol,".\nAdditional variable", input$size, "shown as circle size.\nContinents shown as COLORS.")
  })
}

shinyApp(ui, server)
