
library(tree)    
prostate <- read.csv("prostate.csv")
pstree <- tree(lcavol ~., data=prostate, mincut=1)  


shinyServer
(
function(input, output, session) 
{
    pred <- reactive({predict(pstree, 
                              data.frame(lcavol = input$age,
                              age = input$age,
                              lbph = input$lbph,
                              lcp = input$lcp,
                              gleason = input$gleason,
                              lpsa = input$lpsa ))
                      })



output$prediction <- renderText({
                                  input$Submit
                                  isolate(pred())
                                })

output$image1 <- renderImage({
                            # Get width and height of image1
                              width  <- session$clientData$output_image1_width
                              height <- session$clientData$output_image1_height
                              
                              # A temp file to save the output.
                              # This file will be automatically removed later by
                              # renderImage, because of the deleteFile=TRUE argument.
                              outfile <- tempfile(fileext = ".png")
  
                              # Generate the image and write it to file
  
                              png(outfile,width=800,height=800,units="px", bg="transparent", 
                                  type="cairo-png")  
                              plot(pstree, col=12, main='ZZZ')
                              text(pstree, digits=2, cex=0.9)
                              dev.off()  
  
                              # Return a list containing information about the image
                              list(src = outfile,
                                   contentType = "image/png",
                                   width = width,
                                   height = height,
                                   alt = "This is alternate text")
                              
                            }, deleteFile = TRUE)


}
)