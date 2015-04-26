# y_test.txt, y_train.txt - activity factor (length 2947), 
# activity_labels.txt - activity factor levels (6 levels)
# 
# features.txt - 561 features
# 
# subject_train.txt (7352), subject_test.txt (2947) - Each row identifies the subject 
# who performed the activity for each window sample. Its range is from 1 to 30. 

library(data.table)

features<- fread("features.txt")
activity_labels<- fread("activity_labels.txt")
subject_test<- fread("test/subject_test.txt")
subject_train<- fread("train/subject_train.txt")
y_test<- fread("test/y_test.txt", colClasses = "character")
y_train<- fread("train/y_train.txt", colClasses = "character")

X_test<- setDT(read.table("test/X_test.txt", colClasses = "numeric"))
X_train<- setDT(read.table("train/X_train.txt", colClasses = "numeric"))

X_test<- cbind(y_test ,subject_test, X_test)
rm(y_test,subject_test)

X_train<- cbind(y_train, subject_train, X_train)
rm(y_train,subject_train)

X<- rbind(X_test, X_train)
rm(X_test, X_train)

colnames(X)=c("V1", "Subject", features[["V2"]])
rm(features)
colnames(activity_labels)=c("V1","Activity")

setkey(X, V1)
setkey(activity_labels, V1)

X[activity_labels, V1:=Activity]
