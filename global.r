library(shinydashboard)
library(shinycssloaders)
library(shinyWidgets)
library(leaflet)
library(plotly)
library(timevis)
library(tidyverse)

## read reference from external text file ####
mybib <- readr::read_file("datasets/bib.txt")

## read files ####
cafo <- readxl::read_xlsx("datasets/cafo.xlsx", sheet = "Treatment-Outcome data")
cafo2 <- readxl::read_xlsx("datasets/cafo2.xlsx") %>% 
  select(Refid, `Author(s)`, Year, Country, State, City, lng, lat, Title, `Journal Name`)
dataset <- readr::read_csv("datasets/CAFO_All_data_new_Aug21.csv")
rob <- readxl::read_xlsx("datasets/cafo.xlsx", sheet = "Risk of bias")

## map data ####
cafoo <- cafo %>% 
  mutate(Country = ifelse(Refid %in% c(648, 690, 743, 288), "Germany",
                          ifelse(Refid %in% c(81, 203), "Netherlands", "United States"))) %>% 
  # mutate(`State` = ifelse(Refid %in% c(64, 690, 743, 288), NA,
  #                         ifelse(Refid %in% c(81, 203), NA, "North Carolina"))) %>% 
  mutate(long = ifelse(Country == "Germany", 13.404954,
                       ifelse(Country == "Netherlands", 4.899431, -78.644257))) %>% 
  mutate(lat = ifelse(Country == "Germany", 52.520008,
                      ifelse(Country == "Netherlands", 52.379189, 35.787743))) %>% 
  distinct(Refid, .keep_all = TRUE) %>% 
  group_by(Country, long, lat) %>% 
  summarise(`Number of Studies` = n())

## timeline data ####
## add two columns: author(paperInfo) & published year(paperYear) 
dataset$paperInfo <- rep("", nrow(dataset))
dataset$paperYear <- rep(NA, nrow(dataset))
idx_9 <- which(dataset$Refid == 9)
dataset$paperInfo[idx_9] <- "Schinasi et al. 2014"
dataset$paperYear[idx_9] <- 2014
idx_81 <- which(dataset$Refid == 81)
dataset$paperInfo[idx_81] <- "Smit et al. 2013"
dataset$paperYear[idx_81] <- 2013
idx_203 <- which(dataset$Refid == 203)
dataset$paperInfo[idx_203] <- "Smit et al. 2012"
dataset$paperYear[idx_203] <- 2012
idx_288 <- which(dataset$Refid == 288)
dataset$paperInfo[idx_288] <- "Schulze et al. 2011"
dataset$paperYear[idx_288] <- 2011
idx_327 <- which(dataset$Refid == 327)
dataset$paperInfo[idx_327] <- "Schinasi et al. 2011"
dataset$paperYear[idx_327] <- 2011
idx_452 <- which(dataset$Refid == 452)
dataset$paperInfo[idx_452] <- "Horton et al. 2009"
dataset$paperYear[idx_452] <- 2009
idx_648 <- which(dataset$Refid == 648)
dataset$paperInfo[idx_648] <- "Radon et al. 2007"
dataset$paperYear[idx_648] <- 2007
idx_690 <- which(dataset$Refid == 690)
dataset$paperInfo[idx_690] <- "Hoopmann et al. 2006"
dataset$paperYear[idx_690] <- 2006
idx_713 <- which(dataset$Refid == 713)
dataset$paperInfo[idx_713] <- "Mirabelli et al. 2006"
dataset$paperYear[idx_713] <- 2006
idx_743 <- which(dataset$Refid == 743)
dataset$paperInfo[idx_743] <- "Radon et al. 2005"
dataset$paperYear[idx_743] <- 2005
idx_775 <- which(dataset$Refid == 775)
dataset$paperInfo[idx_775] <- "Schiffman et al. 2005"
dataset$paperYear[idx_775] <- 2005
idx_795 <- which(dataset$Refid == 795)
dataset$paperInfo[idx_795] <- "Avery et al. 2004"
dataset$paperYear[idx_795] <- 2004
idx_1187 <- which(dataset$Refid == 1187)
dataset$paperInfo[idx_1187] <- "Schiffman et al. 1995"
dataset$paperYear[idx_1187] <- 1995
idx_1552 <- which(dataset$Refid == 1552)
dataset$paperInfo[idx_1552] <- "Wing et al. 2013"
dataset$paperYear[idx_1552] <- 2013
idx_2417 <- which(dataset$Refid == 2417)
dataset$paperInfo[idx_2417] <- "Bullers et al. 2005"
dataset$paperYear[idx_2417] <- 2005
idx_4000 <- which(dataset$Refid == 4000)
dataset$paperInfo[idx_4000] <- "Feingold et al. 2012"
dataset$paperYear[idx_4000] <- 2012 

## summary - ROB ####
r2 <- rob %>%
  select(Refid, ROB_confounding_paige,
         ROB_selection_paige, ROB_measurementExposure_paige,
         ROB_missingData_paige,  ROB_measureOutcome_paige,
         ROB_SelectionofReportedResult_paige, ROB_overall_paige) %>% 
  setNames(c("Refid", "Confounding", "Selection", "Measurement of Exposure",
             "Missing Data", "Measurement of Outcome", "Selection of Report", "Overall"))
r22 <- r2 %>% gather(key = `Type of Bias`, value = Bias, Confounding:Overall) %>% 
  mutate(Bias = forcats::fct_relevel(Bias, "Critical","Serious", "Moderate", "Low", "Uncertain"),
         `Type of Bias` = forcats::fct_relevel(`Type of Bias`, "Selection of Report",
                                               "Selection", "Missing Data", "Measurement of Outcome",
                                               "Measurement of Exposure", "Confounding", "Overall")) %>% 
  replace_na(list(Bias = "Uncertain"))
color_table <- tibble(
  Bias = c("Critical", "Serious", "Moderate", "Low", "Uncertain"),
  Color = c(rev(RColorBrewer::brewer.pal(4, "Reds")), "#bdbdbd")
)
