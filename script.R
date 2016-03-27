library(plyr)

# Getting data
x_test <- read.table("./data/test/X_test.txt")
y_test <- read.table("./data/test/y_test.txt")
sj_test <- read.table("./data/test/subject_test.txt")
x_train <- read.table("./data/train/X_train.txt")
y_train <- read.table("./data/train/y_train.txt")
sj_train <- read.table("./data/train/subject_train.txt")
features <- read.table("./data/features.txt")[,2]
names(x_test) <- features
names(x_train) <- features
act_label <- read.table("./data/activity_labels.txt")
names(act_label) <- c("label", "activity")


# Cleaning data
extracted_features <- grep("mean|std", features)
x <- rbind2(x_train[, extracted_features], x_test[, extracted_features])

y <- rbind2(y_train, y_test)
names(y) <- "label"
sj <- rbind2(sj_train, sj_test)
names(sj) <- "subject"
act <- inner_join(y, act_label)
activity <- as.data.frame(act[,2])
names(activity) <- "activity"
data <- cbind2(c(sj, activity), x)

# Table summarise by subject and activity
data_summarise <- data %>% group_by(subject, activity) %>% summarise_each(funs(mean))

# Export data
write.csv(data, file = "data.csv")
write.csv(data_summarise, file= "data_summarise.csv")
