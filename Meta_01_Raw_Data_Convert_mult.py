# -*- coding: utf-8 -*-
# 模块1 使用docker对于数据格式转换，放置合适文件路径
import os
import shutil
import calendar
import time

def all_path(dirname, type_wiff):
    result = []
    for maindir, subdir, file_name_list in os.walk(dirname):
        for filename in file_name_list:
            apath = os.path.join(maindir, filename)
            result_type = apath.split('.')[-1]
            if result_type == type_wiff:
                result.append(apath)
    return result

def copy_wiff_scan(input_path, output_path_mid):
    outDIR = os.path.dirname(input_path)
    outFile = os.path.basename(input_path)
    output_path_raw = output_path_mid + '/' + str(outFile)
    print(output_path_raw)
    shutil.copyfile(input_path, output_path_raw)
    return(output_path_raw)

def run_msconvert_mgf(output_path_mid, output_path_raw):
    ## 使用docker运行mgf文件转换
    raw_name = os.path.basename(output_path_raw)
    cmd_code = 'docker run --rm -v ' + output_path_mid + ':/data/zhangpeng/ msconvert wine msconvert /data/zhangpeng/' + raw_name + ' -o /data/zhangpeng/ --outfile ' + raw_name.replace('raw', 'mgf') + ' --mgf --mz64 --inten64 -z --filter "peakPicking true 1-" --filter "msLevel 1-"'
    os.system(cmd_code)

def run_msconvert_mzXML(output_path_mid, output_path_raw):
    ## 使用docker运行mzXML文件转换
    raw_name = os.path.basename(output_path_raw)
    cmd_code = 'docker run --rm -v ' + output_path_mid + ':/data/zhangpeng/ msconvert wine msconvert /data/zhangpeng/' + raw_name + ' -o /data/zhangpeng/ --outfile ' + raw_name.replace('raw', 'mzXML') + ' --mzXML --mz64 --inten64 -z --filter "peakPicking true 1-" --filter "msLevel 1-"'
    os.system(cmd_code)


def Move_Data_mzXML(output_path_mid, output_path):
    all_mzXML = all_path(output_path_mid, 'mzXML')
    all_raw = all_path(output_path_mid, 'raw')
    mzXML_ID = os.path.basename(all_mzXML[0])
    output_path_mzXML = output_path + '/' + mzXML_ID
    shutil.copyfile(all_mzXML[0], output_path_mzXML)
    os.remove(all_mzXML[0])
    os.remove(all_raw[0])

def Move_Data_mgf(output_path_mid, output_path):
    all_mgf = all_path(output_path_mid, 'mgf')
    mgf_ID = os.path.basename(all_mgf[0])
    output_path_mgf = output_path + '/' + mgf_ID
    shutil.copyfile(all_mgf[0], output_path_mgf)
    os.remove(all_mgf[0])


def Exists_Path(Sample_Path):
    if not os.path.exists(Sample_Path):
        os.mkdir(Sample_Path)

def Run_Single_file(output_path_mid, output_path_mzXML, output_path_mgf,input_path):
    ### 单独分组文件进行放置
    out_file_path = all_path(input_path, 'raw')
    Exists_Path(output_path_mzXML)
    Exists_Path(output_path_mgf)
    for one_file_path in out_file_path:
        output_path_raw = copy_wiff_scan(one_file_path, output_path_mid)
        run_msconvert_mgf(output_path_mid, output_path_raw)
        run_msconvert_mzXML(output_path_mid, output_path_raw)
        Move_Data_mzXML(output_path_mid, output_path_mzXML)
        Move_Data_mgf(output_path_mid, output_path_mgf)

def Run_Mult_file(output_path_mzXML_all, output_path_mgf, input_path_all):
    ### 多分组文件进行放置
    output_path_mid = '/Media/E/zhangpeng/Project_Mid_2/'
    ts = calendar.timegm(time.gmtime())
    output_path_mid = output_path_mid + '/WorkSpace_' + str(ts) + '/'
    All_file_ID = os.listdir(input_path_all)
    Exists_Path(output_path_mzXML_all)
    Exists_Path(output_path_mgf)
    Exists_Path(output_path_mid)
    for one_file in All_file_ID:
        output_path_mzXML = output_path_mzXML_all + '/' + one_file + '/'
        input_path = input_path_all + '/' + one_file + '/'
        Exists_Path(output_path_mzXML)
        Run_Single_file(output_path_mid, output_path_mzXML, output_path_mgf, input_path)

if __name__=="__main__":
    ## 测试
    output_path_mid = '/Media/E/zhangpeng/Project_Mid/'
    output_path_mzXML_all = '/Media/E/zhangpeng/Project_SAM_test/POS_mzXML/'
    output_path_mgf = '/Media/E/zhangpeng/Project_SAM_test/POS_mgf/'
    input_path_all = '/Media/E/zhangpeng/Project_SAM_test/POS/'
    Run_Mult_file(output_path_mzXML_all, output_path_mgf, input_path_all)

