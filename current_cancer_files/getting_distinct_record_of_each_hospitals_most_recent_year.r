##Deduplicating the hospitals to get the hospitals' record from the most recent year it appeared in if it only appeared in one##


pacman::p_boot(load=TRUE)
pacman::p_load(tidyverse)
pacman::p_load(lubridate)

import_path <- "~/GitHub/best-chicago-hospitals-website/docs/2020-02-05_for_datatables_surgeries_disaggregated_with_nci_commas_fixed.csv"

surgeries_data <- read.csv(import_path)

View(surgeries_data)

glimpse(surgeries_data)

surgeries_data_sorted <- surgeries_data %>%
  arrange(Hospital.Name, desc(Year))

surgeries_data_sorted %>% select(Hospital.Name) %>% summary()

surgeries_data_sorted %>% count(Hospital.Name) %>% arrange(desc(n))

surgeries_data_sorted %>% count(Hospital.Name, Year) %>% arrange(desc(n))


surgeries_data_one_per_hospital <- surgeries_data_sorted %>% 
  distinct(Hospital.Name, .keep_all = TRUE)# %>% count(Hospital.Name, Year) - works perfectly

today <- as.character(today())

export_path <- paste("~/GitHub/best-chicago-hospitals-website/docs/", today, 
                     "_for_datatables_surgeries_most_recent_year_with_nci.csv", sep = "")

write.csv(surgeries_data_one_per_hospital, export_path)