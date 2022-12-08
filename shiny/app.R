#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyreforms)
library(httr)
library(jsonlite)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Test Dashboard for EC2022"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            textInput("name", h3("Nombre"), 
                     value = "Escriba su nombre"),
            textInput("lastname", h3("Apellido"), 
                     value = "Escriba su nombre"),
            numericInput("age", h3("edad"), value=0),
            actionButton("save", "Guardar"),
        ),

        # Show a plot of the generated distribution
        mainPanel(
           dataTableOutput("houses")    
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
 

    output$houses = renderDataTable({
        resp <- GET('http://api:5000/houses/')
        df <- fromJSON(content(resp, as='text'))
        df
    })

}

# Run the application 
shinyApp(ui = ui, server = server)