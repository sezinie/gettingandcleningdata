# 1. Merges the training and the test sets to create one data set.
x.train <- read.table("./train/X_train.txt")
x.test <-read.table("./test/X_test.txt")
x.merge <- rbind(x.train,x.test)
y.train <- read.table("./train/Y_train.txt")
y.test <- read.table("./test/Y_test.txt")
y.merge <- rbind(y.train,y.test)
subject.train <- read.table("./train/subject_train.txt")
subject.test <- read.table("./test/subject_test.txt")
subject.merge <- rbind(subject.train,subject.test)
# x.train  y.train  subject.train
# x.test   y.test   subject.test
# x.merge  y.merge  subject.merge

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

features <- read.table("features.txt", stringsAsFactors=F)[,2]
colnames(x.merge) <- features
subject = factor(subject.merge[,1])
x.subset=x.merge[,grep("std\\(\\)|mean\\(\\)",features)][1,]

# 3. Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table("activity_labels.txt", stringsAsFactors=F, col.names=c("classlabel","activityname"))
activity = factor(y.merge[,1], levels= activity_labels$classlabel,labels=activity_labels$activityname)

# 4. Appropriately labels the data set with descriptive activity names. 

features.sub = gsub("-",".",gsub("\\(\\)","",tolower(features[grep("std\\(\\)|mean\\(\\)",features)])))
colnames(x.subset) = features.sub
train_test.merge <- cbind(x.subset,subject,activity)

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

library(data.table)
dt<- data.table(train_test.merge)
averageData<- dt[, lapply(.SD, mean), by=c("subject", "activity")]
averageData<- averageData[order(averageData$subject),]

#Exporting data into a .txt file:
write.table(averageData, "averageData.txt", sep="\t",row.names=F)
