args=commandArgs(T)
print(args[1])
workspace = args[1]


Run_one_sample_step_two <- function(workspace){
	group_ID_Path = paste0(workspace,'/group_out.txt')
	group_ID_Table <- read.delim(group_ID_Path, header = F)
	ID_input_Data <- paste0(workspace, '/PeakTable-Annotated_v1.txt')
	Input_Data <- read.delim(ID_input_Data)
	out_group_list <-c(1:length(Input_Data[,1]))
	for(i in c(1:length(Input_Data[,1]))){
		group_str <- as.character(Input_Data[i,2])
		if(sum(group_ID_Table[,2]==group_str)>0){
			group_use <- group_ID_Table[which(group_ID_Table[,2]==group_str),]
			gourp_use_ID <- group_use[1,1]
			out_group_list[i] <- gourp_use_ID
		}else{
			out_group_list[i] <- 'Other'
		}
	}
	Input_Data$Binner <- out_group_list
	Out_Path <- paste0(workspace,'/idresults_v2.csv')
	print(Out_Path)
	#mgf_file_path <- paste0(mgf_path, '/idresults_v2.csv')
	write.csv(Input_Data, Out_Path, quote= T, row.names = F)
	
}

#workspace = '/Media/E/zhangpeng/Project_SAM_test/POS_mzXML/'

Run_one_sample_step_two(workspace)





