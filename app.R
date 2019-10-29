library(shiny)
library(readxl)
library(ggplot2)

# Load the ggplot2 package which provides
# the 'mpg' dataset.
library(ggplot2)

df <- read_xlsx("BE.xlsx")

data <- df

ui <- fluidPage(
  titlePanel("BE DataTable"),

  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("show_vars", "Columns in data to show:",
                         names(data), selected = names(data))
    ),
    mainPanel(
      # Create a new Row in the UI for selectInputs
      fluidRow(
        column(4,
               selectInput("dosage",
                           "Dosage Form:",
                           c("All",
                             unique(as.character(data$"Dosage Form"))))
        ),
        column(4,
               selectInput("route",
                           "Route:",
                           c("All",
                             unique(as.character(data$Route))))
        ),
        column(4,
               selectInput("treatment",
                           "Treatment:",
                           c("All",
                             unique(as.character(data$treatment))))
        )
    ),
    tabsetPanel(
      # Create a new row for the table.
      DT::dataTableOutput("table")
    )

  )
  )
)

server <- function(input, output) {
  
  df <- read_xlsx("BE.xlsx")
  
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- df
    
    data <- data[, input$show_vars]
    
    if (input$dosage != "All") {
      data <- data[data$"Dosage Form" == input$dosage, input$show_vars]
    }
    if (input$route != "All") {
      data <- data[data$Route == input$route, input$show_vars]
    }
    if (input$treatment != "All") {
      data <- data[data$Treatment == input$treatment, input$show_vars]
    }
    data
  }))
}

shinyApp(ui, server)
