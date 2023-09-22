library(stringr)
library(openxlsx)

args=commandArgs(T)
print(args[1])
workspace = args[1]



RSD_cal_function <- function(x){
        mean_num = mean(x)
        sd_num = sd(x)#^0.5
        return(sd_num/mean_num)
}


Filter_RSD_Int <- function(Input_Data){
	Input_Data_F = Input_Data[which(Input_Data$RSD <0.2 & Input_Data$Mean >2000000),]
	New_istope <- c(1:length(Input_Data_F[,1]))
	PPM_size <- c(1:length(Input_Data_F[,1]))
	PPM_min <- c(1:length(Input_Data_F[,1]))
	PPM_max <- c(1:length(Input_Data_F[,1]))
	ref_name <- c(1:length(Input_Data_F[,1]))
	for(i in c(1:length(Input_Data_F[,1]))){
		#print(i)
		#print(Input_Data_F$PPM[i])
		one_str = as.character(Input_Data_F$isotopes[i])
		#if(Input_Data_F$PPM[i]==''){
		#	ppm_list = c()
		#}else{
			ppm_list <- as.numeric(as.character(unlist(strsplit(as.character(Input_Data_F$PPM[i]), split = ";"))))
			if(Input_Data_F$Ref_Compound[i]==''){
				ref_name[i] <- ''
			}else{
				ref_list <- as.character(unlist(strsplit(as.character(Input_Data_F$Ref_Compound[i]), split = ";")))
				ref_name[i] <- ref_list[1]
			}
		#}
		PPM_size[i] <- length(ppm_list)
		if(length(ppm_list)==0){
			PPM_min[i] <- 0
			PPM_max[i] <- 0
		}else{
			PPM_min[i] <- min(ppm_list)
			PPM_max[i] <- max(ppm_list)
		}
		if(str_detect(one_str, 'M]\\+')|str_detect(one_str, 'M]\\-')|one_str==''){
			New_istope[i] <- 'Istope'
		}else{
			New_istope[i] <- 'Other'
		}
	}
	Input_Data_F$New_istope <- New_istope
	Input_Data_F$PPM_size <- PPM_size
	Input_Data_F$PPM_max <- PPM_max
	Input_Data_F$PPM_min <- PPM_min
	Input_Data_F$New_Ref <- ref_name
	Input_Data_F <- Input_Data_F[which(Input_Data_F$New_istope=='Istope'),]
	Input_Data_F <- Input_Data_F[which(Input_Data_F$rtmed > 30),]
	#print(dim(Input_Data_F))
	return(Input_Data_F)
}



Filter_feature_name_filter <- function(Input_Data_F1){
	all_feature_name = names(table(Input_Data_F1$name))
	for(i in c(1:length(all_feature_name))){
		one_feature_name = all_feature_name[i]
		one_part_data = Input_Data_F1[which(Input_Data_F1$name==one_feature_name),]
		#print(length(one_part_data[,1]))
		if(dim(one_part_data)[1]>1){
			one_part_data <- one_part_data[which.min(one_part_data$PPM_min),]
			#print(one_part_data)
		}
		if(i==1){
			all_part_data <- one_part_data
		}else{
			all_part_data <- rbind(all_part_data, one_part_data)
		}
	}
	return(all_part_data)
}




Filter_Non <- function(Input_Data_F2, Bin_with_out_message_list){
	Input_Data_F21 <- Input_Data_F2[which(Input_Data_F2$Binner%in%Bin_with_out_message_list),]
	#print(dim(Input_Data_F21))
	for(i in c(1:length(Bin_with_out_message_list))){
		One_Bin_ID = Bin_with_out_message_list[i]
		part_data = Input_Data_F21[which(Input_Data_F21$Binner==One_Bin_ID),]
		out_part_data = part_data[which.max(part_data$Mean),]
		if(i==1){
			all_out <- out_part_data
		}else{
			all_out <- rbind(all_out, out_part_data)
		}
	}
	return(all_out)
}

