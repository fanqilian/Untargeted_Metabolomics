library("MetAnalyzer")
args=commandArgs(T)
print(args[1])
print(args[2])

workspace = args[1]
type_id = args[2]

source('/home/zhangpeng/Project/Untargeted_Metabolomics/Tools/Peaks_filter.R')

## negative
## positive

if(type_id=='POS'){
	setwd(workspace)
	#MetAnalyzer(polarity= "positive", parameter.set="Service.Amide.23min", library = c("zhuMetlib.RData", "zhulib.RData", "zhuNISTlib.RData", "NISTlib.RData"), nSlaves = 10,cutoff=0.6, is.plotEIC.pg = F, is.plotMSMS = T, is.plotEIC.MSMS = F)
	print('++++++++++++++++++++++++++++++++++++test Peak Filter++++++++++++++++++++')
	Peak_Filter(workspace, polarity='positive')
}

if(type_id=='NEG'){
        setwd(workspace)
        #MetAnalyzer(polarity= "negative", parameter.set="Service.Amide.23min", library = c("zhuMetlib.RData", "zhulib.RData", "zhuNISTlib.RData", "NISTlib.RData"), nSlaves = 10,cutoff=0.6, is.plotEIC.pg = F, is.plotMSMS = T, is.plotEIC.MSMS = F)
	Peak_Filter(workspace, polarity='negative')
}


#setwd("/Media/E/zhangpeng/Project_4588/NEG/")

#MetAnalyzer(polarity= "positive", parameter.set="Service.Amide.23min", library = c("zhuMetlib.RData", "zhulib.RData", "zhuNISTlib.RData", "NISTlib.RData"), nSlaves = 40,cutoff=0.6, is.plotEIC.pg = F, is.plotMSMS = T, is.plotEIC.MSMS = F)



