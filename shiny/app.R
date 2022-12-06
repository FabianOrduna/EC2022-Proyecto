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

# https://cran.r-project.org/web/packages/shinyreforms/vignettes/tutorial.html
myForm <- shinyreforms::ShinyForm$new(
    "myForm",
    submit = "Submit",
    onSuccess = function(self, input, output) {
        yourName <- self$getValue(input, "name_input")

        output$result <- shiny::renderText({
            paste0("Your name is ", yourName, "!")
        })
    },
    onError = function(self, input, output) {
        output$result <- shiny::renderText({
            "Form is invalid!"
        })
    },
    shinyreforms::validatedInput(
        shiny::textInput("name_input", label = "Username"),
        helpText="Username length is between 4 and 12 characters.",
        #validators = c(
            #shinyreforms::ValidatorMinLength(4),
            #shinyreforms::ValidatorMaxLength(12),
            #shinyreforms::Validator$new(
             #   test = function(value) value != "test",
              #  failMessage = "Username can't be 'test'!"
            #)
        #)
    ),
    shinyreforms::validatedInput(
        shiny::checkboxInput("checkbox", label = "I accept!"),
        validators = c(
            shinyreforms::ValidatorRequired()
        )
    )
)


server <- function(input, output, session) {
    myForm$server(input, output)

    # More server logic
}






ui <- shiny::bootstrapPage(
    shinyreforms::shinyReformsPage(  # This adds a dependency on shinyreforms .css
        shiny::fluidPage(
            shiny::tags$h1("Example ShinyForm!"),
            myForm$ui(),  # <- ShinyForm will be included here!
            shiny::tags$h4("Result:"),
            shiny::textOutput("result")
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

