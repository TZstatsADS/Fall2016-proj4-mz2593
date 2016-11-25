setwd("C:/Users/Mengya/Desktop/Columbia Desk/GR5243/Fall2016-proj4-mz2593")
load('data/lyr.Rdata')
load('output/buildfeatures.Rdata')
load('output/lda.Rdata')
load('output/Sound.Rdata')
load('output/xgb_fit.Rdata')


source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")
library(rhdf5)
setwd('C:/Users/Mengya/Desktop/Columbia Desk/GR5243/TestSongFile100/TestSongFile100')

#read files and extract features from 100 test songs
test.sound<-h5read("testsong1.h5", "/analysis")

dest <- read.csv('sample_submission.csv')
test.filenames <- dest[1:100,]$dat2.track_id
test.filenames <-paste(test.filenames,".h5", sep='')

for (i in 1:length(test.filenames))
{
  test.sound[[i]]<-h5read(test.filenames[i], "/analysis") 
  i=i+1
}

#call build.features function to build features for test data
test.music <- build.features(filenames = test.filenames, sound = test.sound)
X0 <- test.music
x0 <- matrix(unlist(X0), nrow=100)

#fit model and get topics
test.topics <- round(predict(xgb_fit,x0));test.topics
      
#associate topics to lyrics
test.names <- as.vector(dest[1:100,]$dat2.track_id)
test.file.topic <- as.data.frame(cbind(test.names,test.topics))

#merge topics to find lyrics
topic.index <-read.csv("C:/Users/Mengya/Desktop/Columbia Desk/GR5243/Fall2016-proj4-mz2593/output/topicindex.csv")
test.index <-matrix(unlist(topic.index), nrow=5001)[ ,2:51]
dim(test.index)

dim(test.file.topic)


for (i in 1:100){
  dest[i,2:5002] <- t(as.matrix( test.index[ ,test.file.topic$test.topics[i]] ))
}

write.csv(dest, file = "C:/Users/Mengya/Desktop/Columbia Desk/GR5243/Fall2016-proj4-mz2593/testresult.csv")
