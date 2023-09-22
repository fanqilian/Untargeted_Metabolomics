#source('/home/zhangpeng/Project/Untargeted_Metabolomics/Tools/filter_table_third.R')

workspace = '/Media/E/tyliu/Urea_Serum_20220107_T3/Urea/POS_mzXML/'

Input_Data_Path = paste0(workspace, '/MGF_WORK_quali_quant.csv')
Input_Data = read.csv(Input_Data_Path)

print(head(Input_Data))



