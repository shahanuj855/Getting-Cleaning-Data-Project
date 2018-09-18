fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL,"./UCI HAR Dataset.zip")
unzip("UCI HAR Dataset.zip",exdir = getwd())

#Creating data frames for testing and training
library(data.table)
features <- read.csv('./UCI HAR Dataset/features.txt', header = FALSE,sep = ' ')
features <- as.character(features[,2])

traindata_x <- read.table('./UCI HAR Dataset/train/X_train.txt')
traindata_activity <- read.csv('./UCI HAR Dataset/train/y_train.txt',header = FALSE,sep = ' ')
traindata_subject <- read.csv('./UCI HAR Dataset/train/subject_train.txt',header = FALSE,sep = " ")

train_data <- data.frame(traindata_subject,traindata_activity,traindata_x)
names(train_data) <- c(c('subject','activity'),features)

testdata_x <- read.table('./UCI HAR Dataset/test/X_test.txt')
testdata_activity <- read.csv('./UCI HAR Dataset/test/y_test.txt',header = FALSE,sep = ' ')
testdata_subject <- read.csv('./UCI HAR Dataset/test/subject_test.txt',header = FALSE,sep = ' ')

test_data <- data.frame(testdata_subject, testdata_activity, testdata_x)
names(test_data) <- c(c('subject','activity'),features)

data.all <- rbind(train_data,test_data) #merge the training and testing dataset

sub_meanStd <- grep('mean|std',features)
sub_data <- data.all[,c(1,2,sub_meanStd + 2)]

activity.labels <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)
activity.labels <- as.character(activity.labels[,2])
data.sub$activity <- activity.labels[data.sub$activity]

name.new <- names(sub_data)
name.new <- gsub("[(][)]", "", name.new)
name.new <- gsub("^t", "TimeDomain_", name.new)
name.new <- gsub("^f", "FrequencyDomain_", name.new)
name.new <- gsub("Acc", "Accelerometer", name.new)
name.new <- gsub("Gyro", "Gyroscope", name.new)
name.new <- gsub("Mag", "Magnitude", name.new)
name.new <- gsub("-mean-", "_Mean_", name.new)
name.new <- gsub("-std-", "_StandardDeviation_", name.new)
name.new <- gsub("-", "_", name.new)
names(sub_data) <- name.new

data.tidy <- aggregate(sub_data[,3:81], by = list(activity = sub_data$activity, subject = sub_data$subject),FUN = mean)
write.table(x = data.tidy, file = "data_tidy.txt", row.names = FALSE)
