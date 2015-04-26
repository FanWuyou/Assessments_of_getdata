##get Columns name
data1 <- read.table("./a/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")
data1$V2<-as.character(data1$V2)
fac<-strsplit(data1$V2,"-")
way<-sapply(fac,"[",2)
data1<-cbind(data1[,1],data1[,2],way)
mean_std<-data1[((data1[,"way"] == "mean()")|(data1[,"way"] == "std()"))&!is.na(data1[,"way"]),]

##read
data2 <- read.table("./a/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
data3 <- read.table("./a/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
data4 <- read.table("./a/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
data5 <- read.table("./a/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
data6 <- read.table("./a/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
data7 <- read.table("./a/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

##Appropriately labels
colnames(data2) <- c(data1[,2])
colnames(data3) <- c(data1[,2])

##extracts
data2<-data2[,as.numeric(mean_std[,1])]
data3<-data3[,as.numeric(mean_std[,1])]

##cbind
data4<-cbind(data4,data6)
colnames(data4) <- c("subject","labele")
data5<-cbind(data5,data7)
colnames(data5) <- c("subject","labele")
data2 <- cbind(data4,data2)
data3 <- cbind(data5,data3)

##merge training and test
data8<-rbind(data2,data3)

##split-apply-combine
subj<-c()
for (i in 1:(length(mean_std[,1])+2)) subj <- cbind(subj,sapply(split(data8[,i],data8$subject),mean))
labe<-c()
for (i in 1:(length(mean_std[,1])+2)) labe <- cbind(labe,sapply(split(data8[,i],data8$labele),mean))

##creat tidy data set
subj[,2]=""
labe[,1]=""
anws = rbind(subj,labe)
colnames(anws) <- c("subject","labele",mean_std[,2])

##output
write.table(anws,"./Assessments_of_getdata/tidy_data.txt",row.name=FALSE)