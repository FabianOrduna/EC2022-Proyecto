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

# https://cran.r-project.org/web/packages/shinyreforms/vignettes/tutorial.html
myForm <- shinyreforms::ShinyForm$new(
    "myForm",
    submit = "Dar de alta",
    onSuccess = function(self, input, output) {
        price <- self$getValue(input, "price_input")

        output$result <- shiny::renderText({
            paste0("Price: ", price, "</br>")
        })
    },
    onError = function(self, input, output) {
        output$result <- shiny::renderText({
            "Form is invalid!"
        })
    },
    shinyreforms::validatedInput(
        shiny::textInput("price_input", label = "Price")
    ),
    shinyreforms::validatedInput(
        shiny::textInput("area_input", label = "Area")
    ),
    shinyreforms::validatedInput(
        shiny::textInput("bedrooms_input", label = "Bedrooms")
    ),
    shinyreforms::validatedInput(
        shiny::textInput("bathrooms_input", label = "Bathrooms")
    ),
    shinyreforms::validatedInput(
        shiny::textInput("stories_input", label = "Stories")
    ),
    shinyreforms::validatedInput(
        shiny::checkboxInput("mainroad_input", label = "Mainroad")
    ),
    shinyreforms::validatedInput(
        shiny::checkboxInput("guestroom_input", label = "Guestroom")
    ),
    shinyreforms::validatedInput(
        shiny::checkboxInput("basement_input", label = "Basement")
    ),
    shinyreforms::validatedInput(
        shiny::checkboxInput("hotwaterheating_input", label = "Hotwaterheating")
    ),
    shinyreforms::validatedInput(
        shiny::checkboxInput("airconditioning_input", label = "Airconditioning")
    ),
    shinyreforms::validatedInput(
        shiny::textInput("parking_input", label = "Parking")
    ),
    shinyreforms::validatedInput(
        shiny::checkboxInput("prefarea_input", label = "Prefarea")
    ),
    shinyreforms::validatedInput(
        #shiny::textInput("furnishingstatus_input", label = "FurnishingStatus")
        #  furnished | semi-furnished | unfurnished

        shiny::selectInput("furnishingstatus_input", "FurnishingStatus:",
                c("furnished" = "furnished",
                  "semi-furnished" = "semi-furnished",
                  "unfurnished" = "unfurnished")),
    )
)

actualizaForm <- shinyreforms::ShinyForm$new(
    "actualizaForm",
    submit = "Actualiza una casa",
    onSuccess = function(self, input, output) {
        price <- self$getValue(input, "price_input_actualiza")

        output$result <- shiny::renderText({
            paste0("Price: ", price, "</br>")
        })
    },
    onError = function(self, input, output) {
        output$result <- shiny::renderText({
            "Form is invalid!"
        })
    },
    shinyreforms::validatedInput(
        shiny::textInput("id_input_actualiza", label = "Id")
    ),
    shinyreforms::validatedInput(
        shiny::textInput("price_input_actualiza", label = "Price")
    ),
    shinyreforms::validatedInput(
        shiny::textInput("area_input_actualiza", label = "Area")
    ),
    shinyreforms::validatedInput(
        shiny::textInput("bedrooms_input_actualiza", label = "Bedrooms")
    ),
    shinyreforms::validatedInput(
        shiny::textInput("bathrooms_input_actualiza", label = "Bathrooms")
    ),
    shinyreforms::validatedInput(
        shiny::textInput("stories_input_actualiza", label = "Stories")
    ),
    shinyreforms::validatedInput(
        shiny::checkboxInput("mainroad_input_actualiza", label = "Mainroad")
    ),
    shinyreforms::validatedInput(
        shiny::checkboxInput("guestroom_input_actualiza", label = "Guestroom")
    ),
    shinyreforms::validatedInput(
        shiny::checkboxInput("basement_input_actualiza", label = "Basement")
    ),
    shinyreforms::validatedInput(
        shiny::checkboxInput("hotwaterheating_input_actualiza", label = "Hotwaterheating")
    ),
    shinyreforms::validatedInput(
        shiny::checkboxInput("airconditioning_input_actualiza", label = "Airconditioning")
    ),
    shinyreforms::validatedInput(
        shiny::textInput("parking_input_actualiza", label = "Parking")
    ),
    shinyreforms::validatedInput(
        shiny::checkboxInput("prefarea_input_actualiza", label = "Prefarea")
    ),
    shinyreforms::validatedInput(
        #shiny::textInput("furnishingstatus_input", label = "FurnishingStatus")
        #  furnished | semi-furnished | unfurnished

        shiny::selectInput("furnishingstatus_input_actualiza", "FurnishingStatus:",
                c("furnished" = "furnished",
                  "semi-furnished" = "semi-furnished",
                  "unfurnished" = "unfurnished")),
    )
)


