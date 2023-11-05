#!/bin/sh

export JARDIR=$1
export OUTPUTROOT=$2
export INPUT=$OUTPUTROOT/processed_splits/
export OUTPUT=$OUTPUTROOT/Final_Merged/

mkdir -p $OUTPUT

#This class merges the individual processed split read files
#into the format recognized by cnvHiTSeq
#The larger the sample set the more memory it requires.

#The "CombineAndSampleSR" class takes 6 arguments:
#-1 the path of the folder that contains the individually processed files
#-2 the path of the output folder
#-3 the size of the sampling window (defaults to 20, increase if you have memory problems)
#-4 the chromosome that we are processing
#-5 the coordinate from which to start (defaults to 2)
#-6 the maximum coordinate that will be processed.

java -Xmx3400m -cp $JARDIR/CombineAndSampleSR.jar split_read.CombineAndSampleSR $INPUT $OUTPUT $7 $4 $5 $6

cp $OUTPUT/"chr$4"_"$5"_"$6"/*.zip $3/$4.zip
echo "Finished pre-processing SR."
