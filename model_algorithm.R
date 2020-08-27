# the code of the model

#getting the Ngrams tbl

# basic idea: use the trigram to predict the word
# when there are some words having the same frequency,then compare the bigram frequency then unigram

library(dplyr)
library(tidyr)

trigramset<- readRDS("F:/coursera/datasciencecapstone/final/en_US/tri/tri_total_s.Rds")
bigramset <- readRDS("F:/coursera/datasciencecapstone/final/en_US/bi/bi_total_s.Rds")
unigramset<- readRDS("F:/coursera/datasciencecapstone/final/en_US/uni/uni_total.Rds")
# the tbl Ngrams have seperate the words by word1, word2, (word3) because　I find they take up the smaller size of memory
# the following the code to seperate them
# bigramset2<- separate(bigramset,bigram,c("word1","word2"), sep = " ")
# saveRDS(bigramset2,"./final/en_US/bi/bi_total_s.Rds")
# 
# trigramset2 <-separate(trigramset,trigram,c("word1","word2","word3"),sep = " ")
# saveRDS(trigramset2,"./final/en_US/tri/tri_total_s.Rds")


# I have remove the frequence of 1 Ngrams, still I find that the Ngrams with 2 frequence are alse meaningless
# So i can cut this part to improve the effeciency.

# Furthermore, I can calculate the coverage. Actually I can omit n<=5 rows for trigramset to achieve of coverage of 90% occurance
# The other two set can also be filtered to achieve a smaller memory storage

# trigramset <- filter(trigramset,n>3)
# I didn't do it, because I use the Rprof function and find the time is about 0.5s It's quite acceptatble, so I retain these low
# frequence grams so that I can have a higher accuracy.

predictword<- function(sent){
       
        sent<-tolower(sent)
        sent<-gsub("[!,.?;]"," ",sent)
        str1 <- strsplit(sent,"[ ]+") # split the sent into single word
        words <- unlist(str1)
        words <- words[!words %in% "the"]
        last_word <- words[length(words)]
        if (length(words)==1){
                last_2_word<- "ABCD" # assign an character so that trigram cannot find ,than to bigram
        }else{last_2_word<- words[length(words)-1]}
        
        
        
        subset <- filter(trigramset,word1==last_2_word,word2==last_word)  ## find the possible trigram based on the two words
        if (dim(subset)[1]>0){
                subset2<-filter(subset,n==max(n))  #get the most frequant set
                if (dim(subset2)[1]==1){
                        finalword<- subset2$word3
                }else{
                        # how to find the most possible word We can refer to the bigram or just compare the unigram freq
                        unisubset<- filter(unigramset,unigram %in% subset2$word3)
                        unisubset<- unisubset[order(-unisubset$n),] # order the tbl by n decresing
                        finalword<- unisubset$unigram[1]
                }
        }else{
                subset<-filter(bigramset,word1==last_word)
                if(dim(subset)[1]>0){
                        subset2<-filter(subset,n==max(n))
                        if(dim(subset2)[1]==1){
                                finalword<- subset2$word2
                        }else{
                                unisubset<- filter(unigramset,unigram %in% subset2$word2)
                                unisubset<- unisubset[order(-unisubset$n),] # order the tbl by n decresing
                                finalword<- unisubset$unigram[1]
                        }
                }else{
                        finalword<-"is" #when there is no match of ngrams(n=2/3), just pick a verb of the most freq
                }
        }
        finalword
        
        
}



