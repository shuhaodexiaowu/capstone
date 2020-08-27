#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    headerPanel("Coursera Data Science Capstone"),

    # Application title
    titlePanel("Predicting the next word"),

    # remind user to input the sentence
    sidebarLayout(
        sidebarPanel(
            # tags$hgroup(strong("sider"),strong("Panel")),
            textInput(inputId="sent",label="Please type some words as the input"),
            
            br(),  #
            p("Tips:"),
            p("Only English can be predicted"),
            p("When first open the app,please wait for a minute"),
            p("Input example: I want to know the")
        ),
        
        mainPanel(
            h3("The predicted word is:"),    
            textOutput("word")
        )
    )

    )
)
