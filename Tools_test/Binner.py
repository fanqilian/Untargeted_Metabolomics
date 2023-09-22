import os

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

def Run_Second_code(mzXML_file_path):
    Rscript_work_path = '/home/zhangpeng/anaconda3/bin/Rscript'
    Run_cmd = Rscript_work_path + ' /home/zhangpeng/Project/TCM_PEP/Tools/filter_table_second_v2.R ' + mzXML_file_path
    os.system(Run_cmd)
    Run_cmd_v2 = Rscript_work_path + ' /home/zhangpeng/Project/TCM_PEP/Tools/filter_table_third_v1.R ' + mzXML_file_path
    os.system(Run_cmd_v2)



mzXML_file_path = '/Media/E/zhangpeng/Urea_Serum/Serum/POS/'
mzXML_file_path = '/Media/E/zhangpeng/Urea_Serum_two/HILIC_NEG/'
Create_Bin_ID(mzXML_file_path)
Run_Second_code(mzXML_file_path)

mzXML_file_path = '/Media/E/zhangpeng/Urea_Serum_two/HILIC_POS/'
Create_Bin_ID(mzXML_file_path)
Run_Second_code(mzXML_file_path)



