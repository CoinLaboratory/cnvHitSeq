#!/bin/sh

export JARDIR=$1
export OUTPUTROOT=$2
export INPUT=$OUTPUTROOT/Smoothed/
export OUTPUT=$OUTPUTROOT/Final_Merged/

mkdir -p $OUTPUT

#This class merges and samples the individual processed
#read depth files into the format recognized by cnvHiTSeq.
#The larger the sample set the more memory it requires.

#The "CombineAndSampleSmoothed" class takes 9 arguments:
#-1 the path of the folder that contains the individually processed files
#-2 the path of the output folder
#-3 the size of the sampling window (defaults to 20, increase if you have memory problems)
#-4 the chromosome that we are processing
#-5 the coordinate from which to start (defaults to 0)
#-6 the maximum coordinate that will be processed.
#-7 the path of the file that contains possible regions to be excluded (absent here)
#-8 specifies the tolerance around the excluded region breakpoints (defaults to 50)
#-9 the start coordinate of the region of interest if different from the previously defined

java -Xmx3800m -server -cp $JARDIR/CombineAndSampleSmoothed.jar doc.CombineAndSampleSmoothed $INPUT $OUTPUT $7 $4 $5 $6 $JARDIR/noExclude.txt 50 $5
cp $OUTPUT/"chr$4"_"$5"_"$6"/*.zip $3/$4.zip
echo "Finished pre-processing RD."
