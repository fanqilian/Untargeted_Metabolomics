args=commandArgs(T)
print(args[1])

workspace = args[1]


RSD_cal_function <- function(x){
        mean_num = mean(x)
        sd_num = sd(x)#^0.5
        return(sd_num/mean_num)
}

Run_one_sample <- function(workspace){
	ID_input_Data <- paste0(workspace, '/PeakTable-Annotated.csv')
	ID_output_Data <- paste0(workspace,'/PeakTable-Annotated_v1.txt')
	Group_Data <- paste0(workspace,'/Group_ID.txt')
	Input_Data <- read.csv(ID_input_Data)
	#sample_begin = 12
	#sample_end = sample_begin + ID_size -1
	Group_File_Input = read.delim(Group_Data)
	Group_ID = as.vector(Group_File_Input[,1])
	Sample_Data <- Input_Data[,which(colnames(Input_Data)%in%Group_ID)]
	one_RSD <- c(1:length(Sample_Data[,1]))
	one_Mean <- c(1:length(Sample_Data[,1]))
	for(i in c(1:length(Sample_Data[,1]))){
		one_list <- as.vector(unlist(Sample_Data[i,]))
		one_RSD[i] <- RSD_cal_function(one_list)
		one_Mean[i] <- mean(one_list)
	}
	Input_Data$RSD <- one_RSD
	Input_Data$Mean <- one_Mean
	write.table(Input_Data, ID_output_Data, sep='\t',quote = F, row.names = F, col.names = T)
}



#workspace = '/Media/E/zhangpeng/Project_SAM/POS_mzXML'

Run_one_sample(workspace)





