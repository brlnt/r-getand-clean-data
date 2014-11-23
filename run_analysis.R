##
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

# Assuming data is extraced into "UCI HAR Dataset/" folder.

## 1. Merged the training and the test sets to create one data set.


# merge xs
train_x <- read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE);
test_x <- read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE);
merged_x <- rbind(train_x, test_x);

# non need for train & test data anymore
rm(train_x,test_x);


# merge ys
train_y <- read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE);
test_y <- read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE);
merged_y <- rbind(train_y, test_y);

# non need for train & test data anymore
rm(train_y,test_y);

# merge subjects
train_subj <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE);
test_subj <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE);
merged_subj <- rbind(train_subj, test_subj);

# non need for train & test data anymore
rm(train_subj,test_subj);

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

activity_labels <- read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE);
features <- read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE);

cols_to_extract <- grep(".*mean.*|*std.*", features[,2]);

# replace col names with corresponding feature names
extract_data <- merged_x [,cols_to_extract];


colnames(extract_data) <- features[cols_to_extract, 2];

## 3. Uses descriptive activity names to name the activities in the data set

merged_y$activity<-activity_labels[merged_y$V1,2];

## 4. Appropriately labels the data set with descriptive variable names some of it is already done

colnames(merged_subj) <- c("subject")

combined <- cbind(extract_data,merged_y,merged_subj);

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

tidy_data <- aggregate(combined, by=list(activity = combined$activity, subject=combined$subject), mean) 
   
write.table(tidy_data, file = "./tidy_data.txt", row.name=FALSE )