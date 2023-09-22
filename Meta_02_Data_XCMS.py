# -*- coding: utf-8 -*-
# 模块2 调用xcms计算定量表
import os

## Run Code

def all_path_ID(dirname, type_mgf, Sample_ID):
    result = []
    for maindir, subdir, file_name_list in os.walk(dirname):
        for filename in file_name_list:
            apath = os.path.join(maindir, filename)
            result_type = apath.split('.')[-1]
            if result_type == type_mgf and Sample_ID in apath:
                out_str = apath.split('/')[-1]
                out_str = out_str.split('.')[0]
                result.append(out_str)
    return result

def Run_xcms(Input_File_Path):
    ## 计算XCMS，调用Tools/Metabolite_Analyer.R脚本计算；
    ## 调用/Tools/Metabolite_Analyer_second_param.R调整过滤参数；
    Type_File = Input_File_Path.rstrip('/').split('/')[-1]
    Rscript_work_path = '/home/zhangpeng/anaconda3/bin/Rscript'
    R_tool_workspace = '/home/zhangpeng/Project/Untargeted_Metabolomics'
    if 'POS' in Type_File or 'pos' in Type_File:
        Run_cmd_v1 = Rscript_work_path + ' ' + R_tool_workspace + '/Tools/Metabolite_Analyer.R ' + Input_File_Path + ' POS'
        Run_cmd_v2 = Rscript_work_path + ' ' + R_tool_workspace + '/Tools/Metabolite_Analyer_second_param.R ' + Input_File_Path + ' POS'
        print(Run_cmd_v1)
        os.system(Run_cmd_v1)
        os.system(Run_cmd_v2)
    if 'NEG' in Type_File or 'neg' in Type_File:
        Run_cmd_v1 = Rscript_work_path + ' ' + R_tool_workspace + '/Tools/Metabolite_Analyer.R ' + Input_File_Path + ' NEG'
        Run_cmd_v2 = Rscript_work_path + ' ' + R_tool_workspace + '/Tools/Metabolite_Analyer_second_param.R ' + Input_File_Path + ' NEG'
        os.system(Run_cmd_v1)
        os.system(Run_cmd_v2)



def Find_All_ID(Input_File_Path, Input_File_Path_mzXML, Sample_ID):
    ## Filter File
    all_File_name = all_path_ID(Input_File_Path, 'mgf', Sample_ID)
    out_group_file = Input_File_Path_mzXML +'/Group_ID.txt'
    group_txt = open(out_group_file, 'w') 
    group_txt.write('ID\n')
    for one_str in all_File_name:
        group_txt.write(one_str + '\n')


def Run_RSD(Input_File_Path_mzXML):
    ## 过滤RSD数值
    Rscript_work_path = '/home/zhangpeng/anaconda3/bin/Rscript'
    R_tool_workspace = '/home/zhangpeng/Project/Untargeted_Metabolomics'
    Run_cmd = Rscript_work_path + ' ' + R_tool_workspace + '/Tools/filter_table_first.R ' + Input_File_Path_mzXML
    print('++++++++++++++++++++++++++++++++++++++++++++test second+++++++++++++++++++++++++++++++++++++')
    print(Run_cmd)
    os.system(Run_cmd)

def Main_XCMS(Input_File_Path_mzXML, Input_File_Path_mgf, Sample_ID):
    print(Input_File_Path_mzXML)
    Run_xcms(Input_File_Path_mzXML)
    Find_All_ID(Input_File_Path_mgf, Input_File_Path_mzXML,Sample_ID)
    #Run_RSD(Input_File_Path_mzXML)

if __name__=="__main__":
    ## 测试
    Input_File_Path_mzXML = '/Media/E/zhangpeng/Project_SAM_test/POS_mzXML'
    Input_File_Path_mgf = '/Media/E/zhangpeng/Project_SAM_test/POS_mgf'
    Run_xcms(Input_File_Path_mzXML)
    Sample_ID = 'KSZSY'
    Find_All_ID(Input_File_Path_mgf, Input_File_Path_mzXML,Sample_ID)
    Main_XCMS(Input_File_Path_mzXML, Input_File_Path_mgf, Sample_ID)

