#!/bin/sh

#First we need to define the working directory and the input directory.
#The input directory should only contain the BAM (and possibly the BAI index) files.
#The working directory is were all the intermediate and final results will be saved
#We assume each BAM file contains reads from one sample, for one chromosome.

chr=$1 #chromosome to perform analysis on
start=${2:-0} #start coordinate
stop=$3 #end coordinate
INPUT=$4 #input folder (containing the BAM files)

export OUTPUTDIR=./pre_processing_results/RD_results
export JARDIR=./RD_pipeline/
export INPUT=${INPUT:="./input/"}
export FINAL=./CNV_detection/cnvHiTSeq_data/1000gen

mkdir -p $OUTPUTDIR
mkdir -p $FINAL

#First, we process the BAM file by filtering duplicate & unmapped
#reads and performing LOESS smoothing on the filtered files.
#The following command filters and smoothes the BAM files contained in
#the input folder. This step requires SAMtools (http://samtools.sourceforge.net/)
#We have tested the pipeline using SAMtools 0.1.18

smoothProbes=25 #Parameter that specifies the size of the LOESS window

for f in $INPUT/*.bam
do
	echo "Processing file: $(basename $f) ..."
	sh $JARDIR/process_one.sh $JARDIR $OUTPUTDIR $INPUT $(basename $f) $smoothProbes $start $stop
done

#The final step is to sample and merge the smoothed files. This final command should
#only be executed when all each individual BAM file has been processed.
#The user can specify which genomic region will be included in the merged file, and
#how dense the sampling will be (in bp), using the window variable. The default is 20bp.

sh $JARDIR/merge_all.sh $JARDIR $OUTPUTDIR $FINAL $chr $start $stop 20
