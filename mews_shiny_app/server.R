
shinyServer(function(input, output, session) {
  filtered_sales <- reactive({
    if (input$li_addr == 'All') {
      if (input$ddlGroups == 'All') {
        return(nearli_5yr_sales)
      }
      else {
        return(nearli_5yr_sales %>%
                 filter(group == input$ddlGroups))
      }
    }
    else{
      if (input$ddlGroups == 'All') {
        return(nearli_5yr_sales %>%
                 filter(li_addr == input$li_addr))
      }
      else {
        return(sales %>%
                 filter(group == input$ddlGroups,
                        li_addr == input$li_addr))
      }
    }
  })
  
  simplified_sales <- reactive({
    if (input$li_addr == 'All') {
      if (input$ddlGroups == 'All') {
        return(sales %>% 
                 rename(`Sale Group` = group,
                        `Development Address` = li_addr))
      }
      else {
        return(sales %>%
                 filter(group == input$ddlGroups) %>% 
                 rename(`Sale Group` = group,
                        `Development Address` = li_addr))
      }
    }
    else{
      if (input$ddlGroups == 'All') {
        return(sales %>%
                 filter(li_addr == input$li_addr) %>% 
                 rename(`Sale Group` = group,
                        `Development Address` = li_addr)) 
      }
      else {
        return(sales %>%
                 filter(group == input$ddlGroups,
                        li_addr == input$li_addr) %>% 
                 rename(`Sale Group` = group,
                        `Development Address` = li_addr))
      }
    }
  })
  
  r_zoom <- reactive({
    if (input$li_addr == 'All') {
      return(10)
    }
    
    else {
      return(13)
    }
  })
  
  
  output$filteredSales <- renderDataTable(
    simplified_sales(),
    options = list(scrollX = TRUE)
  )
  
  output$map_distance <- renderLeaflet({

    leaflet() %>%
      addProviderTiles(providers$CartoDB.Voyager) %>%
      setView(lng = median(filtered_sales()$lon),
              lat = median(filtered_sales()$lat),
              zoom = r_zoom()) %>%
      setMaxBounds(lng1 = max(filtered_sales()$lon) + 1,
                   lat1 = max(filtered_sales()$lat) + 1,
                   lng2 = min(filtered_sales()$lon) - 1,
                   lat2 = min(filtered_sales()$lat) - 1) %>%
      addCircleMarkers(data =  filtered_sales(),
                       radius = 1.5,
                       color = "white",
                       weight = .5,
                       fillColor = ~groupCol(group),
                       fillOpacity = 2,
                       label = ~label) %>%
      addLegend('bottomright',
                pal = groupCol,
                values = filtered_sales()$group,
                title = 'Home Sales Groups',
                opacity = 1)

  })
})
