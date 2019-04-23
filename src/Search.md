
## Load Libraries


```R
#Load Libraries
library("tidyverse")
library("stringdist")
library("gdata")
library("ggplot2")
library("ggmap")
```

    ── Attaching packages ─────────────────────────────────────── tidyverse 1.2.1 ──
    ✔ ggplot2 3.1.0       ✔ purrr   0.3.1  
    ✔ tibble  2.0.1       ✔ dplyr   0.8.0.1
    ✔ tidyr   0.8.3       ✔ stringr 1.4.0  
    ✔ readr   1.1.1       ✔ forcats 0.3.0  
    Warning message:
    “package ‘tibble’ was built under R version 3.5.2”Warning message:
    “package ‘tidyr’ was built under R version 3.5.2”Warning message:
    “package ‘purrr’ was built under R version 3.5.2”Warning message:
    “package ‘dplyr’ was built under R version 3.5.2”Warning message:
    “package ‘stringr’ was built under R version 3.5.2”── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ✖ dplyr::filter() masks stats::filter()
    ✖ dplyr::lag()    masks stats::lag()
    gdata: read.xls support for 'XLS' (Excel 97-2004) files ENABLED.
    
    gdata: read.xls support for 'XLSX' (Excel 2007+) files ENABLED.
    
    Attaching package: ‘gdata’
    
    The following objects are masked from ‘package:dplyr’:
    
        combine, first, last
    
    The following object is masked from ‘package:purrr’:
    
        keep
    
    The following object is masked from ‘package:stats’:
    
        nobs
    
    The following object is masked from ‘package:utils’:
    
        object.size
    
    The following object is masked from ‘package:base’:
    
        startsWith
    
    Warning message:
    “package ‘ggmap’ was built under R version 3.5.2”Google's Terms of Service: https://cloud.google.com/maps-platform/terms/.
    Please cite ggmap if you use it! See citation("ggmap") for details.


## Load Datasets


```R
#Load Datasets
specialities.df <- read.csv("./data/DoctorsAggregateBySpecialty.csv", stringsAsFactors=FALSE, strip.white=TRUE)
specialities.df$Hospital_Name <- toupper(specialities.df$Hospital_Name)
glimpse(specialities.df)
```

    Observations: 254
    Variables: 3
    $ Hospital_Name <chr> "LOYOLA UNIVERSITY MEDICAL CENTER", "LOYOLA UNIVERSITY …
    $ Specialty     <chr> "Endocrinology, Diabetes & Metabolism", "Adolescent Med…
    $ TopDoctors    <int> 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 12, 1, …



```R
hospitals.df <- read.csv("./data/Info+Rankings update and weighted score 4-13-19.csv", stringsAsFactors=FALSE, strip.white=TRUE)
hospitals.df <- cbind(hospitals.df[1:12], hospitals.df[32:46])
glimpse(hospitals.df)
```

    Observations: 75
    Variables: 27
    $ Hospital_Name                          <chr> "ADVOCATE CHRIST HOSPITAL & ME…
    $ Address                                <chr> "4440 W 95TH STREET", "801 S M…
    $ City                                   <chr> "OAK LAWN", "LIBERTYVILLE", "D…
    $ State                                  <chr> "IL", "IL", "IL", "IL", "IL", …
    $ County                                 <chr> "COOK", "LAKE", "DUPAGE", "LAK…
    $ Zip                                    <int> 60453, 60048, 60515, 60010, 60…
    $ Lat                                    <dbl> 41.72032, 42.27456, 41.81914, …
    $ Long                                   <dbl> -87.73236, -87.95165, -88.0102…
    $ Location                               <chr> "4440 W 95TH STREET OAK LAWN, …
    $ Phone                                  <chr> "(708) 684-8000", "(847) 362-2…
    $ Hospital_Type                          <chr> "Acute Care Hospital", "Acute …
    $ Hospital_Ownership                     <chr> "Voluntary non-profit - Church…
    $ Hospital_Compare_Star_Rating           <int> 3, 5, 4, 4, 3, 4, 5, 3, 3, 3, …
    $ Star_rating_weight_and_score           <dbl> 1.05, 1.75, 1.40, 1.40, 1.05, …
    $ Leapfrog_Safety_Grade                  <chr> "C", "C", "C", "C", "B", "C", …
    $ Leapfrog_grade_conversion              <chr> "3", "3", "3", "3", "4", "3", …
    $ Leapfrog_weight_and_score              <dbl> 1.05, 1.05, 1.05, 1.05, 1.40, …
    $ US_News_and_World_Report_State_Ranking <int> 4, 13, 9, 25, 25, 10, 10, 0, 0…
    $ US_News_ranking_conversion             <int> 5, 3, 4, 1, 1, 4, 4, 0, 0, 0, …
    $ US_News_weight_and_score               <dbl> 0.75, 0.45, 0.60, 0.15, 0.15, …
    $ Magnet_Designation                     <chr> "Y", "Y", "Y", "Y", "Y", "Y", …
    $ Magnet_rating                          <int> 5, 5, 5, 5, 5, 5, 5, 0, 0, 0, …
    $ Magnet_weight_and_score                <dbl> 0.75, 0.75, 0.75, 0.75, 0.75, …
    $ Magnet_Designation_Year                <int> 2014, 2017, 2018, 2018, 2017, …
    $ Redesignation                          <chr> "redesignation", "", "redesign…
    $ Info                                   <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    $ Total_composite_score                  <dbl> 3.60, 4.00, 3.80, 3.35, 3.35, …



