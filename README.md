# Project: Words 4 Music

### [Project Description](doc/Project4_desc.md)

![image](http://cdn.newsapi.com.au/image/v1/f7131c018870330120dbe4b73bb7695c?width=650)

Term: Fall 2016

+ [Data link](https://courseworks2.columbia.edu/courses/11849/files/folder/Project_Files?preview=763391)-(**courseworks login required**)
+ [Data description](doc/readme.html)
+ Contributor's name: Mengya Zhao mz2593
+ Projec title: Association mining of music and text
+ Project summary: In this project, we associated music features to lyrics of a song so that predict possible words rank given some features of a song. However instead of directly regressing music features to rank thousands of words, we used “Topic Modeling” as tool to help connect features to words. The working flow is as follow:
	1.Extract Music Features. Using loop and expressions to read and load song 2350 documents, 16 music features with various dimensions were extracted for each song. [file: lib/Sound.R]
	2.Use LDA to group 5001 key words. Here I made two steps to group key words into topics. First select relatively best-fit parameter “topic numbers” through maximum likelihood. Then use this topic number as parameter in LDA model and group key words into 50 topics by LDA in the end.[file: lib/topics.R]
	3.Use xgboost model to regress topics on music features. Applied cross-validation to find better parameter then train xgboost model to associate music features to topics, data classification. [file: lib/model.R] 
	4.Test Data. Repeat the data extraction process like we did to train dataset, then get music features for test data. Use our train model in step 3 to predict the most likely topic for each song, the return to the associated key words rank.[file: test. R and restresult.cvs]

	
Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
