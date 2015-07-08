rm(list=ls())
load('PzProbe_EEG.RData') # Loads list, PzProbeEEG with subject EEG for condition = 'Probe'
                          # Each element is a matrix, which contains a subject's EEG, with columns
                          # representing the trials
load('PzIrr_EEG.RData')  # Loads list, PzIrrEEG with subject EEG for condition = 'Irrelevant'
load('EEG_time.RData')
source('aga_functions.R') # Load the function that will be used below
CondtionA<-PzProbeEEG
ConditionB<-PzIrrEEG
rm(PzProbeEEG,PzIrrEEG)
###############################################################################################
####--Parametrisaton --########################################################################
ROI_start <- which(eegtime==300)#Because we are intrested in the P3 component, the broader area
                                #for the moving window will be between 300-500ms
ROI_end <- which(eegtime==800)
windowSize<-which(eegtime==100) - which(eegtime==0)#moving window size. We want to canlucate how 
                                                   #many time points are needed for a 100ms 
                                                   #interval
###############################################################################################
####--This example demonstrates how to use the Aggregated Grand Average (AGA) --###############
###-- in order to compare two Conditions : Fake, Probe based on the P300 component --##########
###############################################################################################

numbeofsubjects<-length(sapply(CondtionA, length))
#Create ERPs for each subject 
ConditionA_ERPS <- sapply(CondtionA,erp) #ConditionA ERPs per subject
ConditionB_ERPS <- sapply(ConditionB,erp) #ConditionB ERPs per subject
ConditionA_AllTrials<-do.call(cbind,CondtionA) # Step 1: Combine all trials from Condition 1 (Probe)
                                           # into one matrix
ConditionB_AllTrials<-do.call(cbind,ConditionB)  # Step 2: Combine all trials from Condition 2 (Fake)
                                           # into one matrix
allTrials<-cbind(ConditionA_AllTrials,ConditionB_AllTrials) # Step 3: Combine the trials from both conditions
                                                 # into one matrix
AGA <- erp(allTrials) # Generate the Agregated Grand Average by averaging across all trials
window_analysis <- averagewindow (AGA, ROI_start,ROI_end,windowSize,'maximum') #Find window for the analysis based on the 
                                                   #AGA

ConditionA_mean_ampl<-apply(ConditionA_ERPS[window_analysis$start:window_analysis$end,],2,mean)
ConditionB_mean_ampl<-apply(ConditionB_ERPS[window_analysis$start:window_analysis$end,],2,mean)
(ttest<-t.test(ConditionA_mean_ampl,ConditionB_mean_ampl,paired = TRUE))

###############################################################################################
####---------Run This Block If you want to Visualise the Data ------------------------#########
###############################################################################################
ConditionA_GrandAverage<-apply(ConditionA_ERPS,1,mean)
ConditionB_GrandAverage<-apply(ConditionB_ERPS,1,mean)
par(mfrow = c(3,1))
matplot(eegtime,ConditionA_ERPS,type='l',ylab = 'amplitude',xlab='time',main='ConditionA: Subject ERPs')
matplot(eegtime,ConditionB_ERPS,type='l',ylab = 'amplitude',xlab='time',main='ConditionB: Subject ERPs')
plot(eegtime,ConditionA_GrandAverage,type='l',col='red',ylab = 'amplitude',xlab='time',main=('ConditionA vs ConditionB\n Grand Average ERPs'))
lines(eegtime,ConditionB_GrandAverage,col='black')
legend('topleft',lty=c(1,1),col=c('red','black'),c('ConditionA','ConditionB'))
###############################################################################################

###############################################################################################
####-------- Run This Block To Visualise Window placement based on the Difference ----#########
####-------- Wave vs the AGA Wave -------------################################################
DiffWave <- ConditionA_GrandAverage - ConditionB_GrandAverage 
window_analysis_diff <- averagewindow (DiffWave, ROI_start,ROI_end,windowSize,'maximum') 
dev.off()
plot(eegtime,ConditionA_GrandAverage,type='l',ylab = 'amplitude',xlab='time',main=('AGA vs Diff Wave\n Window Placement'),lty=2,col='black',ylim = c(-6,8))
lines(eegtime,ConditionB_GrandAverage,col='black',lty=3)
legend('topleft',col='black',lty=c(2,3),c('ConditionA','ConditionB'))
lines(eegtime,AGA,col='red')
lines(c(eegtime[window_analysis$start],eegtime[window_analysis$start]),c(-5,10),col='red')
lines(c(eegtime[window_analysis$end],eegtime[window_analysis$end]),c(-5,10),col='red')
lines(eegtime,DiffWave,col='blue')
lines(c(eegtime[window_analysis_diff$start],eegtime[window_analysis_diff$start]),c(-5,10),col='blue')
lines(c(eegtime[window_analysis_diff$end],eegtime[window_analysis_diff$end]),c(-5,10),col='blue')
legend('bottomleft',lty=c(1,1),col=c('red','blue'),c('AGA','Diff'))
###############################################################################################
####-------- Another example ----##############################################################

load('PzFake_EEG.RData')  # Loads list, PzIrrEEG with subject EEG for condition = 'Irrelevant'
ConditionC<-PzFakeEEG # name to Condition C for clarity
rm(PzFakeEEG) # clear memory 
ConditionC_ERPS <- sapply(ConditionC,erp)
ConditionC_GrandAverage<-apply(ConditionC_ERPS,1,mean)
ConditionC_AllTrials<-do.call(cbind,ConditionC) # Following same steps as before
allTrials_new<-cbind(ConditionA_AllTrials,ConditionC_AllTrials) 
AGA_new <- erp(allTrials_new) 
window_analysis_new <- averagewindow (AGA_new, ROI_start,ROI_end,windowSize,'either') 
ConditionA_mean_ampl_new<-apply(ConditionA_ERPS[window_analysis_new$start:window_analysis_new$end,],2,mean)# The window has changed so mean amplitude needs to be re-calculated
ConditionC_mean_ampl<-apply(ConditionC_ERPS[window_analysis_new$start:window_analysis_new$end,],2,mean)
(ttest<-t.test(ConditionA_mean_ampl_new,ConditionC_mean_ampl,paired = TRUE))
####-------- Plot new Data ----##############################################################
DiffWave_new <- ConditionA_GrandAverage - ConditionC_GrandAverage 
window_analysis_diff_new <- averagewindow (DiffWave_new, ROI_start,ROI_end,windowSize,'either') 
dev.off
plot(eegtime,ConditionA_GrandAverage,type='l',ylab = 'amplitude',xlab='time',main=('AGA vs Diff Wave\n Window Placement'),lty=2,col='black',ylim = c(-6,8))
lines(eegtime,ConditionC_GrandAverage,col='black',lty=3)
legend('topleft',col='black',lty=c(2,3),c('ConditionA','ConditionC'))
lines(eegtime,AGA_new,col='red')
lines(c(eegtime[window_analysis_new$start],eegtime[window_analysis_new$start]),c(-6,7),col='red')
lines(c(eegtime[window_analysis_new$end],eegtime[window_analysis_new$end]),c(-6,7),col='red')
lines(eegtime,DiffWave_new,col='blue')
lines(c(eegtime[window_analysis_diff_new$start],eegtime[window_analysis_diff_new$start]),c(-6,7),col='blue')
lines(c(eegtime[window_analysis_diff_new$end],eegtime[window_analysis_diff_new$end]),c(-6,7),col='blue')
legend('bottomleft',lty=c(1,1),col=c('red','blue'),c('AGA','Diff'))