```R
doctors.df <- read.csv("./data/2019 Castle Connely Chicago Top Doctors_sm updated 3-30-19.csv", stringsAsFactors=FALSE, strip.white=TRUE)
doctors.df$Hospital1 <- toupper(doctors.df$Hospital1)
doctors.df$Hospital2 <- toupper(doctors.df$Hospital2)
glimpse(doctors.df)
```

    Observations: 364
    Variables: 7
    $ Doctor          <chr> "Thomas J. Grobelny", "Ricarchito B. Manera", "Akemi …
    $ Specialty       <chr> "Neuroradiology", "Pediatric Hematology-Oncology", "O…
    $ Hospital1       <chr> "ADVOCATE CHRIST HOSPITAL & MEDICAL CENTER", "ADVOCAT…
    $ Hospital2       <chr> "ADVOCATE LUTHERAN GENERAL HOSPITAL", "", "", "", "",…
    $ CityState       <chr> "Oak Lawn, IL 60453", "Oak Lawn, IL 60453", "Libertyv…
    $ Phone           <chr> "847-430-6108", "708-684-4094", "847-680-3400", "630-…
    $ Board.Certified <chr> "Diagnostic Radiology", "Pediatrics", "Obstetrics and…


### Left Join Specialties and Hospitals

To find out what hospitals/clinics will be left out


```R
#Left Join Specialties and Hospitals
left_join(specialities.df, hospitals.df, by="Hospital_Name") %>% filter(is.na(Address)) %>% distinct(Hospital_Name)
```


<table>
<thead><tr><th scope=col>Hospital_Name</th></tr></thead>
<tbody>
	<tr><td>FOX RIDGE MEDICAL ASSOCIATES                           </td></tr>
	<tr><td>EDWARD HINES, JR. VA HOSPITAL                          </td></tr>
	<tr><td>UNIVERSITY OF CHICAGO-COMER CHILDREN'S HOSPITAL        </td></tr>
	<tr><td>ST. JOHN'S HOSPITAL - SPRINGFIELD                      </td></tr>
	<tr><td>RONALD MCDONALD CHILDREN'S HOSPITAL-LOYOLA             </td></tr>
	<tr><td>MEMORIAL MEDICAL CENTER-SPRINGFIELD                    </td></tr>
	<tr><td><span style=white-space:pre-wrap>UNIVERSITY OF ILLINOIS AT CHICAGO EYE &amp; EAR INFIRMARY  </span></td></tr>
	<tr><td>ROBBINS HEADACHE CLINIC                                </td></tr>
	<tr><td>NORTHWESTERN MEDICINE MARIANJOY REHABILITATION HOSPITAL</td></tr>
	<tr><td>OSF SAINT FRANCIS MEDICAL CENTER                       </td></tr>
	<tr><td>SHIRLEY RYAN ABILITYLAB                                </td></tr>
	<tr><td>PRIVATE PRACTICE                                       </td></tr>
	<tr><td>FERTILITY CENTERS OF ILLINOIS                          </td></tr>
	<tr><td>THE CHICAGO LIGHTHOUSE                                 </td></tr>
	<tr><td>SCHWAB REHABILITATION HOSPITAL                         </td></tr>
	<tr><td>CANCER TREATMENT CENTERS OF AMERICA                    </td></tr>
</tbody>
</table>



### Right Join Specialties and Hospitals

Make sure to take care of NA's provoked through join while at it


```R
#Right Join Specialties and Hospitals
spec_hosp.df <- right_join(specialities.df, hospitals.df, by="Hospital_Name")
spec_hosp.df$TopDoctors <- ifelse(is.na(spec_hosp.df$TopDoctors), 0, spec_hosp.df$TopDoctors)
spec_hosp.df$Specialty <- ifelse(is.na(spec_hosp.df$Specialty), "", spec_hosp.df$Specialty)
spec_hosp.df %>% filter(City == "BOLINGBROOK")
```


<table>
<thead><tr><th scope=col>Hospital_Name</th><th scope=col>Specialty</th><th scope=col>TopDoctors</th><th scope=col>Address</th><th scope=col>City</th><th scope=col>State</th><th scope=col>County</th><th scope=col>Zip</th><th scope=col>Lat</th><th scope=col>Long</th><th scope=col>⋯</th><th scope=col>US_News_and_World_Report_State_Ranking</th><th scope=col>US_News_ranking_conversion</th><th scope=col>US_News_weight_and_score</th><th scope=col>Magnet_Designation</th><th scope=col>Magnet_rating</th><th scope=col>Magnet_weight_and_score</th><th scope=col>Magnet_Designation_Year</th><th scope=col>Redesignation</th><th scope=col>Info</th><th scope=col>Total_composite_score</th></tr></thead>
<tbody>
	<tr><td>AMITA HEALTH ADVENTIST BOLINGBROOK HOSPITAL</td><td>                                           </td><td>0                                          </td><td>500 REMINGTON BOULEVARD                    </td><td>BOLINGBROOK                                </td><td>IL                                         </td><td>WILL                                       </td><td>60440                                      </td><td>41.67939                                   </td><td>-88.08388                                  </td><td>⋯                                          </td><td>0                                          </td><td>0                                          </td><td>0                                          </td><td>N                                          </td><td>0                                          </td><td>0                                          </td><td>NA                                         </td><td>                                           </td><td>1                                          </td><td>2.8                                        </td></tr>
</tbody>
</table>



## Search Functions

### Filter and Ranked by Specialty


```R
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
```

#### Search by Specialty and Geographic Bounding

Returns specialty-hospital joined dataframe in area


```R
#Search by Specialty and Geographic Bounding
maxlat <- 41.9 #41.881832
maxlon <- -87.6 #-87.623177
minlat <- 41.8 #41.881832
minlon <- -87.7 #-87.623177
```


```R
hospitalsFilteredAndRanked("Neurology", minlon, minlat, maxlon, maxlat)
```


<dl>
	<dt>$total</dt>
		<dd>103</dd>
	<dt>$start</dt>
		<dd>0</dd>
	<dt>$limit</dt>
		<dd>20</dd>
	<dt>$flag</dt>
		<dd>&lt;NA&gt;</dd>
	<dt>$results</dt>
		<dd><table>
