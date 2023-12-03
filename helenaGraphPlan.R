library(shiny)
library(ggplot2)
library(RColorBrewer)
library(plotly)

#widgets: 1- year slider (choose range), 2- color palette selector, 3- select a continent to view all countries
#

dataset <- Cleaned_Combined_Dataset_v2 %>%
  group_by(Continent, Year) %>%
  summarize(avgHappiness = mean(Happiness.Score, na.rm = TRUE)) %>%
  ungroup()%>%slice(-11)

ggplot(dataset, aes(x=Year, y=Continent, fill=avgHappiness))+geom_raster()+scale_fill_viridis_c(option="viridis")

southAmerica <- Cleaned_Combined_Dataset_v2 %>%filter(Continent=="South America")%>%
  group_by(Country, Year) %>%
  summarize(avgHappiness = mean(Happiness.Score, na.rm = TRUE)) %>%
  ungroup()

ggplot(southAmerica, aes(x=Year, y=Country, fill=avgHappiness))+geom_raster()+scale_fill_viridis_c(option="viridis")

northAmerica <- Cleaned_Combined_Dataset_v2 %>%filter(Continent=="North America")%>%
  group_by(Country, Year) %>%
  summarize(avgHappiness = mean(Happiness.Score, na.rm = TRUE)) %>%
  ungroup()

ggplot(northAmerica, aes(x=Year, y=Country, fill=avgHappiness))+geom_raster()+scale_fill_viridis_c(option="viridis")

unique(Cleaned_Combined_Dataset_v2$Continent)





