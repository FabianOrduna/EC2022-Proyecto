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

concat_for_row <- function(id, price, area, bedrooms, bathrooms, stories, mainroad, guestroom, basement, hotwaterheating, airconditioning, parking, prefarea, furnishingstatus) {
    paste0("<tr><td>",id,"</td><td>",price,"</td><td>",area,"</td><td>",bedrooms,"</td><td>",bathrooms,"</td><td>",stories,"</td><td>",mainroad,"</td><td>",guestroom,"</td><td>",basement,"</td><td>",hotwaterheating,"</td><td>",airconditioning,"</td><td>",parking,"</td><td>",prefarea,"</td><td>",furnishingstatus,"</td></tr>")
}

returnHouseHtmlFromGetResult <- function(res){

    if(status_code(res) == 200){
    
        jsonResult <- fromJSON(content(res, "text"))

        tableSkeleton1 <- "<div class=table-responsive>
            <br/>
            <table class='table table-striped'>
                <thead>
                    <tr>
                    <th>Id</th>
                    <th>Price</th>
                    <th>Area</th>
                    <th>Bedrooms</th>
                    <th>Bathrooms</th>
                    <th>Stories</th>
                    <th>Mainroad</th>
                    <th>Guestroom</th>
                    <th>Basement</th>
                    <th>Hotwaterheating</th>
                    <th>Airconditioning</th>
                    <th>Parking</th>
                    <th>Prefarea</th>
                    <th>furnishingstatus</th>
                    </tr>
                </thead>
            <tbody>"
            rowContent <- concat_for_row(jsonResult$id, 
                jsonResult$price,
                jsonResult$area,
                jsonResult$bedrooms,
                jsonResult$bathrooms,
                jsonResult$stories,
                jsonResult$mainroad,
                jsonResult$guestroom,
                jsonResult$basement,
                jsonResult$hotwaterheating,
                jsonResult$airconditioning,
                jsonResult$parking,
                jsonResult$prefarea,
                jsonResult$furnishingstatus)
            tableSkeleton2 <- "</tbody></table></div>"
        
        return(paste0(tableSkeleton1, rowContent, tableSkeleton2))
    }

    return("<p>Casa no encontrada</p>")
}

# https://cran.r-project.org/web/packages/shinyreforms/vignettes/tutorial.html
myForm <- shinyreforms::ShinyForm$new(
    "myForm",
    submit = "Dar de alta",
    onSuccess = function(self, input, output) {

        price_p <- self$getValue(input, "price_input")
        area_p <- self$getValue(input, "area_input")
        bedrooms_p <- self$getValue(input, "bedrooms_input")
        bathrooms_p <- self$getValue(input, "bathrooms_input")
        stories_p <- self$getValue(input, "stories_input")
        mainroad_p <- self$getValue(input, "mainroad_input")
        guestroom_p <- self$getValue(input, "guestroom_input")
        basement_p <- self$getValue(input, "basement_input")
        hotwaterheating_p <- self$getValue(input, "hotwaterheating_input")
        airconditioning_p <- self$getValue(input, "airconditioning_input")
        parking_p <- self$getValue(input, "parking_input")
        prefarea_p <- self$getValue(input, "prefarea_input")
        furnishingstatus_p <- self$getValue(input, "furnishingstatus_input")

        listaParams <- list(
            price =  strtoi(price_p, base=0L),
            area =  strtoi(area_p, base=0L),
            bedrooms =  strtoi(bedrooms_p, base=0L),
            bathrooms =  strtoi(bathrooms_p, base=0L),
            stories =  strtoi(stories_p, base=0L),
            mainroad = "true",#str(mainroad_p),
            guestroom =  "true",#str(guestroom_p),
            basement = "true",# str(basement_p),
            hotwaterheating = "true",#str(hotwaterheating_p),
            airconditioning = "true",#str(airconditioning_p),
            parking =  strtoi(parking_p, base=0L),
            prefarea = "true",# str(prefarea_p)
            furnishingstatus = furnishingstatus_p
        )

        res <- POST("http://api:5000/houses", body = listaParams, encode="form")

        if(status_code(res)==201){
           textoResultante <- paste0("<p>Sí se pudo crear la casa",content(res,"text"),"</p>")
        }else{
           textoResultante <- "hubo un error"
        }


        output$resultalta <- shiny::renderText({
            textoResultante
        })
    },
    onError = function(self, input, output) {
        output$resultalta <- shiny::renderText({
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
        
        

        output$resultactualiza <- shiny::renderText({
            "intentas actualizar una casa"
        })
    },
    onError = function(self, input, output) {
        output$resultactualiza <- shiny::renderText({
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

        textoResultante <- ""

        id <- self$getValue(input, "id_input_elimina")

        res <- DELETE(paste0("http://api:5000/houses/",id))

        if(status_code(res)==204){
            textoResultante <- paste0("<p>Sí se pudo eliminar la casa con id: ",id,"</p>")
        }else{
            textoResultante <- paste0("<p> No se pudo eliminar: ",id,"</p>")
        }

        output$eliminaresult <- shiny::renderText({
            textoResultante
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
            returnHouseHtmlFromGetResult(res)
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
                    shiny::htmlOutput("resultalta")
                     
                   )
            ),
            column(4,
                   wellPanel(
                     
                     shiny::tags$h1("Actualiza casa por id"),
                     actualizaForm$ui(),
                    shiny::htmlOutput("resultactualiza")
                   )
            ),
            column(4,
                   wellPanel(
                     
                     shiny::tags$h1("Busca casa por id"),
                     buscaCasaForm$ui(),
                     shiny::htmlOutput("result")
                   ),
                   wellPanel(
                     shiny::tags$h1("Elimina casa por id"),
                     eliminaCasaForm$ui(),
                     shiny::htmlOutput("eliminaresult")
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

