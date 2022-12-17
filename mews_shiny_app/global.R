library(shinydashboard)
library(shiny)
library(tidyverse)
library(sf)
library(leaflet)
library(htmltools)
library(scales)

nearli_5yr_sales <- readRDS("../data/nearli_5yr_sales.rds")


sales <- nearli_5yr_sales %>% st_drop_geometry() %>% 
  select(APN = apn,
            `Sale Amount` = amount_dol,
            `Predicted Amount` = predicted_amount_dol,
            `Difference` = dif_pred_actual_dol,
            `Year Built` = year_built,
            `Land Area` = land_area,
            `Square Footage` = square_footage,
            `Exterior Material` = exterior_wall,
            `Num of Stories` = story_height,
            `Bedrooms` = number_of_beds,
            `Full Baths` = number_of_baths,
            group,
            li_addr,
            `Distance to Development` = dist)

li <- sales %>% distinct(li_addr) %>% pull(li_addr) %>% as.character()

groups_df <- sales %>% distinct(group) %>% pull(group) %>% as.character()

nearli_5yr_sales$label <- 
  paste0("<b>Sale Date:</b> ", nearli_5yr_sales$ownerdate, "<br>",
         "<b>Sale Amount:</b> ", nearli_5yr_sales$amount_dol, "<br>",
         "<b>Year Built:</b> ", nearli_5yr_sales$year_built, "<br>", 
         "<b>Land Area:</b> ", nearli_5yr_sales$land_area, "<br>",
         "<b>Square Footage:</b> ", nearli_5yr_sales$square_footage, "<br>",
         "<b>Distance to Nearest Affordable Housing:</b> ", str_c(round(nearli_5yr_sales$dist, 3)), ' miles') %>%
  lapply(htmltools::HTML)

groupCol <- colorFactor(palette = "Accent", nearli_5yr_sales$group)

li_dev_map <- readRDS("../data/li_dev_map.rds")

li_dev_map$label <- 
  paste0("<b>Development address:</b> ", li_dev_map$li_addr, "<br>",
         "<b>Year came into service:</b> ", li_dev_map$li_start_yr, "<br>",
         "<b>Total units:</b> ", li_dev_map$li_total_units, "<br>", 
         "<b>Total low-income units:</b> ", li_dev_map$li_units) %>%
  lapply(htmltools::HTML)

map_icons <- awesomeIcons(
  icon = 'building',
  iconColor = 'white',
  library = 'fa'
)

options(scipen = 999)
