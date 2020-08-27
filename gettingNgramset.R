## This is the code to processs the original file

## getting the dataset as the model data

## Condering my computer memory limit, I have to split the whole text into 4 files and then get the Ngrams dataset seperately.

blogs <- file("F:/coursera/datasciencecapstone/final/en_US/B4.txt","r") # fourth of the Blog file

blogslines <- readLines(blogs,encoding= "UTF-8",skipNul = TRUE)

close(blogs)

library(tm)

library(dplyr)
library(tidytext)

corpus<- VCorpus(VectorSource(blogslines))   

corpus<- tm_map(corpus,removeNumbers)        # remove numbers
corpus<- tm_map(corpus,removePunctuation)    # remove punctuation
corpus<- tm_map(corpus,stripWhitespace)      # remove redundant space
corpus<- tm_map(corpus,tolower) 

# If you want to remove the profanity
#  download.file("https://www.cs.cmu.edu/~biglou/resources/bad-words.txt","badwords.txt") to get the profanity content
# profanity <- readLines("badwords.txt",encoding = "UTF-8")
# corpus_sam<- tm_map(corpus_sam,removeWords, profanity)   
# I skipped it, it needs some time to process, and I did it using the sample data, It seems that have no effect.


corpus<-tm_map(corpus,removeWords, "the")  # Maybe you can remove all the stopword, condsidering that two quizs for training are both stopwords sensitive, I just remove the, 
# actually ,you got the unigram word, and you can remove some words that have no meanings to simplify Ngrams sets.

corpus<- tm_map(corpus,PlainTextDocument) 

# the above code aims to get the clean corpus and then I use the tidy text to tokenize( I have tried to use RWeka and Quanteda, and they both cannot go smoothly with the limit of my PC)
# for tidytext ,there is a tutorial https://text-mining-with-r-a-tidy-approach.netlify.app/tidytext
tbl<- tidy(corpus)
rm(corpus)
rm(bloglines) # to release part of the memory

saveRDS(tbl,"blogpart4.Rds") # save the file so that I don't need to process the file again and again.
gc()
unigram <-unnest_tokens(tbl,unigram, text, token="ngrams", n=1)
rm(tbl)
unitbl <- count(unigram,unigram,sort =T)  #  get the blog uni tbl
saveRDS(unitbl,"B4_uni.Rds")

# Now, I get the blog4 files unigram dataset 
# to get the blog4 bigram dataset, just load the tbl and change the parameter in the function unnest_tokens
# repeat these steps to get the blog3,2,1
# repeat these steps to get the twitter and news

