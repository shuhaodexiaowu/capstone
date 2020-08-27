#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


library(dplyr)
library(tidyr)

trigramset<- readRDS("F:/coursera/datasciencecapstone/final/en_US/tri/tri_total_s.Rds")
bigramset <- readRDS("F:/coursera/datasciencecapstone/final/en_US/bi/bi_total_s.Rds")
unigramset<- readRDS("F:/coursera/datasciencecapstone/final/en_US/uni/uni_total.Rds")

predictword<- function(sent){
    if (sent==""){
        finalword=""  #if user hasn't input anything,then nothing presented
    }else{
        sent<-tolower(sent)
        sent<-gsub("[!,.?;]"," ",sent)
        str1 <- strsplit(sent,"[ ]+") # split the sent into single word
        words <- unlist(str1)
        words <- words[!words %in% "the"]
        last_word <- words[length(words)]
        if (length(words)==1){
            last_2_word<- "ABCDE" # assign an character so that trigram cannot find ,than to bigram
        }
        else{last_2_word<- words[length(words)-1]}
    
    
            subset <- filter(trigramset,word1==last_2_word,word2==last_word)  ## find the possible trigram based on the two words
        if (dim(subset)[1]>0){
            subset2<-filter(subset,n==max(n))  #get the most frequant set
            if (dim(subset2)[1]==1){
                finalword<- subset2$word3
            }
            else{
            # how to find the most possible word We can refer to the bigram or just compare the unigram freq
                unisubset<- filter(unigramset,unigram %in% subset2$word3)
                unisubset<- unisubset[order(-unisubset$n),] # order the tbl by n decresing
                finalword<- unisubset$unigram[1]
            }
        }
        else{
            subset<-filter(bigramset,word1==last_word)
            if(dim(subset)[1]>0){
                subset2<-filter(subset,n==max(n))
                if(dim(subset2)[1]==1){
                    finalword<- subset2$word2
                }
                else{
                    unisubset<- filter(unigramset,unigram %in% subset2$word2)
                    unisubset<- unisubset[order(-unisubset$n),] # order the tbl by n decresing
                    finalword<- unisubset$unigram[1]
                }
            }
            else{
                finalword<-"is" #when there is no match of ngrams(n=2/3), just pick a verb of the most freq
            }
        }
    }
    finalword
    
    
}
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$word<-renderText({
        predictword(input$sent)
    })

 
})
