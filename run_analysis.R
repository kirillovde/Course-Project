#library(data.table)

files <- c("test/y_test.txt", "train/y_train.txt",
           "test/subject_test.txt", "train/subject_train.txt",
           "test/X_test.txt", "train/X_train.txt",
           "features.txt", "activity_labels.txt")

X <- rbindlist(lapply(files[5:6], read.table, colClasses = "numeric"))
y <- rbindlist(lapply(files[1:2], fread))
subject <- rbindlist(lapply(files[3:4], fread))
features<- fread(files[7])
activity_labels <- fread(files[8])

# binding all data into one dataset
X[, `:=` (Activity = y[[1]], Subject = subject[[1]])]
setcolorder(X, c(562, 563, 1:561))
setnames(X, c("Activity", "Subject", features[[2]]))

# subsetting only mean and std columns
X<- X[, like(colnames(X), "(.*)Activity|Subject|mean|std(.*)"), with = F]
setkey(X, Activity)

# adding descriptive column names
ActivityLabel <- merge(y, activity_labels, by = "V1")
X <- cbind(ActivityLabel[, V2], X)
X[, `:=`(Activity = V1, V1 = NULL)]
setkey(X, Activity, Subject)

# creating tidy dataset in .txt file
write.table(X[, lapply(.SD, mean), by = c("Activity", "Subject")], "./tidyset.txt", 
            row.name = F) 
