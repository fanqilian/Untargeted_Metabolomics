# Untargeted Metabolomics Automated Workflow（for large-scale datasets）


## 1. Project Description

This project focuses on the automated analysis of metabolomics data. The specific workflow includes:

1. Conversion of raw data files {Meta_01_Raw_Data_Convert.py, Meta_01_Raw_Data_Convert_mult.py}
2. Data analysis using xcms {Meta_02_Data_XCMS.py}
3. Database search and identification {Meta_03_Metabolite_Analyer.py, Meta_03_Metabolite_Analyer_without_binner.py}.

对于代谢组学数据进行流程自动化分析，具体流程包括：

1. raw 文件数据转换 {Meta_01_Raw_Data_Convert.py, Meta_01_Raw_Data_Convert_mult.py}

2. xcms 数据分析{Meta_02_Data_XCMS.py}

3. 数据库搜索鉴定{Meta_03_Metabolite_Analyer.py, Meta_03_Metabolite_Analyer_without_binner.py}

### flowchart


```
   A[Main Function Invocation] --> B{Analysis Script}
   B -->|Step 1| C[Raw Data File Conversion]
   B -->|Step 2| C[xcms Data Analysis]
   B -->|Step 3| C[Database Search and Identification]
```



## 2. Environment Dependencies

* python 3.7
* R 3.6

### Deployment Steps
1. Add the database and save the search data in Tools/Meta_DB/mznew ( This will be described in Untargeted_Metabolomics_Database ).

2. Install relevant code packages:
   * For R (version 3.5 and earlier):
     * source("https://bioconductor.org/biocLite.R")
     * biocLite()
     * biocLite(c("xcms", "BiocParallel"))
   * For R (version 3.6 and later):
     * if (!requireNamespace("BiocManager", quietly = TRUE))
     * install.packages("BiocManager")
     * BiocManager::install("xcms", "BiocParallel")



## Quick Start

To view the parameter help documentation:
```
python Untargeted_Metabolomics_with_group_0909.py -h
```
- Input Parameter Description:

1. `--raw_data_path`: Path to the RAW file. You can either specify a single RAW file or use a directory.
2. `--type`: Mode for POS/NEG (Positive/Negative).

* 输入参数说明：

1.	--raw_data_path  RAW文件路径，可以直接raw文件，也可以使用文件夹；
2.	--type POS/NEG模式；

* Input Data Format Example:

```
├── Banana
│   ├── Banana_pos_1.raw
│   ├── Banana_pos_2.raw
│   ├── Banana_pos_3.raw
│   ├── Banana_pos_4.raw
│   └── Banana_pos_5.raw
├── Blueberry
│   ├── Blueberry_pos_1.raw
│   ├── Blueberry_pos_2.raw
│   ├── Blueberry_pos_3.raw
│   ├── Blueberry_pos_4.raw
│   └── Blueberry_pos_5.raw
```


* 输出结果：对应文件夹的目录下会有两个文件夹，分别是_mgf、_mzXML文件。其中主要结果在_mzXML文件目录下；其中作为后续分析的结果文件为MGF_WORK_quali_quant.csv；包括鉴定结果，定量结果等.
* Output Results: There will be two folders under the corresponding directory, which are _mgf and _mzXML folders. The main results are located in the _mzXML folder directory. The file used for subsequent analysis is MGF_WORK_quali_quant.csv; it includes identification results, quantification results, etc.

```
├── POS
│ └── SR_A ### Different groups are in different folder directories
│ ├── P1_SR_A-1_POS_1.raw
│ ├── P1_SR_A-1_POS_2.raw
│ ├── P1_SR_A-1_POS_3.raw
| | ...
├── POS_mgf ## Folder for generated MGF files
│ ├── P1_SR_A-1_POS_1.mgf
│ ├── P1_SR_A-1_POS_2.mgf
│ ├── P1_SR_A-1_POS_3.mgf
| | ...
└── POS_mzXML ## Folder for generated mzXML files
├── deredundancy.csv
├── Group_ID.txt
├── MetAnalyzer-ID
├── MGF_WORK_pred_file.csv
├── MGF_WORK_quali.csv
├── MGF_WORK_quali_quant.csv ## Table for qualitative + quantitative analysis
├── MGF_WORK_quali_quant.txt
├── parameters.rdat
├── PCA.pdf
├── PeakTable-Annotated.csv
├── PeakTable-Annotated_peaks.csv
├── PeakTable-Annotated_peaks_v1.txt ## Table for quantification
├── PeakTable-Annotated.txt
├── PeakTable-FillGaps.csv
├── PeakTable-FillGaps_peaks.csv
├── PeakTable-raw.csv
├── rector-obiwarp.pdf
├── SR_A ## Folder for format conversion files
│ ├── P1_SR_A-1_POS_1.mzXML
│ ├── P1_SR_A-1_POS_2.mzXML
│ ├── P1_SR_A-1_POS_3.mzXML
| ...
├── TICs-rtcor.pdf
├── xset-centWave-final.Rda
├── xset-centWave.Rda
└── xset-centWave-retcor.Rda

```



