setwd("C:/Users/mxu/Desktop/R/UCI HAR Dataset")
library(reshape2)

#read in test data
X_test <- read.table("C:/Users/mxu/Desktop/R/UCI HAR Dataset/test/X_test.txt", quote="\"")
features <- read.table("C:/Users/mxu/Desktop/R/UCI HAR Dataset/features.txt", quote="\"")
subject_test <- read.table("C:/Users/mxu/Desktop/R/UCI HAR Dataset/test/subject_test.txt", quote="\"")
y_test <- read.table("C:/Users/mxu/Desktop/R/UCI HAR Dataset/test/y_test.txt", quote="\"")

##read in train data
X_train <- read.table("C:/Users/mxu/Desktop/R/UCI HAR Dataset/train/X_train.txt", quote="\"")
subject_train <- read.table("C:/Users/mxu/Desktop/R/UCI HAR Dataset/train/subject_train.txt", quote="\"")
y_train <- read.table("C:/Users/mxu/Desktop/R/UCI HAR Dataset/train/y_train.txt", quote="\"")



##grep the feature with mean and std
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)
##subset the data
subset<-X_test[featuresWanted]
combine_test<-cbind(subject_test,y_test,subset)
colnames(combine_test)<- c("subject", "activity", featuresWanted.names)

subset_train<-X_train[featuresWanted]
combine_train<-cbind(subject_train,y_train,subset_train)
colnames(combine_train)<- c("subject", "activity", featuresWanted.names)

full_date<-rbind(combine_train,combine_test)
activity_labels <- read.table("C:/Users/mxu/Desktop/R/UCI HAR Dataset/activity_labels.txt", quote="\"")
colnames(activity_labels)<-c("activity","activityName")

full_date$activity<-as.factor(full_date$activity)
## join activity file to get full activity name
with_activity<-merge(full_date,activity_labels,by="activity")

with_activity$activityName<-as.factor(with_activity$activityName)
with_activity$subject<-as.factor(with_activity$subject)
##using melt function to get wide format to long. 
with_activity.melted <- melt(with_activity, id.vars = c("subject", "activityName","activity"))
##calculate the mean by activity, subject
agg<-aggregate(value~subject+activityName+activity+variable, data=with_activity.melted,mean)
##write out tidy data
write.table(agg,"tidy.txt")