<thead><tr><th scope=col>startWith</th><th scope=col>stringDist</th><th scope=col>Hospital_Name</th><th scope=col>Specialty</th><th scope=col>TopDoctors</th><th scope=col>Address</th><th scope=col>City</th><th scope=col>State</th><th scope=col>County</th><th scope=col>Zip</th><th scope=col>⋯</th><th scope=col>US_News_and_World_Report_State_Ranking</th><th scope=col>US_News_ranking_conversion</th><th scope=col>US_News_weight_and_score</th><th scope=col>Magnet_Designation</th><th scope=col>Magnet_rating</th><th scope=col>Magnet_weight_and_score</th><th scope=col>Magnet_Designation_Year</th><th scope=col>Redesignation</th><th scope=col>Info</th><th scope=col>Total_composite_score</th></tr></thead>
<tbody>
	<tr><td> TRUE                                              </td><td> 0                                                 </td><td>NORTHWESTERN MEMORIAL HOSPITAL                     </td><td>Neurology                                          </td><td>6                                                  </td><td>251 E HURON ST                                     </td><td>CHICAGO                                            </td><td>IL                                                 </td><td>COOK                                               </td><td>60611                                              </td><td>⋯                                                  </td><td>1                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>Y                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>2015                                               </td><td>redesignation                                      </td><td>1                                                  </td><td>4.65                                               </td></tr>
	<tr><td> TRUE                                              </td><td> 0                                                 </td><td>RUSH UNIVERSITY MEDICAL CENTER                     </td><td>Neurology                                          </td><td>2                                                  </td><td>1653 WEST CONGRESS PARKWAY                         </td><td>CHICAGO                                            </td><td>IL                                                 </td><td>COOK                                               </td><td>60612                                              </td><td>⋯                                                  </td><td>2                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>Y                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>2016                                               </td><td>redesignation                                      </td><td>1                                                  </td><td>4.65                                               </td></tr>
	<tr><td> TRUE                                              </td><td> 0                                                 </td><td>UNIVERSITY OF ILLINOIS HOSPITAL                    </td><td>Neurology                                          </td><td>1                                                  </td><td>1740 WEST TAYLOR ST SUITE 1400                     </td><td>CHICAGO                                            </td><td>IL                                                 </td><td>COOK                                               </td><td>60612                                              </td><td>⋯                                                  </td><td>0                                                  </td><td>0                                                  </td><td>0.00                                               </td><td>N                                                  </td><td>0                                                  </td><td>0.00                                               </td><td>  NA                                               </td><td>                                                   </td><td>1                                                  </td><td>1.40                                               </td></tr>
	<tr><td> TRUE                                              </td><td>11                                                 </td><td>NORTHWESTERN MEMORIAL HOSPITAL                     </td><td>Neurological Surgery                               </td><td>2                                                  </td><td>251 E HURON ST                                     </td><td>CHICAGO                                            </td><td>IL                                                 </td><td>COOK                                               </td><td>60611                                              </td><td>⋯                                                  </td><td>1                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>Y                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>2015                                               </td><td>redesignation                                      </td><td>1                                                  </td><td>4.65                                               </td></tr>
	<tr><td> TRUE                                              </td><td>11                                                 </td><td>UNIVERSITY OF ILLINOIS HOSPITAL                    </td><td>Neurological Surgery                               </td><td>2                                                  </td><td>1740 WEST TAYLOR ST SUITE 1400                     </td><td>CHICAGO                                            </td><td>IL                                                 </td><td>COOK                                               </td><td>60612                                              </td><td>⋯                                                  </td><td>0                                                  </td><td>0                                                  </td><td>0.00                                               </td><td>N                                                  </td><td>0                                                  </td><td>0.00                                               </td><td>  NA                                               </td><td>                                                   </td><td>1                                                  </td><td>1.40                                               </td></tr>
	<tr><td> TRUE                                              </td><td>11                                                 </td><td>RUSH UNIVERSITY MEDICAL CENTER                     </td><td>Neurological Surgery                               </td><td>1                                                  </td><td>1653 WEST CONGRESS PARKWAY                         </td><td>CHICAGO                                            </td><td>IL                                                 </td><td>COOK                                               </td><td>60612                                              </td><td>⋯                                                  </td><td>2                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>Y                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>2016                                               </td><td>redesignation                                      </td><td>1                                                  </td><td>4.65                                               </td></tr>
	<tr><td> TRUE                                                                 </td><td>11                                                                    </td><td>ANN &amp; ROBERT H LURIE CHILDREN'S HOSPITAL OF CHICAGO               </td><td>Neurological Surgery                                                  </td><td>1                                                                     </td><td><span style=white-space:pre-wrap>225 E CHICAGO AVE, BOX 140    </span></td><td>CHICAGO                                                               </td><td>IL                                                                    </td><td>COOK                                                                  </td><td>60611                                                                 </td><td>⋯                                                                     </td><td>0                                                                     </td><td>0                                                                     </td><td>0.00                                                                  </td><td>N                                                                     </td><td>0                                                                     </td><td>0.00                                                                  </td><td><span style=white-space:pre-wrap>  NA</span>                          </td><td><span style=white-space:pre-wrap>             </span>                 </td><td>1                                                                     </td><td>0.00                                                                  </td></tr>
	<tr><td>FALSE                                              </td><td> 2                                                 </td><td>RUSH UNIVERSITY MEDICAL CENTER                     </td><td>Nephrology                                         </td><td>1                                                  </td><td>1653 WEST CONGRESS PARKWAY                         </td><td>CHICAGO                                            </td><td>IL                                                 </td><td>COOK                                               </td><td>60612                                              </td><td>⋯                                                  </td><td>2                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>Y                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>2016                                               </td><td>redesignation                                      </td><td>1                                                  </td><td>4.65                                               </td></tr>
	<tr><td>FALSE                                              </td><td> 3                                                 </td><td>NORTHWESTERN MEMORIAL HOSPITAL                     </td><td>Urology                                            </td><td>1                                                  </td><td>251 E HURON ST                                     </td><td>CHICAGO                                            </td><td>IL                                                 </td><td>COOK                                               </td><td>60611                                              </td><td>⋯                                                  </td><td>1                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>Y                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>2015                                               </td><td>redesignation                                      </td><td>1                                                  </td><td>4.65                                               </td></tr>
	<tr><td>FALSE                                              </td><td> 3                                                 </td><td>RUSH UNIVERSITY MEDICAL CENTER                     </td><td>Urology                                            </td><td>1                                                  </td><td>1653 WEST CONGRESS PARKWAY                         </td><td>CHICAGO                                            </td><td>IL                                                 </td><td>COOK                                               </td><td>60612                                              </td><td>⋯                                                  </td><td>2                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>Y                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>2016                                               </td><td>redesignation                                      </td><td>1                                                  </td><td>4.65                                               </td></tr>
	<tr><td>FALSE                                              </td><td> 3                                                 </td><td>UNIVERSITY OF ILLINOIS HOSPITAL                    </td><td>Urology                                            </td><td>1                                                  </td><td>1740 WEST TAYLOR ST SUITE 1400                     </td><td>CHICAGO                                            </td><td>IL                                                 </td><td>COOK                                               </td><td>60612                                              </td><td>⋯                                                  </td><td>0                                                  </td><td>0                                                  </td><td>0.00                                               </td><td>N                                                  </td><td>0                                                  </td><td>0.00                                               </td><td>  NA                                               </td><td>                                                   </td><td>1                                                  </td><td>1.40                                               </td></tr>
	<tr><td>FALSE                                              </td><td> 4                                                 </td><td>NORTHWESTERN MEMORIAL HOSPITAL                     </td><td>Hematology                                         </td><td>3                                                  </td><td>251 E HURON ST                                     </td><td>CHICAGO                                            </td><td>IL                                                 </td><td>COOK                                               </td><td>60611                                              </td><td>⋯                                                  </td><td>1                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>Y                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>2015                                               </td><td>redesignation                                      </td><td>1                                                  </td><td>4.65                                               </td></tr>
	<tr><td>FALSE                                              </td><td> 4                                                 </td><td>UNIVERSITY OF ILLINOIS HOSPITAL                    </td><td>Hematology                                         </td><td>2                                                  </td><td>1740 WEST TAYLOR ST SUITE 1400                     </td><td>CHICAGO                                            </td><td>IL                                                 </td><td>COOK                                               </td><td>60612                                              </td><td>⋯                                                  </td><td>0                                                  </td><td>0                                                  </td><td>0.00                                               </td><td>N                                                  </td><td>0                                                  </td><td>0.00                                               </td><td>  NA                                               </td><td>                                                   </td><td>1                                                  </td><td>1.40                                               </td></tr>
	<tr><td>FALSE                                              </td><td> 5                                                 </td><td>NORTHWESTERN MEMORIAL HOSPITAL                     </td><td>Rheumatology                                       </td><td>3                                                  </td><td>251 E HURON ST                                     </td><td>CHICAGO                                            </td><td>IL                                                 </td><td>COOK                                               </td><td>60611                                              </td><td>⋯                                                  </td><td>1                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>Y                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>2015                                               </td><td>redesignation                                      </td><td>1                                                  </td><td>4.65                                               </td></tr>
	<tr><td>FALSE                                              </td><td> 5                                                 </td><td>RUSH UNIVERSITY MEDICAL CENTER                     </td><td>Dermatology                                        </td><td>2                                                  </td><td>1653 WEST CONGRESS PARKWAY                         </td><td>CHICAGO                                            </td><td>IL                                                 </td><td>COOK                                               </td><td>60612                                              </td><td>⋯                                                  </td><td>2                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>Y                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>2016                                               </td><td>redesignation                                      </td><td>1                                                  </td><td>4.65                                               </td></tr>
	<tr><td>FALSE                                              </td><td> 5                                                 </td><td>NORTHWESTERN MEMORIAL HOSPITAL                     </td><td>Neuroradiology                                     </td><td>1                                                  </td><td>251 E HURON ST                                     </td><td>CHICAGO                                            </td><td>IL                                                 </td><td>COOK                                               </td><td>60611                                              </td><td>⋯                                                  </td><td>1                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>Y                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>2015                                               </td><td>redesignation                                      </td><td>1                                                  </td><td>4.65                                               </td></tr>
	<tr><td>FALSE                                              </td><td> 5                                                 </td><td>NORTHWESTERN MEMORIAL HOSPITAL                     </td><td>Dermatology                                        </td><td>1                                                  </td><td>251 E HURON ST                                     </td><td>CHICAGO                                            </td><td>IL                                                 </td><td>COOK                                               </td><td>60611                                              </td><td>⋯                                                  </td><td>1                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>Y                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>2015                                               </td><td>redesignation                                      </td><td>1                                                  </td><td>4.65                                               </td></tr>
	<tr><td>FALSE                                              </td><td> 5                                                 </td><td>RUSH UNIVERSITY MEDICAL CENTER                     </td><td>Rheumatology                                       </td><td>1                                                  </td><td>1653 WEST CONGRESS PARKWAY                         </td><td>CHICAGO                                            </td><td>IL                                                 </td><td>COOK                                               </td><td>60612                                              </td><td>⋯                                                  </td><td>2                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>Y                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>2016                                               </td><td>redesignation                                      </td><td>1                                                  </td><td>4.65                                               </td></tr>
	<tr><td>FALSE                                              </td><td> 5                                                 </td><td>UNIVERSITY OF ILLINOIS HOSPITAL                    </td><td>Neuroradiology                                     </td><td>1                                                  </td><td>1740 WEST TAYLOR ST SUITE 1400                     </td><td>CHICAGO                                            </td><td>IL                                                 </td><td>COOK                                               </td><td>60612                                              </td><td>⋯                                                  </td><td>0                                                  </td><td>0                                                  </td><td>0.00                                               </td><td>N                                                  </td><td>0                                                  </td><td>0.00                                               </td><td>  NA                                               </td><td>                                                   </td><td>1                                                  </td><td>1.40                                               </td></tr>
	<tr><td>FALSE                                                                 </td><td> 5                                                                    </td><td>ANN &amp; ROBERT H LURIE CHILDREN'S HOSPITAL OF CHICAGO               </td><td><span style=white-space:pre-wrap>Dermatology         </span>          </td><td>1                                                                     </td><td><span style=white-space:pre-wrap>225 E CHICAGO AVE, BOX 140    </span></td><td>CHICAGO                                                               </td><td>IL                                                                    </td><td>COOK                                                                  </td><td>60611                                                                 </td><td>⋯                                                                     </td><td>0                                                                     </td><td>0                                                                     </td><td>0.00                                                                  </td><td>N                                                                     </td><td>0                                                                     </td><td>0.00                                                                  </td><td><span style=white-space:pre-wrap>  NA</span>                          </td><td><span style=white-space:pre-wrap>             </span>                 </td><td>1                                                                     </td><td>0.00                                                                  </td></tr>
