# AGA - Aggregated Grand Average
## Selecting window for ERP analysis that does not inflate the false positive rate

Selecting a window for ERP analysis can be a difficult task. One option is selecting the window based on previous research but this approach usually results to loss of power. Applying a window based on the data should always be done in a way that it does inflate the false positive rate. 
If many different windows are explored, then family wise errors should be taken into account and a controlling procedure, such as Bonferoni correction should be used. But again this is very conservative and it can lead again to loss of power.

We have done extensive testing and showed<sup>[1](#myfootnote1)</sup> that using the AGA wave to find the window for the analysis does not inflate the false positive rate and at the same time is less conservative than other commonly used methods. 

Generating the AGA is extremely simple, just generate an ERP from all the EEG trials from the conditions of interest. Then find the window with the maximum (for a positive component i.e. P300) or minimum amplitude. Then use this window for any statistical analysis. 

![Comparision of the window placement when the AGA wave is used vs the Difference wave] [image]
[image]: https://github.com/alexZ82/AGA/blob/master/ex2.jpg