Filter_DB <- function(Input_Data_F2, Bin_with_message_list){
	Input_Data_F22 <- Input_Data_F2[which(Input_Data_F2$Binner%in%Bin_with_message_list),]
	#print(dim(Input_Data_F22))
	Non_DB_part <- Input_Data_F22[which(Input_Data_F22$Ref_Compound==''),]
	#print(dim(Non_DB_part))
	#print(head(Non_DB_part))
	Non_out_part <- Non_DB_part[which(Non_DB_part$Mean>50000000),]
	#DB_part <- Input_Data_F22[-which(Input_Data_F22$Ref_Compound==''),]
	if(sum(Input_Data_F22$Ref_Compound=='')==0){
		DB_part <- Input_Data_F22
	}else{
		DB_part <- Input_Data_F22[-which(Input_Data_F22$Ref_Compound==''),]
	}
	for(i in c(1:length(Bin_with_message_list))){
		one_bin_id = Bin_with_message_list[i]
		
		#one_bin_id = 'BIN 2459'
		part_data = DB_part[which(DB_part$Binner==one_bin_id),]
		all_ref <- names(table(part_data$New_Ref))
		for(j in c(1:length(all_ref))){
			one_ref_name = all_ref[j]
			part_new = part_data[which(part_data$New_Ref==one_ref_name),]
			part_data_v1 = part_new[which.max(part_new$Mean),]
			if(j == 1){
				all_part_data_v1 = part_data_v1
			}else{
				all_part_data_v1 = rbind(all_part_data_v1, part_data_v1)
			}
		}
		#print(all_part_data_v1)
		if(i==1){
			all_data = all_part_data_v1
		}else{
			all_data = rbind(all_data, all_part_data_v1)
		}
		#print(part_data)
	}
	#print(dim(all_data))
	
	Out_Data = rbind(all_data, Non_out_part)
	#if(length(Non_out_part[,1])>0){
		## merge data
	#}
	#Non_out_part
	return(Out_Data)
	
}


Filter_Bin_wihtout_DB <- function(Input_Data_F2){
	#Bin_with_out_message_list <- names(table(as.vector(Input_Data_F2[which(Input_Data_F2$Ref_Compound==''),]$Binner)))
	Bin_All <- names(table(as.vector(Input_Data_F2$Binner)))
	Bin_with_message_list <- names(table(as.vector(Input_Data_F2[-which(Input_Data_F2$Ref_Compound==''),]$Binner)))
	Bin_with_out_message_list <- Bin_All[-which(Bin_All%in%Bin_with_message_list)]
	#print(length(Bin_with_out_message_list))
	#print(length(Bin_with_message_list))
	Input_Data_F21 <- Filter_Non(Input_Data_F2, Bin_with_out_message_list)
	#print(dim(Input_Data_F21))
	Input_Data_F22 <- Filter_DB(Input_Data_F2, Bin_with_message_list)
	#print(dim(Input_Data_F22))
	Last_Data = rbind(Input_Data_F22, Input_Data_F21)
	#print(dim(Last_Data))
	table_dup=Last_Data[!duplicated(Last_Data),]
	return(table_dup)
}



