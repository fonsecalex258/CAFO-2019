library(shinydashboard)

dashboardPage(
  skin = "purple",
  dashboardHeader(title = "Updated Systematic Review on CAFO Data", titleWidth = 400),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Getting Started", tabName = "start", icon = icon("piggy-bank")),
      menuItem("Descriptive Plots", tabName = "eda", icon = icon("chart-bar")),
      menuItem("Metafor Forest Plot", tabName = "meta_forest", icon = icon("tree")),
      menuItem("Original Forest Plot", tabName = "org_forest", icon = icon("tree")),
      menuItem("Summary", tabName = "summary", icon = icon("list")),
      menuItem("References", tabName = "ref", icon = icon("book"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "start",
              fluidRow(
                box(
                  width = 12, height = "1000", solidHeader = TRUE, status = "primary",
                  title = "Living systematic review of effects of swine production on the health of surrounding communities",
                  h4("Introduction"),
                  p("In recent years there have been a growing concern about the harmful effects that animal facilities could have on nearby communities. 
                  Regarding the swine industry, it has been suggested that facilities that confine animals indoors for feeding might represent a health
                  hazard for surrounding communities due to the exposition to odors, emissions and other harmful agents."),
                  p("In this sense we had performed two systematic review summarizing the findings of publications approaching this matter.
                  These previous studies can be consulted by clicking on the following links:"),
                  tags$li(
                    a("First Systematic Review", href = "https://systematicreviewsjournal.biomedcentral.com/articles/10.1186/s13643-017-0465-z")
                  ),
                  tags$li(
                    a("Second Systematic Review", href = "https://systematicreviewsjournal.biomedcentral.com/articles/10.1186/s13643-017-0465-z")
                  ),
                  h4("What is a Living systematic review?"),
                  p("Systematic reviews that are continually updated, incorporating relevant new evidence as it becomes available.
                  This term means that rather than being a static publication in a peer reviewed journal, 
                  the review is housed on this website allowing for more timely updates and more accessible information."),
                  p("Through this website producers, public health officers, community leaders and community members can access
                  the latest summary of the available studies and a balance interpretation of the findings and their implications
                  in the wider body of literature will better serve the needs of the community because it"),
                  tags$li(
                    "Democratizes access to the information and interpretation, and"
                  ),
                  tags$li(
                    "Provides for more timely and relevant update"
                  ),
                  br(),
                  img(src = "swine.jpg", height = 300, width = 500),
                  h4("Our latest Systematic Review"),
                  p("Our last review was published in 2017 and its objective was to update a systematic review of associations
                    between living near an animal feeding operation (AFO) and human health.Our research question was:"),
                  em("What are the associations between animal feeding operations and measures of the health of individuals 
                     living near animal feeding operations, but not actively engaged in livestock production?")
                )
              )),
      tabItem(tabName = "eda")
    )
  )
)