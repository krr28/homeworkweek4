## Merges the training and the test sets to create one data set.
##   
library(reshape2)

## Download and unzip data
if (!file.exists("getdata_dataset.zip")){
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "dataset.zip", method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip("dataset.zip") 
}
## Read in the training and test labels and data sets with only mean and standard deviation

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

feature_index <- grep("*mean*|*std*", features[,2])

## Make the names more readable with descriptive activities
feature_names <- features[feature_index,2]
feature_names = gsub('mean', 'Mean', feature_names)
feature_names = gsub('std', 'Std', feature_names)
feature_names <- gsub('[()-]', '', feature_names)

## read in the datasets with only the features needed

X_train <- read.table("UCI HAR Dataset/train/X_train.txt")[feature_index]
Y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(subject_train, Y_train, X_train)

X_test <- read.table("UCI HAR Dataset/test/X_test.txt")[feature_index]
Y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(subject_test, Y_test, X_test)

## put it all in one table with the descriptive labels

TidyData <- rbind(train, test)
colnames(TidyData) <- c("Subject", "Activity", feature_names)

## Appropriately labels the data set with descriptive variable names.

TidyData$Activity <- factor(TidyData$Activity, levels = activity_labels[,1], labels = activity_labels[,2])
TidyData$Subject <- as.factor(TidyData$Subject)

## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

TidyData_melted <- melt(TidyData, id = c("Subject", "Activity"))
TidyData_mean <- dcast(TidyData_melted, Subject + Activity ~ variable, mean)

write.table(TidyData.mean, "TidyData.txt", row.names = FALSE, quote = FALSE)