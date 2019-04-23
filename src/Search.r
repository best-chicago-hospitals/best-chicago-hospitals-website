
#Load Libraries
library("tidyverse")
library("stringdist")
library("gdata")
library("ggplot2")
library("ggmap")

#Load Datasets
specialities.df <- read.csv("./data/DoctorsAggregateBySpecialty.csv", stringsAsFactors=FALSE, strip.white=TRUE)
specialities.df$Hospital_Name <- toupper(specialities.df$Hospital_Name)
glimpse(specialities.df)

hospitals.df <- read.csv("./data/Info+Rankings update and weighted score 4-13-19.csv", stringsAsFactors=FALSE, strip.white=TRUE)
hospitals.df <- cbind(hospitals.df[1:12], hospitals.df[32:46])
glimpse(hospitals.df)

doctors.df <- read.csv("./data/2019 Castle Connely Chicago Top Doctors_sm updated 3-30-19.csv", stringsAsFactors=FALSE, strip.white=TRUE)
doctors.df$Hospital1 <- toupper(doctors.df$Hospital1)
doctors.df$Hospital2 <- toupper(doctors.df$Hospital2)
glimpse(doctors.df)

#Left Join Specialties and Hospitals
left_join(specialities.df, hospitals.df, by="Hospital_Name") %>% filter(is.na(Address)) %>% distinct(Hospital_Name)

#Right Join Specialties and Hospitals
spec_hosp.df <- right_join(specialities.df, hospitals.df, by="Hospital_Name")
spec_hosp.df$TopDoctors <- ifelse(is.na(spec_hosp.df$TopDoctors), 0, spec_hosp.df$TopDoctors)
spec_hosp.df$Specialty <- ifelse(is.na(spec_hosp.df$Specialty), "", spec_hosp.df$Specialty)
spec_hosp.df %>% filter(City == "BOLINGBROOK")

hospitalsFilteredAndRanked <- function(specialty="", minlon=NA, minlat=NA, maxlon=NA, maxlat=NA, start=0, limit=20, flag=NA){
    if (nchar(specialty) > 4){
        shortspecialty <- substr(specialty,0,6)
        results.df <- cbind(startsWith(spec_hosp.df$Specialty, shortspecialty, trim=TRUE, ignore.case=TRUE), stringdist("Neurology", spec_hosp.df$Specialty), spec_hosp.df)
        names(results.df)[1] <- "startWith"
        names(results.df)[2] <- "stringDist"
        results.df <- results.df %>% arrange(-startWith, stringDist, -TopDoctors, -Total_composite_score) 
        if (!is.na(minlon) && !is.na(minlat) && !is.na(maxlon) && !is.na(maxlat)){
            results.df <- results.df %>% filter(Lat < maxlat, Lat > minlat, Long < maxlon, Long > minlon)
        }
    }else if (!is.na(minlon) && !is.na(minlat) && !is.na(maxlon) && !is.na(maxlat)){
        results.df <- hospitals.df %>% arrange(-Total_composite_score) %>% filter(Lat < maxlat, Lat > minlat, Long < maxlon, Long > minlon)
    }else{
        results.df <- hospitals.df %>% arrange(-Total_composite_score)
    }
    numresults = nrow(results.df)
    if (numresults == 0){
        return(hospitalsFilteredAndRanked(specialty, start, limit, flag="NO RESULTS FOR AREA"))
    }else{
        results.df <- results.df %>% slice(start:(start+limit))
        if (nrow(results.df) == 0){
            return(hospitalsFilteredAndRanked(specialty, flag="NO RESULTS FOR PAGING"))
        }
        return(list(total=numresults, start=start, limit=limit, "flag"=flag, "results"=results.df))
    } 
}

#Search by Specialty and Geographic Bounding
maxlat <- 41.9 #41.881832
maxlon <- -87.6 #-87.623177
minlat <- 41.8 #41.881832
minlon <- -87.7 #-87.623177

hospitalsFilteredAndRanked("Neurology", minlon, minlat, maxlon, maxlat)

#Search by Only Geographic Bounding
maxlat <- 41.9 #41.881832
maxlon <- -87.6 #-87.623177
minlat <- 41.85 #41.881832
minlon <- -87.65 #-87.623177

hospitalsFilteredAndRanked("", minlon, minlat, maxlon, maxlat)

#Search by limited or bad geographic bounding
maxlat <- 47.9 #41.881832
maxlon <- -85.6 #-87.623177
minlat <- 47.85 #41.881832
minlon <- -85.65 #-87.623177

hospitalsFilteredAndRanked("", minlon, minlat, maxlon, maxlat)

#Filter by Name
result.df <- hospitalsFilteredAndRanked("Neurology")$results
hospitalByName <- function(results, name){
    return(results[which(results$Hospital_Name == name), ])
}
hospitalByName(result.df, "UNIVERSITY OF ILLINOIS HOSPITAL")

#Get Min-Max latitude longitudes
getInitialBounding <- function(){
    tmp.df <- hospitals.df %>% select(Long, Lat) %>%
                    summarize(minlon = min(Long), minlat = min(Lat), 
                               maxlon = max(Long), maxlat = max(Lat))
    return(list(
        "minlon" = tmp.df[1, "minlon"],
        "minlat" = tmp.df[1, "minlat"],
        "maxlon" = tmp.df[1, "maxlon"],
        "maxlat" = tmp.df[1, "maxlat"]
    ))
}
getInitialBounding()


