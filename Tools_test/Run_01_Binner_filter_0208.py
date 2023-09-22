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

def Run_Second_code(mzXML_file_path, group_id_path):
    Rscript_work_path = '/home/zhangpeng/anaconda3/bin/Rscript'
    Run_cmd = Rscript_work_path + ' /home/zhangpeng/Project/TCM_PEP/Tools/filter_table_second_v2.R ' + mzXML_file_path
    os.system(Run_cmd)
    Run_cmd_v2 = Rscript_work_path + ' /home/zhangpeng/Project/TCM_PEP/Tools/filter_table_third_v2.R ' + mzXML_file_path + ' ' + group_id_path
    os.system(Run_cmd_v2)



#mzXML_file_path = '/Media/E/zhangpeng/Urea_Serum_20220107_T3/Urea/NEG_mzXML/'
#group_id_path = 'Group_Urea_POS.txt'
mzXML_file_path = '/Media/E/zhangpeng/Urea_Serum_0208/Urea_Serum_20220110_hilic/Serum/POS_mzXML/'
group_id_path = 'Group_Serum_POS.txt'
#Create_Bin_ID(mzXML_file_path)
#Run_Second_code(mzXML_file_path, group_id_path)


mzXML_file_path = '/Media/E/zhangpeng/Urea_Serum_0208/Urea_Serum_20220110_hilic/Serum/NEG_mzXML/'
group_id_path = 'Group_Serum_POS.txt'

#Create_Bin_ID(mzXML_file_path)
#Run_Second_code(mzXML_file_path, group_id_path)

mzXML_file_path = '/Media/E/zhangpeng/Urea_Serum_0208/Urea_Serum_20220107_T3/Serum/NEG_mzXML/'
group_id_path = 'Group_Serum_POS.txt'

#Create_Bin_ID(mzXML_file_path)
#Run_Second_code(mzXML_file_path, group_id_path)

mzXML_file_path = '/Media/E/zhangpeng/Urea_Serum_0208/Urea_Serum_20220107_T3/Serum/POS_mzXML/'
group_id_path = 'Group_Serum_POS.txt'

#Create_Bin_ID(mzXML_file_path)
#Run_Second_code(mzXML_file_path, group_id_path)

mzXML_file_path = '/Media/E/zhangpeng/Urea_Serum_0208/Urea_Serum_20220110_hilic/Urea/POS_mzXML/'
group_id_path = 'Group_Urea_POS.txt'

Create_Bin_ID(mzXML_file_path)
Run_Second_code(mzXML_file_path, group_id_path)

mzXML_file_path = '/Media/E/zhangpeng/Urea_Serum_0208/Urea_Serum_20220110_hilic/Urea/NEG_mzXML/'
group_id_path = 'Group_Urea_POS.txt'

Create_Bin_ID(mzXML_file_path)
Run_Second_code(mzXML_file_path, group_id_path)

mzXML_file_path = '/Media/E/zhangpeng/Urea_Serum_0208/Urea_Serum_20220107_T3/Urea/POS_mzXML/'
group_id_path = 'Group_Urea_POS.txt'

Create_Bin_ID(mzXML_file_path)
Run_Second_code(mzXML_file_path, group_id_path)


mzXML_file_path = '/Media/E/zhangpeng/Urea_Serum_0208/Urea_Serum_20220107_T3/Urea/NEG_mzXML/'
group_id_path = 'Group_Urea_POS.txt'

Create_Bin_ID(mzXML_file_path)
Run_Second_code(mzXML_file_path, group_id_path)


