library(shinydashboard)
library(shiny)
library(tidyverse)
library(sf)
library(leaflet)
library(htmltools)
library(scales)

nearli_5yr_sales <- readRDS("../data/nearli_5yr_sales.rds")

sales <- nearli_5yr_sales %>% st_drop_geometry()

li <- sales %>% distinct(li_addr) %>% pull(li_addr) %>% as.character()

groups_df <- sales %>% distinct(group) %>% pull(group) %>% as.character()

nearli_5yr_sales$label <- 
  paste0("<b>Sale Date:</b> ", nearli_5yr_sales$ownerdate, "<br>",
         "<b>Sale Amount:</b> ", str_c('$', nearli_5yr_sales$amount), "<br>",
         "<b>Year Built:</b> ", nearli_5yr_sales$year_built, "<br>", 
         "<b>Land Area:</b> ", nearli_5yr_sales$land_area, "<br>",
         "<b>Square Footage:</b> ", nearli_5yr_sales$square_footage, "<br>",
         "<b>Distance to Nearest Affordable Housing:</b> ", str_c(round(nearli_5yr_sales$dist, 3)), ' miles') %>%
  lapply(htmltools::HTML)

groupCol <- colorFactor(palette = "Accent", nearli_5yr_sales$group)

