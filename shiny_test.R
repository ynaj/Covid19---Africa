rm(list=ls())
## app.R ##
library(flexdashboard)
library(countrycode)
library(dplyr)


## Preparation of the data
data_confirmed <-read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")
data_death <-read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv")

data_confirmed$continent <- countrycode(sourcevar = data_confirmed[, "Country.Region"],
                                        origin = "country.name",destination = "continent") 
africa_confirmed <- data_confirmed %>% filter(continent == "Africa") 
data_death$continent <- countrycode(sourcevar = data_death[, "Country.Region"],
                                    origin = "country.name",destination = "continent") 
africa_death <- data_death %>% filter(continent == "Africa") 
country_africa <- as.character(africa_confirmed$Country.Region)
colnames(africa_confirmed)[2] = "pays"
africa_confirmed <- africa_confirmed[-c(1, 3, 4, 68)]

## ui
ui <- fluidPage(
  titlePanel("Covid 19 - Africa"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "quintile", label = ("Select a country here"),
                  choices = unique(country_africa)
      )),
    
    mainPanel(
      plotOutput(outputId = "plot", height = "500px", width="500px")
    )
  )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  #filtered_data<- reactive({ filter(africa_confirmed, pays == input$quintile)
  #})
  perso_data <- reactive({
    tab1 <- africa_confirmed %>% filter(pays == input$quintile) 
    tab2 = tab1[1,]
    tab3 = t(tab2)
 
  })
  output$plot <- renderPlot({
    par(mar=c(1,1,1,1))
    
    plot(x = perso_data(), type="l", main = input$quintile)
  })
}


shinyApp(ui = ui, server = server)
