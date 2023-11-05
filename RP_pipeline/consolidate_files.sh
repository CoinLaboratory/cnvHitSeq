#!/bin/sh

export JARDIR=$1
export OUTPUTROOT=$2
export OUTPUT=$OUTPUTROOT/Consolidated

mkdir -p $OUTPUT

#The next step is to put the libraries of the BAM file back together.
#The "ConsolidateFiles" class takes 4 arguments:
#-1 the path of the directory that contains the processed library files
#-2 the output path
#-3 the start coordinate
#-4 the end coordinate

java -Xmx3800m -cp $JARDIR/ConsolidateFiles.jar paired_end.ConsolidateFiles $OUTPUTROOT/Processed $OUTPUT $3 $4 > $OUTPUTROOT/consolidate_output.txt
rm -rf $OUTPUTROOT/Processed
rm -rf $OUTPUT/full_libraries
echo "Finished consolidating files."