eliminaCasaForm <- shinyreforms::ShinyForm$new(
    "eliminaCasaForm",
    submit = "Eliminar casa",
    onSuccess = function(self, input, output) {
        id <- self$getValue(input, "id_input_elimina")

        output$result <- shiny::renderText({
            paste0("Id: ", id, "</br>")
        })
    },
    onError = function(self, input, output) {
        output$result <- shiny::renderText({
            "Form is invalid!"
        })
    },
    
    shiny::textInput("id_input_elimina", label = "Id")
    
)

buscaCasaForm <- shinyreforms::ShinyForm$new(
    "buscaCasaForm",
    submit = "Buscar casa",
    onSuccess = function(self, input, output) {
        id <- self$getValue(input, "id_input_busca")

        res <- GET(paste0("http://api:5000/houses/",id))

        output$result <- shiny::renderText({
            content(res, "text")
        })
    },
    onError = function(self, input, output) {
        output$result <- shiny::renderText({
            "Form is invalid!"
        })
    },
    shiny::textInput("id_input_busca", label = "Id")
)


server <- function(input, output, session) {
    myForm$server(input, output)
    eliminaCasaForm$server(input,output)
    actualizaForm$server(input,output)
    buscaCasaForm$server(input,output)
    # More server logic
}






ui <- shiny::bootstrapPage(
    shinyreforms::shinyReformsPage(  # This adds a dependency on shinyreforms .css
        shiny::fluidPage(
          
          
          fluidRow(
            
            column(4,
                   wellPanel(
                     
                     shiny::tags$h1("Alta de casa"),
                     myForm$ui(),
                     
                   )
            ),
            column(4,
                   wellPanel(
                     
                     shiny::tags$h1("Elimina casa por id"),
                     eliminaCasaForm$ui()
                   ),
                   wellPanel(
                     
                     shiny::tags$h1("Actualiza casa por id"),
                     actualizaForm$ui()
                   )
            ),
            column(4,
                   wellPanel(
                     
                     shiny::tags$h1("Busca casa por id"),
                     buscaCasaForm$ui(),
                     shiny::textOutput("result")
                   )
            ),









          )
        )
    )
)




# Define UI for app that draws a histogram ----
#ui <- fluidPage(

  # App title ----
 # titlePanel("Hello Shiny!"),

  # Sidebar layout with input and output definitions ----
  #sidebarLayout(

    # Sidebar panel for inputs ----
   # sidebarPanel(

      # Input: Slider for the number of bins ----
    #  sliderInput(inputId = "bins",
     #             label = "Number of bins:",
      #            min = 1,
       #           max = 50,
        #          value = 30)

    #),

    # Main panel for displaying outputs ----
    #mainPanel(

      # Output: Histogram ----
     # plotOutput(outputId = "distPlot")

      
    #)
  #)
#)

# Define server logic required to draw a histogram ----
#server <- function(input, output) {

  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  
  
  #$distPlot <- renderPlot({

   # x    <- faithful$waiting
    #bins <- seq(min(x), max(x), length.out = input$bins + 1)

    #hist(x, breaks = bins, col = "#007bc2", border = "white",
     #    xlab = "Waiting time to next eruption (in mins)",
      #   main = "Histogram of waiting times")

    #})

#}

# Run the application 
shinyApp(ui = ui, server = server)

