INSTRUCTIONS
------------

Once the pre-processing step is finished and the data has been converted
to the appropriate zip format the CNV calling can be performed using the
the cnvHiTSeq.jar. This file contains all the necessary libraries and
requires the following:

- a data.csv file that contains the training parameters for each data source
  (represented by different columns in the file). The name of each data source
  must be the same for the the data.csv columns and the input folder names.

- a param.txt that contains general parameters of the model

- an input folder (in our example ./cnvHiTSeq_data), which contains separate
  folders for each data source. In turn, these folders contain the pre-processed
  zip files. If these folders were not created using the provided scripts,
  they should all be renamed to the chromosome name (e.g. "8.zip")

When running cnvHiTSeq, some basic parameters can be set from the command-line:

* --mid specifies the region on which to perform the analysis
  (e.g. --mid 8:24.63mb:24.65mb). The first argument (here "8" corresponds
  to the name of the zip files that contain the data)

* --baseDir specifies where the input data is located

* --include specifies which data sources to include in the analysis by name
  (as specified by the columns of the data.csv file and the input folder names)
  e.g. to include all 3 data sources: --include 1000gen:1000genInsert:1000genSplit

* --plot specifies whether to produce plots of the underlying data along with the
  segmentation. To enable plotting this parameter needs to be set to 1, otherwise
  to 0. When plotting is enabled the analysis will take longer.

* --weightedInsert specifies whether to weight the probability of the RP distance
  by the RP count, which is useful for low-coverage data

* --numIt argument defines the number of training iterations for the model. To avoid
  overfitting this parameter shouldn't be set above 15. For single-sample analysis
  the segmentation doesn't improve with training.


Here's an example for running cnvHiTSeq:

java -Xmx3800m -cp ./cnvHiTSeq.jar lc1.dp.appl.CNVHap --paramFile param.txt --mid 8:24.17mb:24.18mb --baseDir ./cnvHiTSeq_data/ --index 1 --column 1 --numIt 5 --include 1000gen:1000genInsert:1000genSplit --plot 1 --r_panel true --b_panel true --showScatter false --showHMM false  --weightedInsert true --expModelIntHotSpot 100:1:1e3 --collapseDupStates true --overrideTransitionMatrix true > tmp 2>output_msg.txt

Alternatively, you can run the run_cnvHiTSeq.sh script from the commandline.

The program creates separate folders for each run and names them after
the region of choice. Inside these folders, you can find a variety of results,
with the actual CNV calls contained in text files in the "cnv" folder. If you
chose to plot the results they will appear in the "plot_all_predictionsB" folder.
