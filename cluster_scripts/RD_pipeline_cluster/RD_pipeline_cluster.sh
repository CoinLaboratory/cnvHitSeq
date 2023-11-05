#!/bin/sh

#RD_pipeline script for use with a PBS queuing system.

#First we need to define the working directory and the input directory.
#The input directory should only contain the BAM (and possibly the BAI index) files.
#The working directory is were all the intermediate and final results will be saved
#We assume each BAM file contains reads from one sample, for one chromosome.

chr=$1 #chromosome to perform analysis on
start=${2:-0} #start coordinate
stop=$3 #end coordinate

export OUTPUTDIR=./pre_processing_results/RD_results
export JARDIR=./RD_pipeline/
export INPUT=./input/

mkdir -p $OUTPUTDIR
mkdir -p $FINAL

#First, we process the BAM files by filtering duplicate & unmapped
#reads and performing LOESS smoothing on the filtered files.
#The following command creates and submits separate jobs for filtering
#and smoothing each BAM file. This step takes advantage of the parallel 
#analysis of the BAM files to speed-up the pre-processing.

smoothProbes=25

numBam=$(ls $INPUT/*.bam | wc -l)

JOBARRAY=`qsub -J 1-$numBam -v jar=$JARDIR,out=$OUTPUTDIR,in=$INPUT,smooth=$smoothProbes,start=$start,stop=$stop process_one.sh`
echo $JOBARRAY

#If the queuing system does not support array jobs, instead of
#the previous command you can use the following:

#COUNTER=0
#for f in $INPUT/*.bam
#do
#	JOB[$COUNTER]=`qsub -v jar=$JARDIR,out=$OUTPUTDIR,in=$INPUT,sample=$(basename $f),smooth=$smoothProbes process_one.sh`
#	echo ${JOB[$COUNTER]}
#	let COUNTER=COUNTER+1
#done

#However, if this is the case, the depency on the "FINAL" job will not work
#correctly and it will have to be run manually after all the previous jobs have finished.

#The final step is to sample and merge the smoothed files. This final command should
#only be executed when all the jobs created by the previous command have finished! If
#your queuing system supports array jobs, then you don't need to take any action.
#The user can specify which genomic region will be included in the merged file, and
#how dense the sampling will be (in bp), using the window variable. The default is 20bp.

FINAL=`qsub -v jar=$JARDIR,out=$OUTPUTDIR,chrom=$chr,start=$start,stop=$stop,window=20 -W depend=afterok:$JOBARRAY merge_all.sh`
echo $FINAL
