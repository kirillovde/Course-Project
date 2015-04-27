library(data.table)

# reading files
features<- fread("features.txt")
activity_labels<- fread("activity_labels.txt")
subject_test<- fread("test/subject_test.txt")
subject_train<- fread("train/subject_train.txt")
y_test<- fread("test/y_test.txt")
y_train<- fread("train/y_train.txt")
# i had to stick with setDT(read.table()) because fread() doesn't work correctly
X_test<- setDT(read.table("test/X_test.txt", colClasses = "numeric"))
X_train<- setDT(read.table("train/X_train.txt", colClasses = "numeric"))

#binding test and train data
X<- rbind(X_test, X_train)
y<- rbind(y_test, y_train)
subject<- rbind(subject_test, subject_train)

#binding all data into one dataset
X<- cbind(y, subject, X)
colnames(X)=c("Activity", "Subject", features[["V2"]])
# subsetting only mean and std columns
X<- X[,like(colnames(X),"(.*)Activity|Subject|mean|std(.*)"), with = F]
setkey(X, Activity)

# adding descriptive column names
ActivityLabel<- merge(y, activity_labels, by = "V1")
X<- cbind(ActivityLabel[,V2], X)
X[,`:=`(Activity = V1, V1= NULL)]
setkey(X, Activity, Subject)

# creating tidy dataset in .txt file
write.table(X[,lapply(.SD, mean), by = c("Activity", "Subject")], "./tidyset.txt", row.name=F)

