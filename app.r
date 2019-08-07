library(shiny)
library(ggmap)
library(viridis)
library(leaflet)
library(sendmailR)
library(sp)
library(rgeos)

# uncomment and fill data.dir.path to run without having to 
# browse for the file
# data.dir.path <- "path/to/data/directory"
# data.file.path <- paste(data.dir.path, "/Info+Rankings_urls_22-May-2019.csv", sep = "")
# hospitals <- read.csv(data.file.path, header=T)

# The email address that will receive the email addresses submitted through the site
email_target <- "emailaddress@test.com"

# Get the hospital db data
hospitals <- read.csv(file.choose(), header=T)
hospitals$US_News_and_World_Report_State_Ranking<- 
  as.factor(gsub("0",  "Not ranked", hospitals$US_News_and_World_Report_State_Ranking))

pal <- colorNumeric("magma", c(0,5))

# Function for validating the submitted email address
isValidEmail <- function(x) {
  grepl("\\<[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\>", as.character(x), 
        ignore.case=TRUE)
}

isValidZip <- function(x) {
  grepl("^[0-9]{5}(?:-[0-9]{4})?$", as.character(x))
}

# For now, this just sends the submitted email address to the target, along with a timestamp
saveData <- function(data){
  from <- sprintf("<sendmailR@\\%s>", Sys.info()[4])
  to <- email_target
  subject <- "New email submission to amulet"
  body <- list(data, format(Sys.time(), "\n%Y/%m/%d - %H:%M:%OS"))
  sendmail(from, to, subject, body,control=list(smtpServer="ASPMX.L.GOOGLE.COM"))
}

findClosestHospitals <- function(hospital_db, zipQuery){
  sp.geoData <- hospital_db
  coordinates(sp.geoData) <- ~Long+Lat
  
  dist <- gDistance(sp.geoData, zipQuery, byid = TRUE)
  
  min.d <- apply(dist, 1, function(x) order(x, decreasing=F)[2:6])
  newdata <- cbind(hospitals, hospitals[hospitals$Hospital_Name %in% min.d$Hospital_Name,], apply(dist, 1, function(x) sort(x, decreasing=F)[2]))
  
}


################################################################################
# UI
################################################################################

ui <- fluidPage(shinyjs::useShinyjs(),
               title = "Amulet Health",
               h1("Amulet Health"),
               h4("To guide your healthcare jouney"), 
               fluidRow(
                 column(3,
                        br(),
                        textInput("email", h5("Enter your email for help getting a second opinion"),  
                                  value = ""),
                        actionButton("submit", "Submit", class = "btn-primary")
                        )
               ),
               fluidRow(
                 br(),
                 mainPanel(
                 leafletOutput("myMap")
                 )
               ),
               fluidRow(
                 br(),
                 column(3,
                        textInput("Zip_code", "Zip Code" , "Ex: 60612"),
                        actionButton("search", "Search", class = "btn-primary")
                        ),
                 column(3, 
                        sliderInput("score", "Amulet score:", min = 0, max = 5, value = c(1,5))
                        )
                 )
               )

################################################################################
# SERVER
################################################################################
server<- function(input,output){
  
  # Grab the slider input
  slider.in <- reactive({
    hospitals[hospitals$Total_composite_score >= input$score[1] &
                hospitals$Total_composite_score <= input$score[2],]
  })
  
  observeEvent(input$submit, {
    
    if (isValidEmail(input$email)) {
      saveData(input$email)
      showModal(modalDialog(
        title = "Success",
        "Thanks for submitting your email address! 
        We'll get back to you shortly with help finding a second opinion.",
        easyClose = TRUE 
        )
        )
    }
    else {
      showModal(modalDialog(
        title = "Invalid Email",
        "Please enter a valid email address",
        easyClose = TRUE
      ))
    }
  })
  
  observeEvent(input$search, {
    if (isValidZip(input$zip)) {
      # redraw the map to include the nearest point in the map
      
      # generate a new db with just the nearest 5 hospitals
      closest.hospitals <- findClosestHospitals(hospitals, input$zip)
      
    }
    else {
      showModal(modalDialog(
        title = "Invalid zipcode",
        "Please enter a valid  zip code",
        easyClose = TRUE
      ))
    }
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
                       popup = ~paste0("<a href=\"",url, "\">", Hospital_Name, 
                                       "</a></b><br>Amulet score: ", Total_composite_score, 
                                       "</b><br>Hospital Compare Star Rating: ", Hospital_Compare_Star_Rating, 
                                       "</b><br>Leapfrog Safety Grade: ", Leapfrog_Safety_Grade, 
                                       "</b><br>US News and World Report Illinois Ranking: ", 
                                       US_News_and_World_Report_State_Ranking, 
                                       "</b><br>Magent Nursing designation: ", Magnet_Designation),
                       color = ~pal(Total_composite_score),
                       opacity = 1) 
  })
}
shinyApp(ui=ui, server=server)
