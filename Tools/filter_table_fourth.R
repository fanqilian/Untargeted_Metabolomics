library(stringr)
library(openxlsx)
#print(head(Data_F7))

args=commandArgs(T)
print(args[1])
Workspace = args[1]


Filter_adduct_i <- function(Data_F7){
	Filter_adduct_i_list <- c(1:length(1:length(Data_F7[,1])))
	Filter_fourty_in_list <- c(1:length(1:length(Data_F7[,1])))
	FIlter_PPM_feature_name_list <- c(1:length(1:length(Data_F7[,1])))
	Filter_intersity_list <- c(1:length(1:length(Data_F7[,1])))
	Adduct_i_list <- Data_F7$Out_Precursor_Type
	Fourty_in_list <- Data_F7$rtmed
	PPM_Feature_name_list <- Data_F7$Out_Ref_Name
	Means_list <- Data_F7$Mean
	Out_ppm_list <- Data_F7$Out_ppm
	#Out_Ref_Name
	for(i in c(1:length(Data_F7[,1]))){
		one_str = as.character(Adduct_i_list[i])
		one_rt = Fourty_in_list[i]
		if(is.na(sum(str_detect(one_str, 'i')))){
			s = 1
			Filter_adduct_i_list[i] <- 'PASS'
		}else{
			if(str_detect(one_str, 'i')){
				Filter_adduct_i_list[i] <- 'Fliter'
			}else{
				Filter_adduct_i_list[i] <- 'PASS'
			}
		}
		if(one_rt < 40){
			Filter_fourty_in_list[i] <- 'Filter'
		}else{
			Filter_fourty_in_list[i] <- 'PASS'
		}
		if(is.na(PPM_Feature_name_list[i])){
			if(as.numeric(Means_list[i]) < 5E7){
				Filter_intersity_list[i] <- 'Filter'
			}else{
				Filter_intersity_list[i] <- 'PASS'
			}
			FIlter_PPM_feature_name_list[i] <- 'PASS'
		}else{
			#print(PPM_Feature_name_list[i])
			#print(as.numeric(Means_list[i]))
			if(as.numeric(Means_list[i]) < 4E6){
				Filter_intersity_list[i] <- 'Filter'
            }else{
                Filter_intersity_list[i] <- 'PASS'
            }
			if(Out_ppm_list[i]>15){
				if(Means_list[i]> 30000000){
					FIlter_PPM_feature_name_list[i] <- 'feature_name_filter'
				}else{
					FIlter_PPM_feature_name_list[i] <- 'Filter'
				}
			}else{
				FIlter_PPM_feature_name_list[i] <- 'PASS'
			}
		}
	}
	Data_F7$Adduct_i_list = Filter_adduct_i_list
	Data_F7$Filter_fourty_in_list = Filter_fourty_in_list
	Data_F7$FIlter_PPM_feature_name_list = FIlter_PPM_feature_name_list
	Data_F7$Filter_intersity_list = Filter_intersity_list
	#print(table(Filter_adduct_i_list))
	#print(table(Filter_fourty_in_list))
	#print(table(FIlter_PPM_feature_name_list))
	print(table(Filter_intersity_list))
	Data_F8 = Data_F7[-which(Data_F7$Adduct_i_list=='Filter'|Data_F7$Filter_fourty_in_list=='Filter'|Data_F7$FIlter_PPM_feature_name_list=='Filter'),]
	return(Data_F8)
}

Filter_Group <- function(Data_F8, feature_ID){
	ID_vector <- as.vector(feature_ID[,1])
	Data_F9 = Data_F8[-which(Data_F8[,2]%in%ID_vector), ]
	
}

summary_refname <- function(Data_F9){
	summary_table <- data.frame(table(Data_F9$Out_Ref_Name))
	summary_table_use <- summary_table[which(summary_table[,2]>1),]
	print(summary_table_use)
	print(Data_F9[which(Data_F9$Out_Ref_Name%in%as.vector(summary_table_use[,1])),c(1:20)])
}

filter_time <- function(Data_F9){
	Data_F10 <- Data_F9#[-which(Data_F9$rtmed > 2500),]
	Data_F11 <- Data_F10[-which(Data_F10$rtmed < 60 & Data_F10$Ref_Name==''),]
	return(Data_F11)
}


filter_fourth <- function(Workspace){
	input_data_path = paste0(Workspace, '/MGF_WORK_quali_quant_v6.csv')
	Input_Data_Path_v8 = paste0(Workspace, '/MGF_WORK_quali_quant_v8.csv')
	Input_Data_Path_v11 = paste0(Workspace, '/MGF_WORK_quali_quant_v11.csv')
	Input_Data_Path_xlsx_v11 = paste0(Workspace, '/MGF_WORK_quali_quant_v11.xlsx')
	Data_F7 = read.csv(input_data_path)
	Data_F8 = Filter_adduct_i(Data_F7)
	Data_F9 = Data_F8
	Data_F11 = filter_time(Data_F9)
	write.table(Data_F8, Input_Data_Path_v8, sep=',',quote = T, row.names = F)
	write.table(Data_F11, Input_Data_Path_v11, sep=',',quote = T, row.names = F)
	write.xlsx(Data_F11, file = Input_Data_Path_xlsx_v11)
}



#Data_F7 = read.csv('E:/项目/中药文章/SAM/NEG/SAM_NEG_quali_quant_v1.csv')
#Data_F8 = Filter_adduct_i(Data_F7)
#Data_F9 = Data_F8
#Data_F11 = filter_time(Data_F9)
#write.csv(Data_F11, 'E:/项目/中药文章/SAM/NEG/SAM_NEG_quali_quant_v2.csv', row.names = F)
filter_fourth(Workspace)



