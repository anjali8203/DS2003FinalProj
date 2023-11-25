library(shiny)
library(ggplot2)
library(shinythemes)
library(dplyr)
library(ggwordcloud)

CD <- read.csv("Cleaned_Combined_Dataset.csv")

ui <- fluidPage(theme = shinytheme("superhero"),
                navbarPage("FINAL PROJECT NAME HERE ",
                           tabPanel("FIRST TAB HERE ",
                                    sidebarPanel(
                                      selectInput("num", "Select Numerical Variable:",
                                                  choices = c("Age", "Courses", "States"),
                                                  selected = "Age")
                                    ),
                                    mainPanel(plotOutput("numgraph"))
                           ),
                           tabPanel("SECOND TAB HERE ",
                                    sidebarPanel(
                                      selectInput("cat1", "Select Cat Var:",
                                                  choices = c("Year", "Summer", "Major", "Sport"),
                                                  selected = "Sport"),
                                      numericInput("size1", "Max Size:", min = 20, max = 100,
                                                   value = 25, step = 2)
                                    ),
                                    mainPanel(plotOutput("catgraph1"))
                           ),
                           tabPanel("THIRD TAB HERE ",
                                    sidebarPanel(
                                      selectInput("cat2", "Select Cat Var:",
                                                  choices = c("Year", "Summer", "Major", "Sport"),
                                                  selected = "Sport"),
                                      numericInput("size2", "Max Size:", min = 20, max = 100,
                                                   value = 25, step = 2)
                                    ),
                                    mainPanel(plotOutput("catgraph2"))
                           )
                )
)

server <- function(input, output) {
  output$numgraph <- renderPlot({
    ggplot(CD, aes_string(input$num)) + geom_boxplot(fill = "tomato", outlier.colour = "black")
  })
  
  dat1 <- reactive({
    CD %>%
      group_by(var = get(input$cat1)) %>%
      summarise(Students = n())
  })
  
  output$catgraph1 <- renderPlot({
    ggplot(dat1(), aes(label = dat1()$var, size = dat1()$Students, color = dat1()$var)) +
      geom_text_wordcloud_area() +
      scale_size_area(max_size = input$size1) +
      scale_color_viridis_d(option = "turbo")
  })
  
  dat2 <- reactive({
    CD %>%
      group_by(var = get(input$cat2)) %>%
      summarise(Students = n())
  })
  
  output$catgraph2 <- renderPlot({
    ggplot(dat2(), aes(label = dat2()$var, size = dat2()$Students, color = dat2()$var)) +
      geom_text_wordcloud_area() +
      scale_size_area(max_size = input$size2) +
      scale_color_viridis_d(option = "turbo")
  })
}

shinyApp(ui, server)