</tbody>
</table>
</dd>
</dl>



#### Search by Only Geographic Bounding

Returns only hospitals in area provided


```R
#Search by Only Geographic Bounding
maxlat <- 41.9 #41.881832
maxlon <- -87.6 #-87.623177
minlat <- 41.85 #41.881832
minlon <- -87.65 #-87.623177
```


```R
hospitalsFilteredAndRanked("", minlon, minlat, maxlon, maxlat)
```


<dl>
	<dt>$total</dt>
		<dd>2</dd>
	<dt>$start</dt>
		<dd>0</dd>
	<dt>$limit</dt>
		<dd>20</dd>
	<dt>$flag</dt>
		<dd>&lt;NA&gt;</dd>
	<dt>$results</dt>
		<dd><table>
<thead><tr><th scope=col>Hospital_Name</th><th scope=col>Address</th><th scope=col>City</th><th scope=col>State</th><th scope=col>County</th><th scope=col>Zip</th><th scope=col>Lat</th><th scope=col>Long</th><th scope=col>Location</th><th scope=col>Phone</th><th scope=col>⋯</th><th scope=col>US_News_and_World_Report_State_Ranking</th><th scope=col>US_News_ranking_conversion</th><th scope=col>US_News_weight_and_score</th><th scope=col>Magnet_Designation</th><th scope=col>Magnet_rating</th><th scope=col>Magnet_weight_and_score</th><th scope=col>Magnet_Designation_Year</th><th scope=col>Redesignation</th><th scope=col>Info</th><th scope=col>Total_composite_score</th></tr></thead>
<tbody>
	<tr><td>NORTHWESTERN MEMORIAL HOSPITAL                     </td><td>251 E HURON ST                                     </td><td>CHICAGO                                            </td><td>IL                                                 </td><td>COOK                                               </td><td>60611                                              </td><td>41.89500                                           </td><td>-87.62136                                          </td><td>251 E HURON ST CHICAGO, IL                         </td><td>(312) 926-2000                                     </td><td>⋯                                                  </td><td>1                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>Y                                                  </td><td>5                                                  </td><td>0.75                                               </td><td>2015                                               </td><td>redesignation                                      </td><td>1                                                  </td><td>4.65                                               </td></tr>
	<tr><td>ANN &amp; ROBERT H LURIE CHILDREN'S HOSPITAL OF CHICAGO</td><td>225 E CHICAGO AVE, BOX 140                             </td><td>CHICAGO                                                </td><td>IL                                                     </td><td>COOK                                                   </td><td>60611                                                  </td><td>41.89675                                               </td><td>-87.62191                                              </td><td>225 E CHICAGO AVE, BOX 140 CHICAGO, IL                 </td><td>(312) 227-4000                                         </td><td>⋯                                                      </td><td>0                                                      </td><td>0                                                      </td><td>0.00                                                   </td><td>N                                                      </td><td>0                                                      </td><td>0.00                                                   </td><td><span style=white-space:pre-wrap>  NA</span>           </td><td><span style=white-space:pre-wrap>             </span>  </td><td>1                                                      </td><td>0.00                                                   </td></tr>
