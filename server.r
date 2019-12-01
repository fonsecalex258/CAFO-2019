shinyServer(function(input, output){ 
  ## descriptive plots ####
  ## * switch text ####
  output$eda_text <- renderUI({
    switch(
      input$eda_btn,
      "sp" = p("Most articles were published in North America and some in Europe."),
      "ts" = p(""),
      "coef" = p("The following table shows the number of reported outcomes (i.e lower and upper respiratory tracts, MRSA etc) 
                    and the type of measure of effect for each of the 16 studies.")
    )
  })
  ## * switch plot ####
  output$eda_plot <- renderUI({
    switch(
      input$eda_btn,
      "sp" = fluidRow(
        column(width = 6, leafletOutput("map") %>% withSpinner()),
        column(width = 6, plotlyOutput("geobar") %>% withSpinner())),
      "ts" = timevisOutput("timeline"),
      "coef" = plotlyOutput("measure") %>% withSpinner()
    )
  })
  ## * geographic distribution ####
  output$map <- renderLeaflet({
    leaflet(cafoo) %>% 
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)) %>%  
      setView(-40.679728, 34.738366, zoom = 2) %>%  ## Set/fix the view of the map 
      addCircleMarkers(lng = cafoo$long, lat = cafoo$lat,
                       radius = log(cafoo$`Number of Studies`)*8,
                       popup = ~paste("Country:", cafoo$Country, "<br>",
                                      "Number of Studies:", cafoo$`Number of Studies`))
  })
  output$geobar <- renderPlotly({
    gg <- cafo2 %>% distinct() %>%
      group_by(Country) %>% summarise(Count = n()) %>% 
      mutate(Country = forcats::fct_reorder(factor(Country), Count)) %>%
      ggplot(aes(x = Country, y = Count)) + geom_bar(stat = "identity") 
    ggplotly(gg) 
  })
  ## * timeline ####
  output$timeline <- renderTimevis({
    ## Only select authors and year information columns
    timedata <- dataset %>% select(paperInfo, paperYear) %>% distinct() %>% 
      ## Extract only author names from paperInfo column
      ## Extract string comes before the period 
      mutate(Author = sub("\\..*", "", paperInfo))
    # timedata$paperYear[8] <- 2006  Fixed missing data on the original dataset
    timedata2 <- timedata %>% select(paperYear, Author)
    ## Insert into a dataframe 
    datt <- data.frame(
      ## make it reactive
      id = 1:nrow(timedata2),   
      content = timedata2$Author,
      start = timedata2$paperYear,
      end = NA
    )
    timevis(datt)
  })
  ## * effect measure ####
  output$measure <- renderPlotly({
    ## Rearrange the studies by increasing order
    dataset2 <- dataset %>% 
      mutate(paperInfo = factor(paperInfo, levels=names(sort(table(paperInfo), increasing=TRUE))),
             Effect.measure = recode(Effect.measure,
                                     beta = "Beta", `beta p value` =  "Beta p Value",
                                     OR = "Odds Ratio", `OR p value` = "Odds Ratio p Value",
                                     PR = "Prevalence Ratio"))
    ##Recode some of the variables
    gg <- dataset2 %>% ggplot(aes(x = paperInfo)) +
      geom_bar(aes(fill = Effect.measure)) + coord_flip() + 
      scale_fill_brewer(palette = "Set2") +
      labs(x = "", fill = "Effect Measure") + 
      ylab("Number of Reported Outcomes")
    ggplotly(gg)
  })
  
  ## summary ####
  output$bias <- renderPlotly({
    gg <- r22 %>% ggplot(aes(x = `Type of Bias`, fill = Bias)) + 
      geom_bar(position = "fill") + coord_flip() + 
      scale_fill_manual(values = color_table$Color) + 
      scale_x_discrete(labels = rev(c("Overall", "Confounding", "Measurement of Exposure", 
                                  "Measurement of Outcome", "Missing Data", "Selection",
                                  "Selection of Report"))) +
      ylab("Ratio")
    ggplotly(gg)
  })
})