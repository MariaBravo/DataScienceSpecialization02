
runApp (appDir="shiny",
        port=NULL,host="127.0.0.1",
        launch.browser=getOption('shiny.launch.browser',interactive()), 
        )


runApp
(list
    (
        ui = bootstrapPage
            (
            numericInput('n', 'Number of obs', 100),
            plotOutput('plot') 
            ),
        server = function(input, output) 
        {
            output$plot <- renderPlot({ hist(runif(input$n)) })
        }
    )
)