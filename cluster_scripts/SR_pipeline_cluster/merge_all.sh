#!/bin/sh
#PBS -l walltime=03:00:00
#PBS -l select=1:ncpus=2:mem=16000mb


module load java

export JARDIR=$jar
export OUTPUTROOT=$out
export INPUT=$OUTPUTROOT/processed_splits/
export OUTPUT=$OUTPUTROOT/Final_Merged/

mkdir -p $OUTPUT

java -Xmx15800m -server -cp $JARDIR/CombineAndSampleSR.jar split_read.CombineAndSampleSR $INPUT $OUTPUT $window $chrom $start $stop

