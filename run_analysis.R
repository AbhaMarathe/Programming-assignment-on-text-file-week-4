#reading the data
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
#merging the data
x1 <- rbind(x_train, x_test)
y1<- rbind(y_train, y_test)
final<- rbind(subject_train, subject_test)
d1<- cbind(final, y1, x1)

# Extracts only the measurements on the mean and standard deviation for each measurement.
t1<-d1 %>% select(subject, code, contains("mean"), contains("std"))

#Uses descriptive activity names to name the activities in the data set
t1$code <- activities[t1$code, 2]

#Appropriately labels the data set with descriptive variable names. 

names(t1)[2] = "activity"
names(t1)<-gsub("Acc", "Accelerometer", names(t1))
names(t1)<-gsub("Gyro", "Gyroscope", names(t1))
names(t1)<-gsub("BodyBody", "Body", names(t1))
names(t1)<-gsub("^f", "Frequency", names(t1))
names(t1)<-gsub("tBody", "TimeBody", names(t1))
names(t1)<-gsub("-mean()", "Mean", names(t1), ignore.case = TRUE)
names(t1)<-gsub("-std()", "STD", names(t1), ignore.case = TRUE)
names(t1)<-gsub("-freq()", "Frequency", names(t1), ignore.case = TRUE)
names(t1)<-gsub("angle", "Angle", names(t1))
names(t1)<-gsub("gravity", "Gravity", names(t1))
names(t1)<-gsub("Mag", "Magnitude", names(t1))
names(t1)<-gsub("^t", "Time", names(t1))

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
df1 <- t1 %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(df1, "df1.txt", row.name=FALSE)

