setwd("C:\\Users\\VHUANG\\Desktop\\My files\\Coursera\\2 Getting and Cleaning Data\\Project")

# Load activity data
# Load activity labels in TXT
activity_label<-as.vector(read.table("./UCI HAR Dataset/activity_labels.txt",,header=FALSE)[,2])
activity_label


# Load features in TXT
features<-read.table("./UCI HAR Dataset/features.txt",,header=FALSE)
dim(features)

# Load Test -> X
test.X<-read.table("./UCI HAR Dataset/test/X_test.txt",,header=FALSE)
dim(test.X)

# Load Test -> Y
test.Y<-read.table("./UCI HAR Dataset/test/Y_test.txt",,header=FALSE)
dim(test.Y)

test.Y[,2]=activity_label[test.Y[,1]]

# Load Test -> subject_test
test.subject<-read.table("./UCI HAR Dataset/test/subject_test.txt",,header=FALSE)
dim(test.subject)

# Load train -> X
train.X<-read.table("./UCI HAR Dataset/train/X_train.txt",,header=FALSE)
dim(train.X)

# Load Train -> Y
train.Y<-read.table("./UCI HAR Dataset/train/Y_train.txt",,header=FALSE)
dim(train.Y)

train.Y[,2]=activity_label[train.Y[,1]]

# Load Train -> subject_train
train.subject<-read.table("./UCI HAR Dataset/train/subject_train.txt",,header=FALSE)
dim(train.subject)

# Combine Test dataset
test<-cbind(test.Y,test.subject,test.X)
dim(test)

names(test)<- c("Activity_ID","Activity_Label","Subject",as.vector(features[,2]))

# Combine Train dataset
train<-cbind(train.Y,train.subject,train.X)
dim(train)

names(train)<- c("Activity_ID","Activity_Label", "Subject",as.vector(features[,2]))

# See if the feature contains "mean" or "std"
extract_features<-grepl("mean|std",features[,2])

# Get Test columns only for features containing "mean" or "std"
test_select<-test[,c(TRUE,TRUE,TRUE,extract_features)]

# Get Train columns only for features containing "mean" or "std"
train_select<-train[,c(TRUE,TRUE,TRUE, extract_features)]

# Stack test and train data
data=rbind(test_select,train_select)
dim(data)
names(data)

# Create a second, independent tidy data set with the average of each variable for each activity and each subject
id_labels=c("Activity_ID","Activity_Label","Subject")
measure_labels=setdiff(names(data),id_labels)

library(reshape2)
LongTable<-melt(data,id=id_labels,measure.vars=measure_labels)
TidyData<-dcast(LongTable,Activity_ID + Activity_Label + Subject~variable,mean)

head(TidyData)

# Write table to TXT
write.table(TidyData,'TidyData.txt',sep="\t",row.name=FALSE)
