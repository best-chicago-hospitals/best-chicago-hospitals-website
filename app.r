install.packages("shiny")                                                                                                                                                                                          
install.packages("ggmap")
install.packages("viridis")
install.packages("leaflet")        
#after installing, use library function for packages for future use

hospitals <- read.csv(file.choose(), header=T)
hospitals$US_News_and_World_Report_State_Ranking<- as.factor(gsub("0", "Not ranked", hospitals$US_News_and_World_Report_State_Ranking))                                                                                                                                            

pal <- colorNumeric("magma", c(0,5))

ui<- fluidPage(h1("Amulet Health"), h2("To guide your healthcare jouney"), mainPanel(leafletOutput("myMap"), sidebarPanel(sliderInput("score", "Amulet score:", min = 0, max = 5, value = c(1,5)), absolutePanel(textInput("Zip_code", "Zip Code" , "Ex: 60612")))))
server<- function(input,output){
 output$myMap <- renderLeaflet({
   leaflet(hospitals) %>%
     addTiles() %>%
     addCircleMarkers(lat = ~Lat, lng = ~Long,
                      popup = ~paste0("<b>",Hospital_Name, "</b><br>Amulet score: ", Total_composite_score, "</b><br>Hospital Compare Star Rating: ", Hospital_Compare_Star_Rating, "</b><br>Leapfrog Safety Grade: ", Leapfrog_Safety_Grade, "</b><br>US News and World Report Illinois Ranking: ", US_News_and_World_Report_State_Ranking, "</b><br>Magnet Nursing designation: ", Magnet_Designation),
                      color = ~pal(Total_composite_score),
                      opacity = 1) %>%
     addLegend("bottomright", pal = pal, values = ~Total_composite_score,
               title = "Amulet Score",
               opacity = 1)
})
}
shinyApp(ui=ui, server=server)
