# -*- coding: utf-8 -*-
# 总分析流程，将raw文件作为输入，分析出定量定性分析结果
import os
import Meta_01_Raw_Data_Convert_mult
import Meta_02_Data_XCMS
import Meta_03_Metabolite_Analyer_without_binner
import argparse

def Main_Step_One(Workspace, Sample_ID, IonModel_Type):
    output_path_mzXML = Workspace.rstrip('/') + '_mzXML/'
    output_path_mzXML_all = Workspace.rstrip('/') + '_mzXML/'
    output_path_mgf = Workspace.rstrip('/') + '_mgf/'
    input_path_all = Workspace + '/'
    input_path = Workspace + '/'
    # 模块1 使用docker对于数据格式转换，放置合适文件路径
    Meta_01_Raw_Data_Convert_mult.Run_Mult_file(output_path_mzXML_all, output_path_mgf, input_path_all)
    # 模块2 调用xcms计算定量表
    Meta_02_Data_XCMS.Main_XCMS(output_path_mzXML, output_path_mgf, Sample_ID)
    # 模块3 做定性分析，使用高博分析流程(不同分析放在在路径下Tools/Meta_DB/)
    Meta_03_Metabolite_Analyer_without_binner.Main_DB(output_path_mgf, output_path_mzXML, IonModel_Type)



#Input_Raw_Path = '/Media/E/zhangpeng/Project_SAM_test/NEG/'
#Workspace = '/Media/E/zhangpeng/Project_SAM_test/POS/'
#Sample_ID = 'KSZSY'
if __name__=="__main__":
    parser = argparse.ArgumentParser(description='Mult Herbs Summary by xcms(step one)')
    parser.add_argument('--raw_data_path', type=str, default = None)
    parser.add_argument('--type', choices = ['POS', 'NEG'])
    #parser.add_argument('--First_Herbs', type=str, default= None)
    args = parser.parse_args()

    Workspace = args.raw_data_path
    IonModel_Type = args.type
    Sample_ID = 'AA'
    Main_Step_One(Workspace, Sample_ID, IonModel_Type)