</tbody>
</table>
</dd>
</dl>



#### Search by limited or bad geographic bounding

Returns all hospitals ranked by composite score


```R
#Search by limited or bad geographic bounding
maxlat <- 47.9 #41.881832
maxlon <- -85.6 #-87.623177
minlat <- 47.85 #41.881832
minlon <- -85.65 #-87.623177
```


```R
hospitalsFilteredAndRanked("", minlon, minlat, maxlon, maxlat)
```


<dl>
	<dt>$total</dt>
		<dd>75</dd>
	<dt>$start</dt>
		<dd>0</dd>
	<dt>$limit</dt>
		<dd>20</dd>
	<dt>$flag</dt>
		<dd>'NO RESULTS FOR AREA'</dd>
	<dt>$results</dt>
		<dd><table>
<thead><tr><th scope=col>Hospital_Name</th><th scope=col>Address</th><th scope=col>City</th><th scope=col>State</th><th scope=col>County</th><th scope=col>Zip</th><th scope=col>Lat</th><th scope=col>Long</th><th scope=col>Location</th><th scope=col>Phone</th><th scope=col>⋯</th><th scope=col>US_News_and_World_Report_State_Ranking</th><th scope=col>US_News_ranking_conversion</th><th scope=col>US_News_weight_and_score</th><th scope=col>Magnet_Designation</th><th scope=col>Magnet_rating</th><th scope=col>Magnet_weight_and_score</th><th scope=col>Magnet_Designation_Year</th><th scope=col>Redesignation</th><th scope=col>Info</th><th scope=col>Total_composite_score</th></tr></thead>
<tbody>
	<tr><td>NORTHSHORE UNIVERSITY HEALTH SYSTEM              </td><td>2650 RIDGE AVE                                   </td><td>EVANSTON                                         </td><td>IL                                               </td><td>COOK                                             </td><td>60201                                            </td><td>42.06530                                         </td><td>-87.68329                                        </td><td>2650 RIDGE AVE EVANSTON, IL                      </td><td>(847) 432-8000                                   </td><td>⋯                                                </td><td> 7                                               </td><td>4                                                </td><td>0.60                                             </td><td>Y                                                </td><td>5                                                </td><td>0.75                                             </td><td>2015                                             </td><td>                                                 </td><td>1                                                </td><td>4.85                                             </td></tr>
	<tr><td>NORTHWESTERN MEMORIAL HOSPITAL                   </td><td>251 E HURON ST                                   </td><td>CHICAGO                                          </td><td>IL                                               </td><td>COOK                                             </td><td>60611                                            </td><td>41.89500                                         </td><td>-87.62136                                        </td><td>251 E HURON ST CHICAGO, IL                       </td><td>(312) 926-2000                                   </td><td>⋯                                                </td><td> 1                                               </td><td>5                                                </td><td>0.75                                             </td><td>Y                                                </td><td>5                                                </td><td>0.75                                             </td><td>2015                                             </td><td>redesignation                                    </td><td>1                                                </td><td>4.65                                             </td></tr>
	<tr><td>RUSH UNIVERSITY MEDICAL CENTER                   </td><td>1653 WEST CONGRESS PARKWAY                       </td><td>CHICAGO                                          </td><td>IL                                               </td><td>COOK                                             </td><td>60612                                            </td><td>41.87517                                         </td><td>-87.66851                                        </td><td>1653 WEST CONGRESS PARKWAY CHICAGO, IL           </td><td>(312) 942-5000                                   </td><td>⋯                                                </td><td> 2                                               </td><td>5                                                </td><td>0.75                                             </td><td>Y                                                </td><td>5                                                </td><td>0.75                                             </td><td>2016                                             </td><td>redesignation                                    </td><td>1                                                </td><td>4.65                                             </td></tr>
	<tr><td>AMITA HEALTH ADVENTIST MEDICAL CENTER, HINSDALE  </td><td>120 NORTH OAK ST                                 </td><td>HINSDALE                                         </td><td>IL                                               </td><td>DUPAGE                                           </td><td>60521                                            </td><td>41.80533                                         </td><td>-87.92006                                        </td><td>120 NORTH OAK ST HINSDALE, IL                    </td><td>(630) 856-9000                                   </td><td>⋯                                                </td><td>16                                               </td><td>2                                                </td><td>0.30                                             </td><td>Y                                                </td><td>5                                                </td><td>0.75                                             </td><td>2015                                             </td><td>                                                 </td><td>1                                                </td><td>4.55                                             </td></tr>
	<tr><td>NORTHWESTERN DELNOR COMMUNITY HOSPITAL           </td><td>300 RANDALL RD                                   </td><td>GENEVA                                           </td><td>IL                                               </td><td>KANE                                             </td><td>60134                                            </td><td>41.88634                                         </td><td>-88.34041                                        </td><td>300 RANDALL RD GENEVA, IL                        </td><td>(630) 208-3000                                   </td><td>⋯                                                </td><td>16                                               </td><td>2                                                </td><td>0.30                                             </td><td>Y                                                </td><td>5                                                </td><td>0.75                                             </td><td>2018                                             </td><td>redesignation                                    </td><td>1                                                </td><td>4.55                                             </td></tr>
	<tr><td>ADVOCATE SHERMAN HOSPITAL                        </td><td>1425 NORTH RANDALL ROAD                          </td><td>ELGIN                                            </td><td>IL                                               </td><td>KANE                                             </td><td>60123                                            </td><td>42.07022                                         </td><td>-88.33147                                        </td><td>1425 NORTH RANDALL ROAD ELGIN, IL                </td><td>(847) 742-9800                                   </td><td>⋯                                                </td><td>10                                               </td><td>4                                                </td><td>0.60                                             </td><td>Y                                                </td><td>5                                                </td><td>0.75                                             </td><td>2018                                             </td><td>redesignation                                    </td><td>1                                                </td><td>4.50                                             </td></tr>
	<tr><td>NORTHWESTERN CENTRAL DUPAGE HOSPITAL             </td><td>25 NORTH WINFIELD ROAD                           </td><td>WINFIELD                                         </td><td>IL                                               </td><td>DUPAGE                                           </td><td>60190                                            </td><td>41.87376                                         </td><td>-88.15810                                        </td><td>25 NORTH WINFIELD ROAD WINFIELD, IL              </td><td>(630) 682-1600                                   </td><td>⋯                                                </td><td> 7                                               </td><td>4                                                </td><td>0.60                                             </td><td>Y                                                </td><td>5                                                </td><td>0.75                                             </td><td>2015                                             </td><td>redesignation                                    </td><td>1                                                </td><td>4.50                                             </td></tr>
	<tr><td>EDWARD HOSPITAL                                  </td><td>801 SOUTH WASHINGTON                             </td><td>NAPERVILLE                                       </td><td>IL                                               </td><td>DUPAGE                                           </td><td>60540                                            </td><td>41.76143                                         </td><td>-88.14924                                        </td><td>801 SOUTH WASHINGTON NAPERVILLE, IL              </td><td>(630) 527-3000                                   </td><td>⋯                                                </td><td>12                                               </td><td>3                                                </td><td>0.45                                             </td><td>Y                                                </td><td>5                                                </td><td>0.75                                             </td><td>2014                                             </td><td>redesignation                                    </td><td>1                                                </td><td>4.35                                             </td></tr>
	<tr><td>UNIVERSITY OF CHICAGO MEDICAL CENTER             </td><td>5841 SOUTH MARYLAND                              </td><td>CHICAGO                                          </td><td>IL                                               </td><td>COOK                                             </td><td>60637                                            </td><td>41.78796                                         </td><td>-87.60492                                        </td><td>5841 SOUTH MARYLAND CHICAGO, IL                  </td><td>(773) 702-1000                                   </td><td>⋯                                                </td><td> 4                                               </td><td>5                                                </td><td>0.75                                             </td><td>Y                                                </td><td>5                                                </td><td>0.75                                             </td><td>2018                                             </td><td>                                                 </td><td>1                                                </td><td>4.30                                             </td></tr>
	<tr><td>ADVOCATE CONDELL MEDICAL CENTER                  </td><td>801 S MILWAUKEE AVE                              </td><td>LIBERTYVILLE                                     </td><td>IL                                               </td><td>LAKE                                             </td><td>60048                                            </td><td>42.27456                                         </td><td>-87.95165                                        </td><td>801 S MILWAUKEE AVE LIBERTYVILLE, IL             </td><td>(847) 362-2900                                   </td><td>⋯                                                </td><td>13                                               </td><td>3                                                </td><td>0.45                                             </td><td>Y                                                </td><td>5                                                </td><td>0.75                                             </td><td>2017                                             </td><td>                                                 </td><td>1                                                </td><td>4.00                                             </td></tr>
	<tr><td>LOYOLA UNIVERSITY MEDICAL CENTER                 </td><td>2160 S 1ST AVENUE                                </td><td>MAYWOOD                                          </td><td>IL                                               </td><td>COOK                                             </td><td>60153                                            </td><td>41.85873                                         </td><td>-87.83321                                        </td><td>2160 S 1ST AVENUE MAYWOOD, IL                    </td><td>(708) 216-9000                                   </td><td>⋯                                                </td><td> 3                                               </td><td>5                                                </td><td>0.75                                             </td><td>Y                                                </td><td>5                                                </td><td>0.75                                             </td><td>2014                                             </td><td>redesignation                                    </td><td>1                                                </td><td>3.95                                             </td></tr>
	<tr><td>ELMHURST MEMORIAL HOSPITAL                       </td><td>155 EAST BRUSH HILL ROAD                         </td><td>ELMHURST                                         </td><td>IL                                               </td><td>DUPAGE                                           </td><td>60126                                            </td><td>41.86168                                         </td><td>-87.93430                                        </td><td>155 EAST BRUSH HILL ROAD ELMHURST, IL            </td><td>(331) 221-0130                                   </td><td>⋯                                                </td><td> 0                                               </td><td>0                                                </td><td>0.00                                             </td><td>Y                                                </td><td>5                                                </td><td>0.75                                             </td><td>2015                                             </td><td>                                                 </td><td>1                                                </td><td>3.90                                             </td></tr>
	<tr><td>RUSH OAK PARK HOSPITAL                           </td><td>520 S MAPLE AVE                                  </td><td>OAK PARK                                         </td><td>IL                                               </td><td>COOK                                             </td><td>60304                                            </td><td>41.87903                                         </td><td>-87.80382                                        </td><td>520 S MAPLE AVE OAK PARK, IL                     </td><td>(708) 383-9300                                   </td><td>⋯                                                </td><td> 0                                               </td><td>0                                                </td><td>0.00                                             </td><td>Y                                                </td><td>5                                                </td><td>0.75                                             </td><td>2016                                             </td><td>                                                 </td><td>1                                                </td><td>3.90                                             </td></tr>
	<tr><td>NORTHWEST COMMUNITY HOSPITAL                     </td><td>800 W CENTRAL ROAD                               </td><td>ARLINGTON HEIGHTS                                </td><td>IL                                               </td><td>COOK                                             </td><td>60005                                            </td><td>42.06660                                         </td><td>-87.99295                                        </td><td>800 W CENTRAL ROAD ARLINGTON HEIGHTS, IL         </td><td>(847) 618-1000                                   </td><td>⋯                                                </td><td>19                                               </td><td>2                                                </td><td>0.30                                             </td><td>Y                                                </td><td>5                                                </td><td>0.75                                             </td><td>2015                                             </td><td>redesignation                                    </td><td>1                                                </td><td>3.85                                             </td></tr>
	<tr><td>NORTHWESTERN LAKE FOREST HOSPITAL                </td><td>1000 N WESTMORELAND ROAD                         </td><td>LAKE FOREST                                      </td><td>IL                                               </td><td>LAKE                                             </td><td>60045                                            </td><td>42.25913                                         </td><td>-87.86633                                        </td><td>1000 N WESTMORELAND ROAD LAKE FOREST, IL         </td><td>(847) 234-5600                                   </td><td>⋯                                                </td><td>16                                               </td><td>2                                                </td><td>0.30                                             </td><td>Y                                                </td><td>5                                                </td><td>0.75                                             </td><td>2015                                             </td><td>redesignation                                    </td><td>1                                                </td><td>3.85                                             </td></tr>
	<tr><td>ADVOCATE GOOD SAMARITAN HOSPITAL                 </td><td>3815 HIGHLAND AVENUE                             </td><td>DOWNERS GROVE                                    </td><td>IL                                               </td><td>DUPAGE                                           </td><td>60515                                            </td><td>41.81914                                         </td><td>-88.01022                                        </td><td>3815 HIGHLAND AVENUE DOWNERS GROVE, IL           </td><td>(630) 275-5900                                   </td><td>⋯                                                </td><td> 9                                               </td><td>4                                                </td><td>0.60                                             </td><td>Y                                                </td><td>5                                                </td><td>0.75                                             </td><td>2018                                             </td><td>redesignation                                    </td><td>1                                                </td><td>3.80                                             </td></tr>
	<tr><td>ADVOCATE LUTHERAN GENERAL HOSPITAL               </td><td>1775 DEMPSTER ST                                 </td><td>PARK RIDGE                                       </td><td>IL                                               </td><td>COOK                                             </td><td>60068                                            </td><td>42.03975                                         </td><td>-87.84815                                        </td><td>1775 DEMPSTER ST PARK RIDGE, IL                  </td><td>(847) 723-2210                                   </td><td>⋯                                                </td><td>10                                               </td><td>4                                                </td><td>0.60                                             </td><td>Y                                                </td><td>5                                                </td><td>0.75                                             </td><td>2014                                             </td><td>redesignation                                    </td><td>1                                                </td><td>3.80                                             </td></tr>
	<tr><td>NORTHWESTERN MEDICINE MCHENRY HOSPITAL           </td><td>4201 MEDICAL CENTER DRIVE                        </td><td>MCHENRY                                          </td><td>IL                                               </td><td>MCHENRY                                          </td><td>60050                                            </td><td>42.31890                                         </td><td>-88.27979                                        </td><td>4201 MEDICAL CENTER DRIVE MCHENRY, IL            </td><td>(815) 344-5000                                   </td><td>⋯                                                </td><td>19                                               </td><td>2                                                </td><td>0.30                                             </td><td>N                                                </td><td>0                                                </td><td>0.00                                             </td><td>  NA                                             </td><td>                                                 </td><td>1                                                </td><td>3.80                                             </td></tr>
	<tr><td><span style=white-space:pre-wrap>ADVOCATE CHRIST HOSPITAL &amp; MEDICAL CENTER        </span></td><td><span style=white-space:pre-wrap>4440 W 95TH STREET        </span>                           </td><td><span style=white-space:pre-wrap>OAK LAWN         </span>                                    </td><td>IL                                                                                           </td><td><span style=white-space:pre-wrap>COOK   </span>                                              </td><td>60453                                                                                        </td><td>41.72032                                                                                     </td><td>-87.73236                                                                                    </td><td><span style=white-space:pre-wrap>4440 W 95TH STREET OAK LAWN, IL         </span>             </td><td>(708) 684-8000                                                                               </td><td>⋯                                                                                            </td><td> 4                                                                                           </td><td>5                                                                                            </td><td>0.75                                                                                         </td><td>Y                                                                                            </td><td>5                                                                                            </td><td>0.75                                                                                         </td><td>2014                                                                                         </td><td>redesignation                                                                                </td><td>1                                                                                            </td><td>3.60                                                                                         </td></tr>
	<tr><td>PRESENCE SAINTS MARY AND ELIZABETH MEDICAL CENTER</td><td>2233 W DIVISION ST                               </td><td>CHICAGO                                          </td><td>IL                                               </td><td>COOK                                             </td><td>60622                                            </td><td>41.90310                                         </td><td>-87.68321                                        </td><td>2233 W DIVISION ST CHICAGO, IL                   </td><td>(312) 770-2000                                   </td><td>⋯                                                </td><td> 0                                               </td><td>0                                                </td><td>0.00                                             </td><td>Y                                                </td><td>5                                                </td><td>0.75                                             </td><td>2018                                             </td><td>                                                 </td><td>1                                                </td><td>3.55                                             </td></tr>
