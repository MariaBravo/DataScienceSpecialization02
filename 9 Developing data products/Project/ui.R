shinyUI(
  fluidPage(
    # Application title
    titlePanel("Prostate cancer prediction"),
    fluidRow(
      column(12,
             includeMarkdown("readme.md")
      )
    ),    
    sidebarPanel(
      h3('Patient data'),      
      numericInput('age', 'Age (age)', 50, min = 10, max = 100, step = 1),
      helpText('Min: 20 Max:100'),            
      helpText('______________________________'),      

      numericInput('lbph', 'Size of the prostate (lbph)', 0.1, min = -2, max = 3, step = 0.1),
      helpText('Min: -2 Max: 3'),            
      helpText('______________________________'),      
      
      numericInput('lcp', 'Capsular penetration (lcp)', -0.2, min = -2, max = 3, step = 0.1),
      helpText('Min: -2 Max: 3'),            
      helpText('______________________________'),          
      
      numericInput('lpsa', 'Prostate-specific antigen (lpsa)', 2.4, min = -1, max = 6, step = 0.1),      
      helpText('Min: -1 Max: 6'),            
      helpText('______________________________'),      
      
      numericInput('gleason', 'Gleason score (gleason)', 6.7, min = 1, max = 9, step = 0.1),
      helpText('Min: 1 Max: 9'),            
            
      actionButton('Submit', 'Submit'), width = 4
      
    ),
    mainPanel(
      h3('Results of prediction'),
      h4('Logarithm volume value of the tumor (cc) '),
      verbatimTextOutput("prediction"),
      h4('Classification Tree for prediction of prostate cancer tumor'),      
      helpText('We obtain a tree with 12 leaf nodes, the graph shows the nodes and how they are split.'),                  
      imageOutput("image1", width=800, height = 800),
      width = 7
    )
  )
)
