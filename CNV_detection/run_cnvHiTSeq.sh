#!/bin/sh

#the "mid" argument specifies which region the CNV analysis should be performed on.
#an example is --mid 8:24.63mb:24.65mb

#the "baseDir" argument specifies where the input data is located

#the "include" argument specifies which data sources to include in the analysis
#by default all 3 data sources are included.

#the "plot" argument specifies whether to produce plots of
#the underlying data along with the segmentation
#to enable plotting set "plot" to 1
#if plot is set to 0, no plots will be created and the process will be faster

#the "weightedInsert" argument specifies whether to weight the probability of 
#the RP distance by the RP count which is especially useful for low-coverage data

#the "numIt" argument defines the number of training iterations,
#which is set to only 5 here since we're only analyzing 1 sample

java -Xmx3800m -cp ./cnvHiTSeq.jar lc1.dp.appl.CNVHap --paramFile param.txt --mid 8:24.63mb:24.65mb --baseDir ./cnvHiTSeq_data/ --index 1 --column 1 --numIt 5 --include 1000gen:1000genInsert:1000genSplit --plot 0 --r_panel true --b_panel true --showScatter false --showHMM false  --weightedInsert true --expModelIntHotSpot 100:1:1e3 --collapseDupStates true --overrideTransitionMatrix true > tmp 2>output_msg.txt
