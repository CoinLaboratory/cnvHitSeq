#!/bin/sh
#PBS -l walltime=4:00:00
#PBS -l select=1:ncpus=1:mem=8000mb

module load java

export JARDIR=$jar
export OUTPUTROOT=$out
export ALIGN=$OUTPUTROOT/alignments
export OUTPUT=$OUTPUTROOT/processed_splits
export TEMP=$OUTPUTROOT/Temp
export SUM=$OUTPUTROOT/summaries

mkdir -p $OUTPUT
mkdir -p $TEMP
mkdir -p $SUM

java -Xms7800m -Xmx7800m -server -cp $JARDIR/ProcessSplit.jar split_read.ProcessSplit "$ALIGN/$sample.sam" $TEMP $SUM $OUTPUT $chr 20 $maxDistance 20 30 $start $stop
