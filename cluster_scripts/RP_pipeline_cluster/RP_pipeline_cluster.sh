#!/bin/sh

#RP_pipeline script for use with a PBS queuing system.

#First, we need to define the working directory and the input directory. The 
#input directory should only contain the BAM files. BAI index files will created as
#necessary. BAM files are assumed to contain reads from one sample, for one chromosome.
#The working directory is were all the intermediate and final results will be saved

chr=$1 #chromosome to perform analysis on
start=${2:-1} #start coordinate
stop=$3 #end coordinate

export OUTPUT=./pre_processing_results/RP_results
export JARDIR=./RP_pipeline/
export INPUT=./input/

mkdir -p $OUTPUT

#Then, we process the BAM files by filtering duplicate & unmapped
#reads. Then we split the BAM files into their original libraries
#which are then quantile normalised to a Gaussian N(200,15).
#The following command creates and submits separate jobs for filtering
#and normalising each library file. This step takes advantage of the parallel 
#analysis of BAM files to speed up the pre-processing.

numBam=$(ls $INPUT/*.bam | wc -l)

JOBARRAY=`qsub -J 1-$numBam -v jar=$JARDIR,out=$OUTPUT,in=$INPUT,maxInsertSize=100000 process_one.sh`
echo $JOBARRAY

#If the queuing system does not support array jobs, instead of
#the previous command you can use the following:

#COUNTER=0
#for f in $INPUT/*.bam
#do
	#JOB[$COUNTER]=`qsub -v jar=$JARDIR,out=$OUTPUT,in=$INPUT,maxInsertSize=100000 process_one.sh`
	#echo ${JOB[$COUNTER]}
#	let COUNTER=COUNTER+1
#done

#However, if this is the case, the depency on the "CONSOLIDATE" job will not work
#correctly and it will have to be run manually after all the previous jobs have finished.

#The next step is to consolidate the library files. This
#command should only be executed when all the jobs created
#by the previous command have finished! If your queuing system
#supports array jobs, then you don't need to take any action.

CONSOLIDATE=`qsub -W depend=afterok:$JOBARRAY -v jar=$JARDIR,out=$OUTPUT,start=$start,stop=$stop consolidate_files.sh`
echo $CONSOLIDATE

#Finally, we merge and sample the normalised files. This final command should
#be executed when the previous job has finished. The user can specify which
#genomic region will be included in the merged file, and how dense the sampling
#will be (in bp), using the window variable. The default is 20bp.

FINAL=`qsub -W depend=afterok:$CONSOLIDATE -v jar=$JARDIR,out=$OUTPUT,chrom=$chr,start=$[$start+1],stop=$stop,window=20 merge_all.sh`
echo $FINAL
