library(xcms)
library(MetAnalyzer)
require(CAMERA)

#polarity = 'positive'
#workspace = '/Media/E/zhangpeng/TCM_Workspace/Project05/POS_mzXML'

Peak_Filter <- function(workspace, polarity){
	load(paste0(workspace, '/parameters.rdat'))
	load(paste0(workspace, '/xset-centWave-retcor.Rda'))

	nSlaves = 8
	camera.sigma <- 6
	camera.perfwhm <- 0.6
	camera.maxcharge <- 3
	camera.maxiso <- 4
	camera.ppm <- 5
	camera.mzabs <- 0.015
	AA <- xsetc@peaks
	AB =na.omit(AA)
	AC = AB[which(AB[,10]>50),]
	xsetc@peaks = AC
	#xset2 <- group(xsetc, bw = 3, mzwid = 0.015, minfrac = para.set$minfrac)
	xset2 <- group(xsetc, bw =5 , mzwid = 0.015, minfrac = para.set$minfrac)
	groupmat <- xcms::groups(xset2)


	filebase = 'MS1'
	eicmax = NULL
	is.plotEIC.pg = F
	#xset2 <- group(xsetc, bw = 5, mzwid = 0.03, minfrac = para.set$minfrac)
	#groupmat <- xcms::groups(xset2)

	peak.table <- data.frame(cbind(groupmat, groupval(xset2, "medret", "into")), row.names = NULL)
	xset3 <- fillPeaks(xset2)
	peak.table <- GetPeakTable(xset3, filebase = filebase, eicmax = eicmax, is.plotEIC.pg = is.plotEIC.pg)

	fn.final <- paste0(workspace, '/PeakTable-FillGaps_peaks.csv')
	write.csv(peak.table, fn.final, row.names = TRUE)

	xs_anno  <- xsAnnotate(xset3, polarity = polarity, nSlaves = nSlaves)
	xs_anno2 <- groupFWHM(xs_anno, sigma = camera.sigma, perfwhm = camera.perfwhm)
	xs_anno2i <- try(findIsotopes(xs_anno2,
                                  maxcharge = camera.maxcharge,
                                  maxiso = camera.maxiso,
                                  ppm = camera.ppm,
                                  mzabs = camera.mzabs))
	peaklist.anno <- getPeaklist(xs_anno2i)
	idx.grp <- unique(peaklist.anno[, 'pcgroup'])
	camear.psg_list <- seq(length(xs_anno2i@pspectra))
	camear.psg_list <- camear.psg_list[which(camear.psg_list %in% idx.grp)]

	xs_anno2a <- try(findAdducts(xs_anno2i,
                                 ppm = camera.ppm,
                                 mzabs = camera.mzabs,
                                 polarity = polarity,
                                 psg_list = camear.psg_list,
                                 rules = camera.rules))

	try(cleanParallel(xs_anno2a))
	peaklist.anno <- getPeaklist(xs_anno2a)
	peak.table.anno <- cbind(peak.table, peaklist.anno[, c('isotopes', 'adduct', 'pcgroup')])
	fn.final <- paste0(workspace, 'PeakTable-Annotated_peaks.csv')
	write.csv(peak.table.anno, fn.final, row.names = TRUE)
	fn.final.txt <- paste0(workspace, 'PeakTable-Annotated_peaks_v1.txt')
        write.table(peak.table.anno, fn.final.txt, row.names = F ,sep='\t')
}


