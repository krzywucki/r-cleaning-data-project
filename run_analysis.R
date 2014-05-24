#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive activity names.
#Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(plyr)

readFeatures <- function(featureFile){
    #reads all features
    tab <- read.table(featureFile, header=FALSE, sep=' ', stringsAsFactors=FALSE);
    allFeatures <<- tab[,2];

    #keep only those that pertain to mean or stdev
    filteredFeatures <<- allFeatures[grepl('mean|std', allFeatures)];

    #
    # Returns a vector af all feature names
    #
    getAll <- function() allFeatures

    #
    # Filter out those features that represent stdev or mean.
    #
    getFiltered <- function() filteredFeatures;

    list(getAll=getAll, getFiltered=getFiltered)
}


#
# Reads Y set from fileName and maps activity identifiers to activity names
# Returns a single column data frame with named activities.
readYSet <- function(fileName, labels){
   y_set <- read.table(fileName,  header=FALSE);
   names(y_set) <- c('id')
   y_set$activity_name <- labels[y_set$id,]$activity_name;
   subset(y_set, select='activity_name');
}


#
# Reads X set from fileName, uses features list to narrow down the columns to
#
readXSet <- function(fileName, features){
    set_x <- read.table(fileName,  header=FALSE);
    names(set_x) <- features$getAll();
    subset(set_x, select=features$getFiltered())
}

getLabels <- function(fileName){
    labels <- read.csv(fileName,  header=FALSE, sep=' ');
    names(labels) <- c('id', 'activity_name');
    labels
}

readSubjects <- function(fileName){
    subjects <- read.table(fileName,  header=FALSE);
    names(subjects) <- c('subject');
    subjects
}


# Computes an average for each measuement gropuping passed data frame
# by subject and activity name. Returns a data fame of the same length.
computeMeans <- function(df){
    ddply(df, .(subject,activity_name), colwise(mean))
}




features <- readFeatures('features.txt');
labels <- getLabels('activity_labels.txt');


test_x  <-readXSet('test/X_test.txt',   features);
train_x <-readXSet('train/X_train.txt', features);

test_y <- readYSet('test/Y_test.txt', labels);
train_y <- readYSet('train/Y_train.txt', labels);

train_subjects <- readSubjects('train/subject_train.txt');
test_subjects <- readSubjects('test/subject_test.txt');


# merge train data with test data
x <- rbind(test_x, train_x)
y <- rbind(test_y, train_y)
subjects <- rbind(train_subjects, test_subjects)

finalSet <- cbind(x, subjects, y)

write.table(finalSet, 'merged.txt', row.names=FALSE);


#
# Compute means for each variable grouping by activity and subject and save the result in a file.
#
rollup <-computeMeans(finalSet)
write.table(rollup, 'rollup.txt', row.names=FALSE);







