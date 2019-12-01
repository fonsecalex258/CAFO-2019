dashboardPage(
  skin = "purple",
  dashboardHeader(title = tags$span(class = "mytitle", "Updated Systematic Review on CAFO Data"), titleWidth = 450),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Getting Started", tabName = "start", icon = icon("piggy-bank")),
      menuItem("Descriptive Plots", tabName = "eda", icon = icon("chart-bar")),
      menuItem("Forest Plot", tabName = "forest", icon = icon("tree")),
      menuItem("Summary", tabName = "summary", icon = icon("list")),
      menuItem("References", tabName = "ref", icon = icon("book"))
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
                  width = 12, height = 1100, solidHeader = TRUE, status = "primary",
                  title = "Living systematic review of effects of swine production on the health of surrounding communities",
                  h4("Introduction"),
                  p("In recent years there have been a growing concern about the harmful effects that animal facilities could have on nearby communities. 
                  Regarding the swine industry, it has been suggested that facilities that confine animals indoors for feeding might represent a health
                  hazard for surrounding communities due to the exposition to odors, emissions and other harmful agents."),
                  p("In this sense we had performed two systematic review summarizing the findings of publications approaching this matter.
                  These previous studies can be consulted by clicking on the following links:"),
                  p("1.", a("First Systematic Review", href = "https://systematicreviewsjournal.biomedcentral.com/articles/10.1186/s13643-017-0465-z")),
                  p("2.", a("Second Systematic Review", href = "https://systematicreviewsjournal.biomedcentral.com/articles/10.1186/s13643-017-0465-z")),
                  hr(),
                  h4("What is a Living systematic review?"),
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
                  p("The search returned 3702 citations. 16 consisting of 10 study populations were included in the analysis.
                    The health outcomes were lower and upper respiratory tracts, MRSA, other infectious disease, neurological, 
                    psychological, dermatological, otologic, ocular, gastrointestinal, stress and mood, and other non-infectious health outcomes."),
                  radioGroupButtons(
                    inputId = "eda_btn", justified = TRUE, label = "",
                    choices = c(`<i class='fa fa-globe'></i> Geographical Distribution` = "sp", 
                                `<i class='fa fa-calendar-alt'></i> Timeline` = "ts", 
                                `<i class='fa fa-poll'></i> Effect Measure` = "coef")
                    ),
                  uiOutput("eda_text"),
                  uiOutput("eda_plot")
                )
              )
              ),
      ## summary ####
      tabItem(tabName = "summary",
              fluidRow(
                box(width = 12, solidHeader = TRUE, status = "primary", title = "Conclusions",
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
                      are the outcomes of interest."),
                    plotlyOutput("bias") %>% withSpinner())
              )),
    ## references ####  
    tabItem(tabName = "ref",
            fluidRow(
              box(width = 12, height = 1000, solidHeader = TRUE, status = "primary", title = "References",
                  div(HTML(mybib)))
            ))
    )
  )
)