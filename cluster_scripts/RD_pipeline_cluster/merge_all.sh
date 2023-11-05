#!/bin/sh
#PBS -l walltime=2:00:00
#PBS -l select=1:ncpus=2:mem=16000mb

module load java

export JARDIR=$jar
export OUTPUTROOT=$out
export INPUT=$OUTPUTROOT/Smoothed/
export OUTPUT=$OUTPUTROOT/Final_Merged/

mkdir $OUTPUT

java -Xmx15800m -server -cp $JARDIR/CombineAndSampleSmoothed.jar doc.CombineAndSampleSmoothed $INPUT $OUTPUT $window $chrom $start $stop $JARDIR/noExclude.txt 50 $start
