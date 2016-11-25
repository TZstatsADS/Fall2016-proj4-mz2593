setwd("C:/Users/Mengya/Desktop/Columbia Desk/GR5243/Fall2016-proj4-mz2593")
load('data/lyr.Rdata')
install.packages("ldatuning")
install.packages("devtools")
devtools::install_github("nikita-moor/ldatuning")
library("ldatuning")
library("topicmodels")

c(2,3,6:30) 

best.model <- lapply(seq(40,50, by=1), function(k){LDA(lyr[,-c(1:3,6:30)], k)})

best.model.logLik <- as.data.frame(as.matrix(lapply(best.model, logLik)))

best.model.logLik.df <- data.frame(topics=c(45:55), LL=as.numeric(as.matrix(best.model.logLik)))

best.model.logLik.df[which.max(best.model.logLik.df$LL),]

K<-50
# generate the model with k topics
lda_AP <- LDA(lyr[ ,-c(1:3,6:30)], 50) 
                      
#gets most likely topics for each document
topic.matrix <- as.data.frame(cbind(as.matrix(lyr[,1]),matrix(as.integer(get_topics(lda_AP,1)))) )
colnames(topic.matrix) <- c("filenames","topic")

# gets keywords rank for each topic 
words <- as.vector(colnames(lyr))
index <- matrix(nrow= 5001,ncol = K)

for (i in 1:K){
  index[,i] <- match( words, get_terms(lda_AP,5001)[,i] )
}
as.data.frame(index)

#assign column names to topics vs. keywords
tnames <-c()
for (i in 1:K){
  tnames[i] <- matrix( c(paste("Topic",i,sep = "")) )
}
colnames(index) <- tnames


write.csv(index,file="C:/Users/Mengya/Desktop/Columbia Desk/GR5243/Fall2016-proj4-mz2593/output/topicindex.csv")
write.csv(topic.matrix,file="C:/Users/Mengya/Desktop/Columbia Desk/GR5243/Fall2016-proj4-mz2593/output/Y.csv")

save(lda_AP, file = "C:/Users/Mengya/Desktop/Columbia Desk/GR5243/Fall2016-proj4-mz2593/output/lda.Rdata")