Filter_Ref_Name_First <- function(Input_Data_F3){
	All_ppm <- Input_Data_F3$PPM
	Out_ppm <- c(1:length(Input_Data_F3[,1]))
	All_Ref_Compound <- Input_Data_F3$Ref_Compound
	Out_Ref_Compound <- c(1:length(Input_Data_F3[,1]))
	All_Ref_Name <- Input_Data_F3$Ref_Name
	Out_Ref_Name <- c(1:length(Input_Data_F3[,1]))
	All_Precursor_Type <- Input_Data_F3$Precursor_Type
	Out_Precursor_Type <- c(1:length(Input_Data_F3[,1]))
	All_Score_forward <- Input_Data_F3$Score_forward
	Out_Score_forward <- c(1:length(Input_Data_F3[,1]))
	All_Score_reverse <- Input_Data_F3$Score_reverse
	Out_Score_reverse <- c(1:length(Input_Data_F3[,1]))
	All_HMDB <- Input_Data_F3$HMDB
	Out_HMDB <- c(1:length(Input_Data_F3[,1]))
	All_KEGG <- Input_Data_F3$KEGG
	Out_KEGG <- c(1:length(Input_Data_F3[,1]))
	All_Cas <- Input_Data_F3$Cas
	Out_Cas <- c(1:length(Input_Data_F3[,1]))
	All_PUBCHEM <- Input_Data_F3$PUBCHEM
	Out_PUBCHEM <- c(1:length(Input_Data_F3[,1]))
	All_Class <- Input_Data_F3$Class
	Out_Class <- c(1:length(Input_Data_F3[,1]))
	All_Biospecimen <- Input_Data_F3$Biospecimen
	Out_Biospecimen <- c(1:length(Input_Data_F3[,1]))
	All_Synonyms <- Input_Data_F3$Synonyms
	Out_Synonyms <- c(1:length(Input_Data_F3[,1]))
	All_Namesets <- Input_Data_F3$Namesets
	Out_Namesets <- c(1:length(Input_Data_F3[,1]))
	All_Isotope_label <- Input_Data_F3$Isotope_label
	Out_Isotope_label <- c(1:length(Input_Data_F3[,1]))
	for(i in c(1:length(Input_Data_F3[,1]))){
		if(All_ppm[i]!=''){
			ppm_list <- as.numeric(as.character(unlist(strsplit(as.character(All_ppm[i]), split = ";"))))
			Out_ppm[i] <- ppm_list[1]
			Ref_Compound_list <- as.character(unlist(strsplit(as.character(All_Ref_Compound[i]), split = ";")))
			Out_Ref_Compound[i] <- Ref_Compound_list[1]
			Ref_Name_list <- as.character(unlist(strsplit(as.character(All_Ref_Name[i]), split = ";")))
			Out_Ref_Name[i] <- Ref_Name_list[1]
			Precursor_Type_list <- as.character(unlist(strsplit(as.character(All_Precursor_Type[i]), split = ";")))
			Out_Precursor_Type[i] <- Precursor_Type_list[1]
			Score_forward_list <- as.numeric(as.character(unlist(strsplit(as.character(All_Score_forward[i]), split = ";"))))
			Out_Score_forward[i] <- Score_forward_list[1]			
			Score_reverse_list <- as.numeric(as.character(unlist(strsplit(as.character(All_Score_reverse[i]), split = ";"))))
			Out_Score_reverse[i] <- Score_reverse_list[1]	
			HMDB_list <- as.character(unlist(strsplit(as.character(All_HMDB[i]), split = ";")))
			Out_HMDB[i] <- HMDB_list[1]
			KEGG_list <- as.character(unlist(strsplit(as.character(All_KEGG[i]), split = ";")))
			Out_KEGG[i] <- KEGG_list[1]
			Cas_list <- as.character(unlist(strsplit(as.character(All_Cas[i]), split = ";")))
			Out_Cas[i] <- Cas_list[1]			
			PUBCHEM_list <- as.character(unlist(strsplit(as.character(All_PUBCHEM[i]), split = ";")))
			Out_PUBCHEM[i] <- PUBCHEM_list[1]
			Class_list <- as.character(unlist(strsplit(as.character(All_Class[i]), split = ";")))
			Out_Class[i] <- Class_list[1]			
			Biospecimen_list <- as.character(unlist(strsplit(as.character(All_Biospecimen[i]), split = ";")))
			Out_Biospecimen[i] <- Biospecimen_list[1]
			Synonyms_list <- as.character(unlist(strsplit(as.character(All_Synonyms[i]), split = ";")))
			Out_Synonyms[i] <- Synonyms_list[1]
			Namesets_list <- as.character(unlist(strsplit(as.character(All_Namesets[i]), split = ";")))
			Out_Namesets[i] <- Namesets_list[1]
			Isotope_label_list <- as.character(unlist(strsplit(as.character(All_Isotope_label[i]), split = ";")))
			Out_Isotope_label[i] <- Isotope_label_list[1]
		}else{
			Out_ppm[i] <- NA
			Out_Ref_Compound[i] <- NA
			Out_Ref_Name[i] <- NA
			Out_Precursor_Type[i] <- NA
			Out_Score_forward[i] <- NA			
			Out_Score_reverse[i] <- NA
			Out_HMDB[i] <- NA
			Out_KEGG[i] <- NA
			Out_Cas[i] <- NA			
			Out_PUBCHEM[i] <- NA
			Out_Class[i] <- NA			
			Out_Biospecimen[i] <- NA
			Out_Synonyms[i] <- NA
			Out_Namesets[i] <- NA
			Out_Isotope_label[i] <- NA
		}
	
	}
			Input_Data_F3$Out_ppm <- Out_ppm
			Input_Data_F3$Out_Ref_Compound <- Out_Ref_Compound
			Input_Data_F3$Out_Ref_Name <- Out_Ref_Name
			Input_Data_F3$Out_Precursor_Type <- Out_Precursor_Type
			Input_Data_F3$Out_Score_forward <- Out_Score_forward	
			Input_Data_F3$Out_Score_reverse <- Out_Score_reverse
			Input_Data_F3$Out_HMDB <- Out_HMDB
			Input_Data_F3$Out_KEGG <- Out_KEGG
			Input_Data_F3$Out_Cas <- Out_Cas	
			Input_Data_F3$Out_PUBCHEM <- Out_PUBCHEM
			Input_Data_F3$Out_Class <- Out_Class	
			Input_Data_F3$Out_Biospecimen <- Out_Biospecimen
			Input_Data_F3$Out_Synonyms <- Out_Synonyms
			Input_Data_F3$Out_Namesets <- Out_Namesets
			Input_Data_F3$Out_Isotope_label <- Out_Isotope_label
			
	return(Input_Data_F3)
}




