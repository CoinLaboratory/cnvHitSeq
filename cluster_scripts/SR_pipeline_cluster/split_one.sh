#!/bin/sh
#PBS -l walltime=01:00:00
#PBS -l select=1:ncpus=1:mem=8000mb


module load java

export JARDIR=$jar
export OUTPUTROOT=$out
export INPUT=$in
export SUPPL=$suppl
export OUTPUT=$OUTPUTROOT/split_fastq_files

mkdir -p $OUTPUT

java -Xms7800m -Xmx7800m -server -cp $JARDIR/SplitUnmappedReads.jar split_read.SplitUnmappedReads $INPUT/"$sample" $OUTPUT $SUPPL $chr 15
