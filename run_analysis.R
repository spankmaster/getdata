library(tidyr)
library(dplyr)

###Merges the training and the test sets to create one data set.

train=read.table("train/X_train.txt")
test=read.table("test/X_test.txt")
df=rbind(train,test)

###Extracts only the measurements on the mean and standard deviation for each measurement. 

names=read.table("features.txt",sep="\t")
colnames(df)<-names$V1
x=tbl_df(df)
y=select(x,contains("-mean()"),contains("-std()"))

###Uses descriptive activity names to name the activities in the data set

train_lab=read.table("train/y_train.txt")
test_lab=read.table("test/y_test.txt")
lab=rbind(train_lab,test_lab)
colnames(lab)=c("activity")

lab[lab$activity==1,]<- "WALKING"
lab[lab$activity==2,]<- "WALKING_UPSTAIRS"
lab[lab$activity==3,]<- "WALKING_DOWNSTAIRS"
lab[lab$activity==4,]<- "SITTING"
lab[lab$activity==5,]<- "STANDING"
lab[lab$activity==6,]<- "LAYING"
lab<-tbl_df(lab)

y=cbind(y,lab)

###Appropriately labels the data set with descriptive variable names. 

train_sub=read.table("train/subject_train.txt")
test_sub=read.table("test/subject_test.txt")
rbind(train,test)
sub=rbind(train_sub,test_sub)
colnames(sub)<-c("subject")
y=cbind(y,sub)

###From the data set in step 4, creates a second, independent tidy data 
###set with the average of each variable for each activity and each subject.

temp=data.frame()
for (a in unique(y$activity)){
for (b in unique(y$subject)){
temp=rbind(temp, mutate(tbl_df(data.frame(t(colMeans(select(filter(y,activity==a,subject==b),1:66))))),activity=a,subject=b))
}
}

write.table(temp,"final.txt",row.name=FALSE)
