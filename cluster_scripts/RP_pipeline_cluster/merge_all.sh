#!/bin/sh
#PBS -l walltime=02:00:00
#PBS -l select=1:ncpus=4:mem=32000mb


module load java

export JARDIR=$jar
export OUTPUTROOT=$out
export INPUT=$OUTPUTROOT/Consolidated/final_adjusted_inserts/
export OUTPUT=$OUTPUTROOT/Final_Merged/

mkdir -p $OUTPUT

java -Xmx31800m -server -cp $JARDIR/CombineAndSampleInsert.jar paired_end.CombineAndSampleInsert $INPUT $OUTPUT $window $chrom $start $stop $JARDIR/noExclusion.txt 50 $start
