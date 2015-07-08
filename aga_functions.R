library(zoo)
#-- Function to create ERP from a matrix representing EEG data -----------------------------------###############
#-- eeg the matrix with the EEG data with columns being the trials and rows the data points ------###############
#-- RETURNS a vector obtained by averarging across trials (ERP) ----------------------------------###############
erp<-function(eeg){
  apply(eeg,1,mean)
}

#-- Moving window mean amplitude -----------------------------------------------------------------###############
#-- signal: a vector representing the signal -----------------------------------------------------###############
#-- windowsize: the window (in time) to be used for the mean amplitude  --------------------------###############
#-- Direnctionality: maximum, searchs for a positive component  ----------------------------------###############
#--                  minimum searchs for a negative component   ----------------------------------###############
#--                  otherwise searchs for the biggest component regardless directionality ------###############
#-- RETURNS a dataframe with $start reprenting the starting point of the window and $end then ending point ######
averagewindow<-function(signal,from,to,windowsize,directionality){
  
  if (directionality=='maximum'){
    cropped<-signal[from:to]
    means<-rollmean(cropped,windowsize,allign='left')
    start<-which.max(means) 
  }else if (directionality=='minimum'){
    cropped<-signal[from:to]
    means<-rollmean(cropped,windowsize,allign='left')
    start<-which.min(means) 
  }else{
    cropped<-abs(signal[from:to])
    means<-rollmean(cropped,windowsize,allign='left')
    start<-which.max(means) 
  }
 
  end<-start+windowsize 
  return (data.frame(start=start+from,end=end+from))
}