</tbody>
</table>
</dd>
</dl>



### Filter by Name


```R
#Filter by Name
result.df <- hospitalsFilteredAndRanked("Neurology")$results
hospitalByName <- function(results, name){
    return(results[which(results$Hospital_Name == name), ])
}
hospitalByName(result.df, "UNIVERSITY OF ILLINOIS HOSPITAL")
```


<table>
<thead><tr><th></th><th scope=col>startWith</th><th scope=col>stringDist</th><th scope=col>Hospital_Name</th><th scope=col>Specialty</th><th scope=col>TopDoctors</th><th scope=col>Address</th><th scope=col>City</th><th scope=col>State</th><th scope=col>County</th><th scope=col>Zip</th><th scope=col>⋯</th><th scope=col>US_News_and_World_Report_State_Ranking</th><th scope=col>US_News_ranking_conversion</th><th scope=col>US_News_weight_and_score</th><th scope=col>Magnet_Designation</th><th scope=col>Magnet_rating</th><th scope=col>Magnet_weight_and_score</th><th scope=col>Magnet_Designation_Year</th><th scope=col>Redesignation</th><th scope=col>Info</th><th scope=col>Total_composite_score</th></tr></thead>
<tbody>
	<tr><th scope=row>6</th><td>TRUE                           </td><td> 0                             </td><td>UNIVERSITY OF ILLINOIS HOSPITAL</td><td>Neurology                      </td><td>1                              </td><td>1740 WEST TAYLOR ST SUITE 1400 </td><td>CHICAGO                        </td><td>IL                             </td><td>COOK                           </td><td>60612                          </td><td>⋯                              </td><td>0                              </td><td>0                              </td><td>0                              </td><td>N                              </td><td>0                              </td><td>0                              </td><td>NA                             </td><td>                               </td><td>1                              </td><td>1.4                            </td></tr>
	<tr><th scope=row>9</th><td>TRUE                           </td><td>11                             </td><td>UNIVERSITY OF ILLINOIS HOSPITAL</td><td>Neurological Surgery           </td><td>2                              </td><td>1740 WEST TAYLOR ST SUITE 1400 </td><td>CHICAGO                        </td><td>IL                             </td><td>COOK                           </td><td>60612                          </td><td>⋯                              </td><td>0                              </td><td>0                              </td><td>0                              </td><td>N                              </td><td>0                              </td><td>0                              </td><td>NA                             </td><td>                               </td><td>1                              </td><td>1.4                            </td></tr>
</tbody>
</table>



## Utility Functions

### Get Min-Max latitude longitudes


```R
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
```


<dl>
	<dt>$minlon</dt>
		<dd>-88.72226</dd>
	<dt>$minlat</dt>
		<dd>41.368907</dd>
	<dt>$maxlon</dt>
		<dd>-87.56725</dd>
	<dt>$maxlat</dt>
		<dd>42.44897</dd>
</dl>




```R

```
