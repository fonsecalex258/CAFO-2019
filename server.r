shinyServer(function(input, output){ 
  ## descriptive plots ####
  ## * switch text ####
  output$eda_text <- renderUI({
    switch(
      input$eda_btn,
      "sp" = p("Most articles were published in North America and some in Europe."),
      "ts" = p("This plot shows the date of publication of studies included in the review"),
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
      "coef" = plotlyOutput("measure_all") %>% withSpinner()
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
      ggplot(aes(x = Country, y = Count)) + 
      geom_bar(aes(fill = Country), stat = "identity") +
      scale_fill_brewer(palette = "Set2")
    ggplotly(gg, tooltip = c("x", "y")) %>% layout(showlegend = FALSE)
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
  ## * outcome ####
  output$measure_all <- renderPlotly({
    gg <- dataset %>% ggplot(aes(x = paperInfo)) +
      geom_bar(aes(fill = Categorized.class)) + coord_flip() + 
      scale_fill_brewer(palette = "Set3") +
      labs(x = "", fill = "Health Outcome Group") +
      xlab("Study") +
      ylab("Number of Reported Outcomes") + 
      theme(plot.background = element_rect(fill = "#BFD5E3"),
            panel.background = element_rect(fill = "white"),
            axis.line.x = element_line(color = "grey"))
    ggplotly(gg)
  })
  
  ## forest fitlers ####
  selected_class <- reactive({
    case_when(
      grepl("low_rsp", input$sidebar) ~ "Lower Respiratory",
      grepl("up_rsp", input$sidebar) ~ "Upper Respiratory",
      TRUE ~ "Other"
    )
  }) 
  selected_id <- reactive({
    dataset %>% filter(Categorized.class==selected_class()) %>% 
      pull(Refid) %>% unique()
  })
  ## * exposure variable input ####
  output$expo_var_1 <- renderUI({
    choices <- dataset %>%
      filter(Categorized.class == selected_class()) %>%
      pull(Expo.Very.board) %>% unique() %>% sort() 
    selectInput("expo_b",
                "Broad grouped exposure variable",
                choices = choices,
                selected = choices[1])
  })
  output$expo_var_2 <- renderUI({
    choices <- dataset %>%
      filter(Categorized.class == selected_class(), 
             Expo.Very.board %in% input$expo_b) %>%
      pull(Expo.BitNarrow) %>% unique() %>% sort() 
    selectInput("expo_n",
                "Narrow grouped exposure variable(s)",
                choices = choices,
                multiple = T,
                selected = choices[1])
  })
  ## * effect measure input ####
  output$measure <- renderUI({
    choices <- dataset %>%
      filter(Categorized.class %in% selected_class(),
             Expo.Very.board %in% input$expo_b, 
             Expo.BitNarrow %in% input$expo_n) %>%
      pull(Effect.measure) %>% unique() %>% sort() 
    selectInput("effect_m",
                "Effect size (ES) measure method",
                choices = choices,
                selected = choices[1])
  })
  
  ## lower respiratory ####
  ## * intro #####
  output$low_res_intro_text <- renderUI({
    switch(
      input$low_res_btn,
      "sp" = p("Most articles related to lower respiratory disease were published in ???? and ???."),
      "ts" = p("This plot shows the date of publication of studies related to lower respiratory disease included in the review"),
      "coef" = p("The following table shows the number of reported outcomes (i.e lower and upper respiratory tracts, MRSA etc)
                    and the type of measure of effect for each of the 16 studies.")
    )
  })
  output$low_res_intro_plot <- renderUI({
    switch(
      input$low_res_btn,
      "sp" = fluidRow(
        column(width = 6, leafletOutput("map_low_res") %>% withSpinner()),
        column(width = 6, plotlyOutput("geobar_low_res") %>% withSpinner())),
      "ts" = timevisOutput("timeline_low_res"),
      "coef" = plotlyOutput("measure_all_low_res") %>% withSpinner()
    )
  })
  
  ## ** geographic distribution ####
  output$map_low_res <- renderLeaflet({
    leaflet(cafoo) %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)) %>%
      setView(-40.679728, 34.738366, zoom = 2) %>%  ## Set/fix the view of the map
      addCircleMarkers(lng = cafoo$long, lat = cafoo$lat,
                       radius = log(cafoo$`Number of Studies`)*8,
                       popup = ~paste("Country:", cafoo$Country, "<br>",
                                      "Number of Studies:", cafoo$`Number of Studies`))
  })
  output$geobar_low_res <- renderPlotly({
    gg <- cafo2 %>% filter(Refid %in% selected_id()) %>% distinct() %>%
      group_by(Country) %>% summarise(Count = n()) %>%
      mutate(Country = forcats::fct_reorder(factor(Country), Count)) %>%
      ggplot(aes(x = Country, y = Count)) +
      geom_bar(aes(fill = Country), stat = "identity") +
      scale_fill_brewer(palette = "Set2")
    ggplotly(gg, tooltip = c("x", "y")) %>% layout(showlegend = FALSE)
  })
  ## ** timeline ####
  output$timeline_low_res <- renderTimevis({
    ## Only select authors and year information columns
    timedata <- dataset %>% 
      filter(Categorized.class == selected_class()) %>% 
      select(paperInfo, paperYear) %>% distinct() %>%
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
  ## ** outcome ####
  output$measure_all_low_res <- renderPlotly({
    # browser()
    gg_low_res <- dataset %>%
      filter(`Categorized.class` == selected_class()) %>% 
      ggplot(aes(x = paperInfo)) +
      geom_bar(aes(fill = Outcome.variable)) + coord_flip() +
      scale_fill_brewer(palette = "Set3") +
      labs(x = "", fill = "Health Outcome Group") +
      xlab("Study") +
      ylab("Number of Reported Outcomes") + 
      theme(plot.background = element_rect(fill = "#BFD5E3"),
            panel.background = element_rect(fill = "white"),
            axis.line.x = element_line(color = "grey"))
    ggplotly(gg_low_res) %>% layout(showlegend = FALSE)
  })
  ## * forest plot ####
  forest_data <- reactive({
    forest_data <- dataset %>% filter(
      Categorized.class == selected_class(),
      Expo.Very.board == input$expo_b,
      Expo.BitNarrow %in% input$expo_n,
      Effect.measure == input$effect_m) %>% 
      select(Refid, Expo.Very.board, Expo.BitNarrow, Effect.measure,
             Outcome.variable, Exposure.measure, Subcategory,
             Effect.measure.1, Lower, Upper,
             one_of(ROB_cols)) %>% 
      mutate(
        Exposure.measure = ifelse(!is.na(Subcategory),
                                  sprintf("%s (%s)", Exposure.measure, Subcategory),
                                  Exposure.measure),
        interval = sprintf("(%.2f, %.2f)", Lower, Upper),
        id = factor(1:n()) %>% forcats::fct_reorder(Effect.measure.1)) %>%
      replace_na(list(ROB_overall_second = "Uncertain")) %>% 
      distinct() 
  })
  output$low_rsp_dt <- DT::renderDataTable({
    forest_dt(forest_data())
  })
  output$low_rsp_plotly <- renderPlotly({
    forest_plotly(forest_data(), input$low_rsp_dt_rows_current)
  })
  ## * risk of bias ####
  output$bias <- renderPlotly({
    gg <- r22 %>% filter(Refid %in% selected_id()) %>% 
      ggplot(aes(x = `Type of Bias`, fill = Bias)) + 
      geom_bar(position = "fill") + coord_flip() + 
      scale_fill_manual(values = color_table$Color) + 
      scale_x_discrete(labels = rev(c("Overall", "Confounding", "Measurement of Exposure", 
                                      "Measurement of Outcome", "Missing Data", "Selection",
                                      "Selection of Report"))) +
      ylab("Ratio")
    ggplotly(gg)
  })
})

