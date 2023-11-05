#!/bin/sh

export JARDIR=$1
export OUTPUTROOT=$2
export ALIGN=$OUTPUTROOT/alignments
export OUTPUT=$OUTPUTROOT/processed_splits
export TEMP=$OUTPUTROOT/temp
export SUM=$OUTPUTROOT/summaries

mkdir -p $OUTPUT
mkdir -p $TEMP
mkdir -p $SUM

#This class processes, filters and summarizes the discovered splits.
#Only splits with at least one of the fragments close to the anchor are kept
#Also we filter out splits that have low complexity (e.g. are very repetitive), using the DUST score.
#This helps reduce false positives especially for shorter fragments
#The results constitute our split dataset and are summarized appropriately.

#The "ProcessSplit" class takes 11 arguments:
#-1 the path of the SAM file created by the alignment algorithm
#-2 a path for the temporary files that can be deleted afterwards
#-3 a path for the summarized files
#-4 a path for the final output
#-5 the chromosome we are processing
#-6 the minimum distance that 2 split fragments are allowed to have (defaults to 20).
#-7 the maximum distance that 2 split framgents are allowed to have (defaults to 50000).
#-8 the minimum DUST score that a fragment is allowed to have (defaults to 20, the lower the more permissive)
#-9 the difference in coordinates that 2 independent splits are allowed to have to be supporting the same split (defaults to 30).
#-10 the start coordinate
#-11 the stop coordinate

minSplitDistance=20 #parameter that defines how close the 2 split fragments are allowed to be aligned
minDustScore=20 #parameter that defines the minimum allowed DUST score, which filters out low-complexity reads
tolerance=30 #parameter that defines tha maximum distance that 2 independent splits are allowed to have to be considered to arise from the same split
java -Xms3200m -Xmx3400m -cp $JARDIR/ProcessSplit.jar split_read.ProcessSplit "$ALIGN/$3.sam" $TEMP $SUM $OUTPUT $5 $minSplitDistance $6 $minDustScore $tolerance $7 $8

rm -rf $TEMP
rm -rf $ALIGN
echo "Finished consolidating split reads for file: $3"