Filter_Diff_Bin <- function(Input_Data_F4){
	all_name <- names(table(Input_Data_F4$Out_Ref_Compound))
	for(i in c(1:length(all_name))){
		#if(nput_Data_F4$Out_Ref_Compound!=0){
			one_compund = all_name[i]
			one_part_data = Input_Data_F4[which(Input_Data_F4$Out_Ref_Compound==one_compund),]
			if(length(one_part_data[,1])==1){
				one_part_out = one_part_data
				one_part_out$ref_name_filter_type <- 'PASS'
			}else{
				one_part_out1 = one_part_data[which.max(one_part_data$Mean),]
				one_part_out1$ref_name_filter_type <- 'PASS'
				one_part_out2 = one_part_data[-which.max(one_part_data$Mean),]
				one_part_out2$ref_name_filter_type <- rep('Filter', length(one_part_out2[,1]))
				one_part_out = rbind(one_part_out1, one_part_out2)
			}
			if(i==1){
				all_out = one_part_out
			}else{
				all_out = rbind(all_out, one_part_out)
			}
			
		#}
	}
	#print(head(all_out))
	all_out_v1 = Input_Data_F4[which(Input_Data_F4$Ref_Compound==''),]
	all_out_v1$ref_name_filter_type <- 'PASS'
	all_data = rbind(all_out, all_out_v1)
	table_dup=all_data[!duplicated(all_data),]
	#print(dim(table_dup))
	#all_out_v1 = all_out[which(all_out$Out_PPM<25),]
	table_dup$PPM_filter <- ifelse(as.numeric(table_dup$Out_ppm) < 25, 'PASS', 'Filter')
	table_dup[which(table_dup$PPM_filter=='Filter'),which(colnames(table_dup)=='Out_Ref_Name')] =''
	table_dup[which(table_dup$PPM_filter=='Filter'),which(colnames(table_dup)=='Out_Ref_Compound')] =''
	table_dup[which(table_dup$PPM_filter=='Filter'),which(colnames(table_dup)=='Out_Precursor_Type')] =''
	table_dup[which(table_dup$PPM_filter=='Filter'),which(colnames(table_dup)=='Out_HMDB')] =''
	table_dup[which(table_dup$PPM_filter=='Filter'),which(colnames(table_dup)=='Out_KEGG')] =''
	table_dup[which(table_dup$PPM_filter=='Filter'),which(colnames(table_dup)=='Out_Cas')] =''
	table_dup[which(table_dup$PPM_filter=='Filter'),which(colnames(table_dup)=='Out_PUBCHEM')] =''
	table_dup[which(table_dup$PPM_filter=='Filter'),which(colnames(table_dup)=='Out_Class')] =''
	table_dup[which(table_dup$PPM_filter=='Filter'),which(colnames(table_dup)=='Out_Biospecimen')] =''
	table_dup[which(table_dup$PPM_filter=='Filter'),which(colnames(table_dup)=='Out_Synonyms')] =''
	table_dup[which(table_dup$PPM_filter=='Filter'),which(colnames(table_dup)=='Out_Namesets')] =''
	return(table_dup)
}





