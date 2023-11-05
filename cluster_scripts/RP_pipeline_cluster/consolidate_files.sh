#!/bin/sh
#PBS -l walltime=02:00:00
#PBS -l select=1:ncpus=2:mem=16000mb
#PBS -q pqeph

module load java

export JARDIR=$jar
export OUTPUTROOT=$out
export OUTPUT=$OUTPUTROOT/Consolidated

mkdir -p $OUTPUT

java -Xmx15800m -server -cp $JARDIR/ConsolidateFiles.jar paired_end.ConsolidateFiles $OUTPUTROOT/Processed $OUTPUT $start $stop
