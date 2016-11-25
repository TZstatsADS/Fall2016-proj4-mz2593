source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")
library(rhdf5)
setwd('C:/Users/Mengya/Desktop/Columbia Desk/GR5243/4DATA/ALL')

#read files and extract features from 2350 songs
sound<-h5read("TRAAABD128F429CF47.h5", "/analysis")
filenames <- lyr[,1]
filenames <-paste(filenames,".h5", sep='')

for (i in 1:length(filenames))
{
  sound[[i]]<-h5read(filenames[i], "/analysis") 
  i=i+1
}

save(sound,file = "C:/Users/Mengya/Desktop/Columbia Desk/GR5243/Fall2016-proj4-mz2593/output/Sound.Rdata")

music <- matrix( nrow = length(filenames), ncol = 16)
colnames(music) <- as.vector(names(sound[[1]]))
rownames(music) <- as.vector(filenames)

#for (i in 1: length(filenames)){
#  for (j in 1:16){
#  music[i,j] <- sound[[i]][j]
#  }
#}

#X = music


build.features <- function(filenames, sound){

#build feature matrics
bars_confi1  <- vector("list", length = length(filenames))
bars_start2  <-vector("list", length = length(filenames))
beats_confi3 <- vector("list", length = length(filenames))
beats_start4 <- vector("list", length = length(filenames))
sec_confi5 <- vector("list", length = length(filenames))
sec_start6 <- vector("list", length = length(filenames))
seg_confi7 <- vector("list", length = length(filenames))
loud_max8 <- vector("list", length = length(filenames))
loud_max_time9 <- vector("list", length = length(filenames))
loud_start10 <- vector("list", length = length(filenames))
pitches11 <- vector("list", length = length(filenames))
start12 <- vector("list", length = length(filenames))
timbre13 <- vector("list", length = length(filenames))
#songs14
tatums_confi15 <- vector("list", length = length(filenames))
tatums_start16 <- vector("list", length = length(filenames))

for (i in 1:length(filenames)){
  bars_confi1[[i]] <- sound[[i]]$bars_confidence
  bars_start2[[i]] <- sound[[i]]$bars_start
  beats_confi3[[i]] <- sound[[i]]$beats_confidence
  beats_start4[[i]] <- sound[[i]]$beats_start
  sec_confi5[[i]] <- sound[[i]]$sections_confidence
  sec_start6[[i]] <- sound[[i]]$sections_start
  seg_confi7[[i]] <- sound[[i]]$segments_confidence
  loud_max8[[i]] <- sound[[i]]$segments_loudness_max
  loud_max_time9[[i]] <- sound[[i]]$segments_loudness_max_time
  loud_start10[[i]] <- sound[[i]]$segments_loudness_start
  pitches11[[i]] <- sound[[i]]$segments_pitches
  start12[[i]] <- sound[[i]]$segments_start
  timbre13[[i]] <- sound[[i]]$segments_timbre
  #songs14
  tatums_confi15[[i]] <- sound[[i]]$tatums_confidence
  tatums_start16[[i]] <- sound[[i]]$tatums_start
}

feature1 <- vector(length = length(filenames))
feature2 <- vector(length = length(filenames))
feature3 <- vector(length = length(filenames))
feature4 <- vector(length = length(filenames))
feature5 <- vector(length = length(filenames))
feature6 <- vector(length = length(filenames))
feature7 <- vector(length = length(filenames))
feature8 <- vector(length = length(filenames))
feature9 <- vector(length = length(filenames))
feature10 <- vector(length = length(filenames))
feature11 <- vector(length = length(filenames))
feature12 <- vector(length = length(filenames))
feature13 <- vector(length = length(filenames))
feature15 <- vector(length = length(filenames))
feature16 <- vector(length = length(filenames))

for (i in 1:length(filenames)){
feature1[i]<- mean(bars_confi1[[i]]) 
feature2[i]<-  mean(bars_start2[[i]]) 
feature3[i]<-  mean(beats_confi3[[i]]) 
feature4[i]<-  mean(beats_start4[[i]]) 
feature5[i]<-  mean(sec_confi5[[i]]) 
feature6[i]<-  mean(sec_start6[[i]]) 
feature7[i]<-  mean(seg_confi7[[i]]) 
feature8[i]<-  mean(loud_max8[[i]]) 
feature9[i]<-  mean(loud_max_time9[[i]]) 
feature10[i]<- mean(loud_start10[[i]]) 
feature11[i]<- mean(pitches11[[i]]) 
feature12[i]<- mean(start12[[i]]) 
feature13[i]<- mean(timbre13[[i]]) 
#songs14
feature15[i]<-  mean(tatums_confi15[[i]]) 
feature16[i]<-  mean(tatums_start16[[i]]) 
}

musicdata<-as.data.frame(cbind(feature1,feature2,feature3,feature4,feature5,feature6,feature7,
                    feature8,feature9,feature10,feature11,feature12,feature13,feature15,feature16))
return(musicdata)

}

musicdata <- build.features(filenames=lyr[,1], sound)
rownames(musicdata) <- lyr[,1]
#save feature matrix
write.csv(musicdata, file="C:/Users/Mengya/Desktop/Columbia Desk/GR5243/Fall2016-proj4-mz2593/output/musicdata.csv" )
#save build.features function
save(build.features, file = "C:/Users/Mengya/Desktop/Columbia Desk/GR5243/Fall2016-proj4-mz2593/output/buildfeatures.Rdata")