Filter_RT_mz_Data <- function(Input_Data_F5, cut_len){
        mz_size_list <-c(1:length(Input_Data_F5[,1]))
        RT_min_max_list <- c(1:length(Input_Data_F5[,1]))
		index_pollute <- c(1:length(Input_Data_F5[,1]))
        mz_med_list <- Input_Data_F5$mzmed
        for(i in c(1:length(Input_Data_F5[,1]))){
                mz_num = mz_med_list[i]
                mz_max = mz_num + cut_len
                mz_min = mz_num - cut_len
                part_Data = Input_Data_F5[which(Input_Data_F5$mzmed < mz_max& Input_Data_F5$mzmed > mz_min),]
                rt_min = min(part_Data$rtmed)
                rt_max = max(part_Data$rtmed)
                rt_len = rt_max - rt_min
                #if(Input_Data_F5$type_s[i]=='A'){
                mz_size_list[i] <- length(part_Data[,1])
                RT_min_max_list[i] <- rt_len
				size_num = length(part_Data[,1])
                if(rt_len * length(part_Data[,1])>4500){
                       #print(rt_len)
                       #print(dim(part_Data))
                       #print(mz_num)
					   index_pollute[i] <- 'Pollute'
                }else{
					index_pollute[i] <- 'Pass'
				}
        }
		Input_Data_F5$mz_size <- mz_size_list
		Input_Data_F5$RT_min_max <- RT_min_max_list
		Input_Data_F5$index_pollute <- index_pollute
	return(Input_Data_F5)
}


main_function <- function(workspace){
	Input_Data_Path = paste0(workspace, '/MGF_WORK_quali_quant.csv')
	Input_Data = read.csv(Input_Data_Path)
	Input_Data_F1 = Filter_RSD_Int(Input_Data)
	Input_Data_F2 <- Filter_feature_name_filter(Input_Data_F1)
	Input_Data_F3 = Filter_Bin_wihtout_DB(Input_Data_F2)
	Input_Data_F4 <- Filter_Ref_Name_First(Input_Data_F3)
	Input_Data_F5 <- Filter_Diff_Bin(Input_Data_F4)
	Input_Data_F6 <- Filter_RT_mz_Data(Input_Data_F5, 0.0007)
	Input_Data_Path_v1 = paste0(workspace, '/MGF_WORK_quali_quant_v1.csv')
	Input_Data_Path_v2 = paste0(workspace, '/MGF_WORK_quali_quant_v2.csv')
	Input_Data_Path_v3 = paste0(workspace, '/MGF_WORK_quali_quant_v3.csv')
	Input_Data_Path_v4 = paste0(workspace, '/MGF_WORK_quali_quant_v4.csv')
	Input_Data_Path_v5 = paste0(workspace, '/MGF_WORK_quali_quant_v5.csv')
	Input_Data_Path_v6 = paste0(workspace, '/MGF_WORK_quali_quant_v6.csv')
	Input_Data_Path_xlsx_v1 = paste0(workspace, '/MGF_WORK_quali_quant_v6.xlsx')
	write.table(Input_Data_F1, Input_Data_Path_v1, sep=',',quote = T, row.names = F)
	write.table(Input_Data_F2, Input_Data_Path_v2, sep=',',quote = T, row.names = F)
	write.table(Input_Data_F3, Input_Data_Path_v3, sep=',',quote = T, row.names = F)
	write.table(Input_Data_F4, Input_Data_Path_v4, sep=',',quote = T, row.names = F)
	write.table(Input_Data_F5, Input_Data_Path_v5, sep=',',quote = T, row.names = F)
	write.table(Input_Data_F6, Input_Data_Path_v6, sep=',',quote = T, row.names = F)
	write.xlsx(Input_Data_F6, file = Input_Data_Path_xlsx_v1)
}

#workspace = '/Media/E/zhangpeng/Project_SAM_test/POS_mzXML/'
main_function(workspace)

