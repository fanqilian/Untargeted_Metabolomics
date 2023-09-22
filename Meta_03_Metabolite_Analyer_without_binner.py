# -*- coding: utf-8 -*-
# 模块3 做定性分析，使用高博分析流程(不同分析放在在路径下Tools/Meta_DB/)
import os
import shutil
import time
import calendar

def Exists_Path(Sample_Path):
    if not os.path.exists(Sample_Path):
        os.mkdir(Sample_Path)

def all_path(dirname, type_mgf):
    result = []
    for maindir, subdir, file_name_list in os.walk(dirname):
        for filename in file_name_list:
            apath = os.path.join(maindir, filename)
            result_type = apath.split('.')[-1]
            if result_type == type_mgf:
                result.append(apath)
    return result

def RM_Data(File_Path):
    os.rmdir(File_Path)

def Copy_Data_Meta_DB(mgf_file_path, mzXML_file_path, time_ID):
    ### 将结果文件整理为高博的输入格式
    DB_Workspace = '/home/zhangpeng/Project/TCM_PEP/Tools/Meta_DB/'
    MGF_DB_Workspace = DB_Workspace + '/MGF_WORK_' + time_ID + '/'
    Exists_Path(MGF_DB_Workspace)
    MGF_Origin_Path = all_path(mgf_file_path, 'mgf')
    #mgf_file_csv_path = mzXML_file_path + '/idresults_v2.csv'
    mgf_file_csv_path = mzXML_file_path + '/PeakTable-Annotated.csv'
    #mgf_file_csv_path = mzXML_file_path + '/PeakTable-Annotated_peaks.csv'
    #mgf_file_csv_path = mgf_file_path + mgf_csv_path_ID
    Run_change_Cmd = '/home/zhangpeng/anaconda3/bin/Rscript /home/zhangpeng/Project/Untargeted_Metabolomics/Tools_test/Run_Data_tranforms.R ' + mzXML_file_path
    os.system(Run_change_Cmd)
    MGF_DB_CSV = MGF_DB_Workspace + '/idresults_v2.csv' #+ mgf_csv_path_ID
    shutil.copyfile(mgf_file_csv_path, MGF_DB_CSV)
    for one_mgf_num in range(len(MGF_Origin_Path)):
        mgf_ID = os.path.basename(MGF_Origin_Path[one_mgf_num])
        #print(MGF_Origin_Path)
        MGF_DB_Workspace_file = MGF_DB_Workspace + mgf_ID
        shutil.copyfile(MGF_Origin_Path[one_mgf_num], MGF_DB_Workspace_file)

def Run_Meta_DB(time_ID, IonModel_Type):
    ## 使用高博的脚本进行计算
    Workspace = '/home/zhangpeng/Project/TCM_PEP/Tools/Meta_DB/'
    os.chdir(Workspace)
    if IonModel_Type == 'POS':
        Run_Cmd = 'perl /home/zhangpeng/Project/TCM_PEP/Tools/Meta_DB/metaboatlas.pl -D MGF_WORK_' + time_ID + '  -IonModel Positive -dbtype All -T 0.025 -I 10 -M 10 -R 12 -Cutoff 0.7 -PPM 10 -Rone 12 -Method Cosine'
    if IonModel_Type == 'NEG':
        Run_Cmd = 'perl /home/zhangpeng/Project/TCM_PEP/Tools/Meta_DB/metaboatlas.pl -D MGF_WORK_' + time_ID + '  -IonModel Negative -dbtype All -T 0.025 -I 10 -M 10 -R 12 -Cutoff 0.7 -PPM 10 -Rone 12 -Method Cosine'
        #Run_Cmd = 'perl /home/zhangpeng/Project/TCM_PEP/Tools/Meta_DB/metaboatlas.pl -D MGF_WORK_' + time_ID + '  -IonModel All -dbtype All -T 0.025 -I 10 -M 10 -R 12 -Cutoff 0.7 -PPM 10 -Rone 12 -Method Cosine'
    os.system(Run_Cmd)

def Create_Bin_ID(mzXML_file_path):
    work_out_path = mzXML_file_path + '/group_out.txt'
    work_in_path = mzXML_file_path + '/binner_out.txt'
    output_group = open(work_out_path, 'w')
    with open(work_in_path, 'r') as input_data:
        input_data.readline()
        all_data = input_data.readlines()
        for one in all_data:
            one_mess = one.rstrip().split('\t')
            if len(one_mess) >1:
                if 'BIN' in one_mess[1]:
                    all_ID = one_mess[22:]
                    for one_ID in all_ID:
                        one_line = one_mess[1] + '\t' + one_ID + '\n'
                        output_group.write(one_line)

def Run_Merge_ID(Input_File_Path_mzXML):
    Rscript_work_path = '/home/zhangpeng/anaconda3/bin/Rscript'
    Run_cmd = Rscript_work_path + ' /home/zhangpeng/Project/TCM_PEP/Tools/filter_table_second.R ' + Input_File_Path_mzXML
    os.system(Run_cmd)

def remove_num(a):
    b=[]
    for i in a:
        if i not in "0123456789":
            b.append(i)
    return("".join(b))


def Move_out_Data(mzXML_file_path, time_ID):
    ## 清理最终数据及格式
    DB_file_path = '/home/zhangpeng/Project/TCM_PEP/Tools/Meta_DB/MGF_WORK_'+time_ID+'tmp/'
    DB_file_path_o = '/home/zhangpeng/Project/TCM_PEP/Tools/Meta_DB/MGF_WORK_'+time_ID+'/'
    for one_file in os.listdir(DB_file_path):
        from_path = DB_file_path + '/' + one_file
        one_file_n = remove_num(one_file)
        one_file_n = one_file_n.replace('__', '_')
        to_path = mzXML_file_path +'/' + one_file_n
        shutil.copyfile(from_path, to_path)
        #RM_Data(from_path)
    shutil.rmtree(DB_file_path)
    shutil.rmtree(DB_file_path_o)

def Main_DB(mgf_file_path, mzXML_file_path, IonModel_Type):
    ## 主函数
    #Create_Bin_ID(mzXML_file_path)
    #Run_Merge_ID(mzXML_file_path)
    ts = calendar.timegm(time.gmtime())
    time_ID = str(ts)
    Copy_Data_Meta_DB(mgf_file_path, mzXML_file_path, time_ID)
    Run_Meta_DB(time_ID, IonModel_Type)
    Move_out_Data(mzXML_file_path, time_ID)

if __name__=="__main__":
    ## 测试
    mgf_file_path = '/Media/E/zhangpeng/Project_SAM_test/POS_mgf/'
    mzXML_file_path = '/Media/E/zhangpeng/Project_SAM_test/POS_mzXML/'
    Main_DB(mgf_file_path, mzXML_file_path)

#mgf_file_path = '/Media/E/tyliu/Urea_Serum_20220107_T3/Urea/POS_mgf'
#mzXML_file_path = '/Media/E/tyliu/Urea_Serum_20220107_T3/Urea/POS_mzXML'
#Main_DB(mgf_file_path, mzXML_file_path)


