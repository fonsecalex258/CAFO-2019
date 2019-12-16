dashboardPage(
  skin = "purple",
  dashboardHeader(
    title = tags$span(class = "mytitle", "Human Health and Living Near Livestock Production Facilities"), 
    titleWidth = 630
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Background", tabName = "start", icon = icon("piggy-bank")),
      menuItem("About the Studies", tabName = "eda", icon = icon("chart-bar")),
      # menuItem("Forest Plot", tabName = "forest", icon = icon("tree")),
      menuItem("Health Outcomes", tabName = "outcome", icon = icon("list"),
               menuItem("Lower Respiratory", tabName = "low_rsp",
                        menuItem("Introduction", tabName = "low_rsp_intro"),
                        menuItem("Forest Plot", tabName = "low_rsp_forest"),
                        menuItem("Risk of Bias", tabName = "low_rsp_risk_of_bias"),
                        menuItem("Conclusion", tabName = "low_rsp_conclusion")),
               menuItem("Upper Respiratory", tabName = "up_rsp",
                        menuItem("Introduction", tabName = "up_rsp_intro"),
                        menuItem("Forest Plot", tabName = "up_rsp_forest"),
                        menuItem("Conclusion", tabName = "up_rsp_conclusion"))),
      menuItem("References", tabName = "ref", icon = icon("book")),
      # selectInput("class",
      #             "Outcome class",
      #             choices = class_var,
      #             selected = class_var[1]),
      uiOutput("measure"),
      uiOutput("expo_var_1"),
      uiOutput("expo_var_2"),
      id = "sidebar"
    )
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    tabItems(
      ## getting started ####
      tabItem(tabName = "start",
              fluidRow(
                box(
                  width = 12, solidHeader = TRUE, status = "primary",
                  title = "Living systematic review of effects of animal production on the health of surrounding communities",
                  h4("Introduction"),
                  p("In recent years there have been a growing concern about the harmful effects that animal facilities could have on nearby communities. 
                  Regarding the swine industry, it has been suggested that facilities that confine animals indoors for feeding might represent a health
                  hazard for surrounding communities due to the exposition to odors, emissions and other harmful agents."),
                  p("In this sense we had performed two systematic review summarizing the findings of publications approaching this matter.
                  These previous studies can be consulted by clicking on the following links:"),
                  p("1.", a("First Systematic Review", href = "https://systematicreviewsjournal.biomedcentral.com/articles/10.1186/s13643-017-0465-z")),
                  p("2.", a("Second Systematic Review", href = "https://systematicreviewsjournal.biomedcentral.com/articles/10.1186/s13643-017-0465-z")),
                  hr(),
                  h4("What is a Living Systematic Review?"),
                  p("Systematic reviews that are continually updated, incorporating relevant new evidence as it becomes available.
                  This term means that rather than being a static publication in a peer reviewed journal, 
                  the review is housed on this website allowing for more timely updates and more accessible information."),
                  p("Through this website producers, public health officers, community leaders and community members can access
                  the latest summary of the available studies and a balance interpretation of the findings and their implications
                  in the wider body of literature will better serve the needs of the community because it"),
                  p("1. Democratizes access to the information and interpretation, and"),
                  p("2. Provides for more timely and relevant update"),
                  br(),
                  div(img(src = "swine.jpg", height = 300, width = 500), style="text-align: left;"),
                  hr(),
                  h4("Our latest Systematic Review"),
                  p("Our last review was published in 2017 and its objective was to update a systematic review of associations
                    between living near an animal feeding operation (AFO) and human health.Our research question was:"),
                  tags$blockquote("What are the associations between animal feeding operations and measures of the health of individuals 
                     living near animal feeding operations, but not actively engaged in livestock production?")
                )
              )),
      ## descriptive plots ####
      tabItem(tabName = "eda",
              fluidRow(
                box(width = 12,
                    p("The literture about human health impacts of living near production animals is quite limited. After conducting an exhaustive search, our team identified 16 studies consisting of 10 study populations to include in the analysis.
                    Those 16 studies were conducted in only three countries. The health outcomes were lower and upper respiratory tracts, MRSA, other infectious disease, neurological, 
                    psychological, dermatological, otologic, ocular, gastrointestinal, stress and mood, and other non-infectious health outcomes."),
                    radioGroupButtons(
                      inputId = "eda_btn", justified = TRUE, label = "",
                      choices = c(`<i class='fa fa-globe'></i> Geographical Distribution` = "sp", 
                                  `<i class='fa fa-calendar-alt'></i> Timeline` = "ts", 
                                  `<i class='fa fa-poll'></i> Health Outcome` = "coef")
                    ),
                    uiOutput("eda_text"),
                    uiOutput("eda_plot")
                )
              )
      ),
      ## low respiratory ####
      ## * introduction ####
      tabItem(tabName = "low_rsp_intro",
              fluidRow(
                box(width = 12,
                    p("An introduction to the “outcome class” and the interpretation of the results."),
                    p("A “map” of the studies that apply to that particular outcome.
                       This map would look like the current map on the descriptions tab 
                       BUT would only have the subset of papers for the outcome instead of all the papers
                       which are what is listed on the “descriptive plots”."),
                    radioGroupButtons(
                      inputId = "low_res_btn", justified = TRUE, label = "",
                      choices = c(`<i class='fa fa-globe'></i> Geographical Distribution` = "sp",
                                  `<i class='fa fa-calendar-alt'></i> Timeline` = "ts",
                                  `<i class='fa fa-poll'></i> Lower Respiratory Outcome` = "coef")
                    ),
                    uiOutput("low_res_intro_text"),
                    uiOutput("low_res_intro_plot")
                    )
                )),
      ## * forest plot ####
      tabItem(tabName = "low_rsp_forest",
              fluidRow(
                box(width = 12, title = "Concentrated Animal Feeding Operations (CAFOs) Data", solidHeader = T, status = "primary",
                    em("1. In the 'ROB class' column,
                       OE: Objective Exposure; SE: Subjective Exposure; 
                       OO: Objective Outcome; SO: Subjective Outcome."),
                    br(),
                    em("2. In the ROB plot, each half circle represents opinion for that 
                        particular type of ROB from one of two independent reviewers,
                        i.e. for each circle, left hand side half circle represents opinion 
                        from first reviewer and  right hand side half circle from second reviewer."),
                    hr(),
                    DT::dataTableOutput("low_rsp_dt") %>% withSpinner(),
                    hr(),
                    plotlyOutput("low_rsp_plotly", height = "500px") %>% withSpinner()
                )
              )),
      
      ## * Risk of Bias ####
      tabItem(tabName = "low_rsp_risk_of_bias",
              fluidRow(
                box(width = 12, solidHeader = TRUE, status = "primary", title = "Risk of Bias for Lower Respiratory Disease",
                    p("Risk of Bias plot"),
                    plotlyOutput("bias") %>% withSpinner()
                )
              )), 
      
      ## * conclusion ####
      tabItem(tabName = "low_rsp_conclusion",
              fluidRow(
                box(width = 12, solidHeader = TRUE, status = "primary", title = "Conclusions about Lower Respiratory Disease",
                    p("This review revealed that there is sufficient evidence to
                      conclude that communities living in proximity to goat
                      production are at increased risk of Q fever. The association
                      between MRSA colonization and proximity is unclear,
                      mainly due to a lack of replication. The conclusions
                      about associations with other outcomes, especially those
                      related to upper and lower respiratory disease, are unchanged
                      from the prior review:"),
                    tags$blockquote("There was inconsistent
                      evidence of a weak association between self-reported disease
                      in people with allergies or familial history of allergies.
                      No consistent dose response relationship between exposure
                      and disease was observable."),
                    p("If questions about the
                      health effects of living near animal production continue to
                      be of interest, then large, long-term prospective studies
                      will be required, especially if non-specific clinical symptoms
                      are the outcomes of interest.")
                )
              )),
      
      ## references ####  
      tabItem(tabName = "ref",
              fluidRow(
                box(width = 12, solidHeader = TRUE, status = "primary", title = "References",
                    div(HTML(mybib)))
              ))
    )
  )
)