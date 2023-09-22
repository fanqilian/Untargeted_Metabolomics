
args=commandArgs(T)
print(args[1])
workspace = args[1]


csv_to_txt <- function(input_data_path, out_data_path){
	read_data <- read.csv(input_data_path)
	read_data <- read_data[!duplicated(read_data$name),]
	write.table(read_data, out_data_path, row.names = F, quote = T, sep='\t')
}


input_data_path = paste0(workspace, '/PeakTable-Annotated.csv')
out_data_path = paste0(workspace, '/PeakTable-Annotated.txt')
csv_to_txt(input_data_path, out_data_path)


#input_data_path = '/home/liutaiyi/vscode/projects/Nontarget_Metabo/Urea_Serum/HILIC/Urea_HILIC_NEG_quali_quant.csv'
#out_data_path = '/home/liutaiyi/vscode/projects/Nontarget_Metabo/Urea_Serum/HILIC/Urea_HILIC_NEG_quali_quant.txt'

#csv_to_txt(input_data_path, out_data_path)

#input_data_path = '/home/liutaiyi/vscode/projects/Nontarget_Metabo/Urea_Serum/HILIC/Urea_HILIC_POS_quali_quant.csv'
#out_data_path = '/home/liutaiyi/vscode/projects/Nontarget_Metabo/Urea_Serum/HILIC/Urea_HILIC_POS_quali_quant.txt'

#csv_to_txt(input_data_path, out_data_path)


#input_data_path = '/home/liutaiyi/vscode/projects/Nontarget_Metabo/Urea_Serum/HILIC/Plasma_HILIC_NEG_quali_quant.csv'
#out_data_path = '/home/liutaiyi/vscode/projects/Nontarget_Metabo/Urea_Serum/HILIC/Plasma_HILIC_NEG_quali_quant.txt'

#csv_to_txt(input_data_path, out_data_path)



#input_data_path = '/home/liutaiyi/vscode/projects/Nontarget_Metabo/Urea_Serum/HILIC/Plasma_HILIC_POS_quali_quant.csv'
#out_data_path = '/home/liutaiyi/vscode/projects/Nontarget_Metabo/Urea_Serum/HILIC/Plasma_HILIC_POS_quali_quant.txt'

#csv_to_txt(input_data_path, out_data_path)




