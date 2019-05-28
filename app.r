library(shiny)
library(ggmap)
library(viridis)
library(leaflet)

# uncomment and fill data.dir.path to run without having to 
# browse for the file
# data.dir.path <- "path/to/data/dir"
# data.file.path <- paste(data.dir.path, "/Info+Rankings 5-21-19.csv", sep = "")
# hospitals <- read.csv(data.file.path, header=T)

hospitals <- read.csv(file.choose(), header=T)
hospitals$US_News_and_World_Report_State_Ranking<- 
  as.factor(gsub("0",  "Not ranked", hospitals$US_News_and_World_Report_State_Ranking))

pal <- colorNumeric("magma", c(0,5))

################################################################################
# UI
################################################################################
ui<- fluidPage(h1("Amulet Health"), 
               h2("To guide your healthcare jouney"), 
               mainPanel(leafletOutput("myMap"), 
                         sidebarPanel(sliderInput("score", "Amulet score:", min = 0, max = 5, value = c(1,5)), 
                                      absolutePanel(textInput("Zip_code", "Zip Code" , "Ex: 60612")))),
               hr(),
               fluidRow(column(3, verbatimTextOutput("value"))))

################################################################################
# SERVER
################################################################################
server<- function(input,output){
  
  # Grab the slider input
  slider.in <- reactive({
    hospitals[hospitals$Total_composite_score >= input$score[1] &
                hospitals$Total_composite_score <= input$score[2],]
  })
  
  output$myMap <- renderLeaflet({
    # Static parts of the map go here in leaflet
    leaflet(hospitals) %>%
      addTiles() %>%
      # Zoom the map in and draw the legend
      fitBounds(~min(Long), ~min(Lat), ~max(Long), ~max(Lat)) %>%
      addLegend("bottomright", pal = pal, values = ~Total_composite_score,
                title = "Amulet Score",
                opacity = 1)
  })
  
  # Observe pattern to catch changes in the slider and change the circleMarkers
  observe({
    # Dynamic parts of the map go here in leafletProxy
    leafletProxy("myMap", data=slider.in()) %>%
      clearMarkers() %>%
      addCircleMarkers(lat = ~Lat, lng = ~Long,
                       popup = ~paste0("<a href=\"",url, "\">", Hospital_Name, "</a></b><br>Amulet score: ", Total_composite_score, 
                                       "</b><br>Hospital Compare Star Rating: ", Hospital_Compare_Star_Rating, 
                                       "</b><br>Leapfrog Safety Grade: ", Leapfrog_Safety_Grade, 
                                       "</b><br>US News and World Report Illinois Ranking: ", US_News_and_World_Report_State_Ranking, 
                                       "</b><br>Magent Nursing designation: ", Magnet_Designation),
                       color = ~pal(Total_composite_score),
                       opacity = 1) 
  })
}
shinyApp(ui=ui, server=server)
