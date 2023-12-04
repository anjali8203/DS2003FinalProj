library(shiny)

# UI components
ui <- fluidPage(
  titlePanel("Group Introduction & Dataset Explanation"),
  
  mainPanel(
    # Main content
    h2("Welcome!"),
    
    h3("Group Members"),
    p("Anjali Mehta"),
    p("Daphne Pfoser"),
    p("Helena Moore"),
    p("Anisha Ponugupati"),
    p("Manaswini Tadigadapa"),
    
    h3("Dataset Explanation"),
    p("The World Happiness Report is an annual survey tracking global happiness levels since 2012. Released at the UN's International Day of Happiness, it ranks 155 countries based on happiness indicators. Experts from various fields contribute to analyzing well-being's role in assessing a nation's progress."),
    p("Using Gallup World Poll data, the report assigns happiness scores using the Cantril ladder, where respondents rate their life satisfaction. Factors like economic production, social support, life expectancy, freedom, lack of corruption, and generosity are assessed to explain why some countries rank higher in happiness than others. These factors don't alter individual country scores but shed light on variations in happiness levels."),
    
    h3("Data Cleaning Process"),
    p("The process here involved cleaning multiple datasets (2015 to 2019) related to the World Happiness Report. Initially, the datasets were read and merged, and a column for the year was added to each dataset for identification purposes."),
    p("The column names varied across years, so the next step was to unify them. Columns with similar meanings but different names were renamed consistently across the datasets using the `rename` function from the `dplyr` library."),
    p("To identify common columns across all datasets, the code used the `Reduce` function and `intersect` to find and print the column names that were shared among the datasets."),
    p("Some additional cleaning involved converting the Perception of Corruption column to double data type in all datasets to ensure uniformity."),
    p("Finally, the cleaned datasets were combined into a single dataframe containing only the common columns from each year for further analysis. Additionally, an extra dataset correlating countries to continents was integrated by binding columns based on matching country names, providing continent-specific context alongside the happiness-related data.")
  )
)

# Server logic (if needed for any future interactivity)

# Run the application
shinyApp(ui = ui, server = function(input, output) { })
