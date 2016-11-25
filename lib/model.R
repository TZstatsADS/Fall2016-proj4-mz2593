

setwd("C:/Users/Mengya/Desktop/Columbia Desk/GR5243/Fall2016-proj4-mz2593")
load('data/lyr.Rdata')
load('output/Sound.Rdata')
install.packages(data.table)
library(data.table)
install.packages("xgboost")
library(xgboost)


X  <- read.csv("output/musicdata.csv")
col<-colnames(X)
dim(X)
X <-matrix(unlist(X), nrow=2350, ncol = 16)
rownames(X) <-lyr[,1]
colnames(X) <- col
X <- X[ , 2:16]
dim(X)

y = read.csv("output/Y.csv")
dim(y)
y <- as.numeric(y$topic)
length(y)

dtrain<-xgb.DMatrix(data = X,label = y, missing=NaN)
best_param = list()
best_seednumber = 1234
best_err = Inf
best_err_index = 0
cv.result = data.frame(shk1=I(list()),shk2=I(list()),shk3=I(list()),shk4=I(list()),shk5=I(list()))
shrinkage = seq(0.1,0.15,0.5)

for (d in 6:10) {
  for(e in 1:5){
    try.maxdph = d
    try.eta = shrinkage[e]
    param <- list(max_depth = try.maxdph,
                  eta = try.eta
    )
    cv.nround = 1000
    cv.nfold = 5
    seed.number = sample.int(10000, 1)[[1]]
    set.seed(seed.number)
    cat("d=",d,"e=",e,'\n')
    mdcv <- xgb.cv(data=dtrain, params = param, nthread=6, 
                   nfold=cv.nfold, nrounds=cv.nround,
                   verbose = 0, early.stop.round=8, maximize=FALSE)
    min_err = min(mdcv[, test.rmse.mean])
    min_err_index = which.min(mdcv[, test.rmse.mean])
    cv.result[[d-5,e]] = list(min_err,min_err_index)
    if (min_err < best_err) {
      best_err = min_err
      best_err_index = min_err_index
      best_seednumber = seed.number
      best_param = param
    }
  }
}    

save(cv.result,file="C:/Users/Mengya/Desktop/Columbia Desk/GR5243/Fall2016-proj4-mz2593/output/cv_xgb_result.RData")
xgb_best<-data.frame(best_err,best_err_index,best_seednumber,best_param)
save(xgb_best,file="C:/Users/Mengya/Desktop/Columbia Desk/GR5243/Fall2016-proj4-mz2593/output/xgb_best.RData")


nround = best_err_index
set.seed(best_seednumber)

xgb_fit<- xgb.train(data=dtrain, params=best_param, nrounds=nround)
xgb_fit

save(xgb_fit,file="C:/Users/Mengya/Desktop/Columbia Desk/GR5243/Fall2016-proj4-mz2593/output/xgb_fit.RData")

all(round(predict(xgb_fit,X, missing=NaN))<=50)



