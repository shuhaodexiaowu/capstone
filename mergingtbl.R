# These part  is the example code to combine the seperate dataset

library(dplyr)
library(tidytext)

t1uni <-readRDS("./tri/twitter_tri.Rds")

t2uni <-readRDS("./tri/blog_tri.Rds")
t3uni <-readRDS("./tri/news_tri.Rds")


t12 <-merge(t1uni,t2uni,by="trigram",all=T)  # merge two tbl
t12[is.na(t12)]<-0                            # set NA to zero

t12 <- mutate(t12,n=n.x+n.y)                    # sum 
t12 <- select(t12,trigram,n)

t123 <-merge(t3uni,t12,by="trigram",all=T)  # merge two tbl
t123[is.na(t123)]<-0                            # set NA to zero

t123 <- mutate(t123,n=n.x+n.y)                    # sum 
t123 <- select(t123,trigram,n)

saveRDS(t123,"./tri/tri_total.Rds")