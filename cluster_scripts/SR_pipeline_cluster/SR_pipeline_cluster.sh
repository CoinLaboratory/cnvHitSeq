#!/bin/sh

#First, we need to define the working directory and the input directory. The 
#input directory should only contain the BAM files. BAI index files will created as
#necessary. BAM files are assumed to contain reads from one sample, for one chromosome.
#The working directory is were all the intermediate and final results will be saved

chr=$1 #chromosome to perform analysis on
start=${2:-2} #start coordinate
stop=$3 #end coordinate
maxDistance=${4:-50000}

export OUTPUT=./pre_processing_results/SR_results
export JARDIR=./SR_pipeline/
export INPUT=./input/
export SUPPL=./SR_pipeline/supplementary

mkdir -p $OUTPUT

#Then, we process the BAM files by filtering duplicate & unmapped
#reads. The filtered BAM files are split into their original libraries
#which are quantile normalised to a Gaussian N(200,15).
#The following command creates and submits separate jobs for filtering
#and normalising each library file. This step takes advantage of the parallel 
#analysis of BAM files and takes approximately one hour (in our setup).

COUNTER=0
for f in $INPUT/*.bam
do
	sampleName=$(basename $f)
	JOB[$COUNTER]=`qsub -v jar=$JARDIR,out=$OUTPUT,in=$INPUT,sample=$sampleName,suppl=$SUPPL,chr=$chr split_one.sh`
	echo ${JOB[$COUNTER]}
	ALIGN[$COUNTER]=`qsub -W depend=afterok:${JOB[$COUNTER]} -v jar=$JARDIR,out=$OUTPUT,sample=$sampleName,suppl=$SUPPL,chr=$chr,maxDistance=$maxDistance align_one.sh`
	echo ${ALIGN[$COUNTER]}
	PROCESS[$COUNTER]=`qsub -W depend=afterok:${ALIGN[$COUNTER]} -v jar=$JARDIR,out=$OUTPUT,sample=$sampleName,suppl=$SUPPL,chr=$chr,maxDistance=$maxDistance,start=$start,stop=$stop process_split_one.sh`
	echo ${PROCESS[$COUNTER]}
	let COUNTER=COUNTER+1
done

#Here we set up the depencies for the last job
dependency=${PROCESS[i]}
for (( i=1; i<$COUNTER; i++ ))
do
	dependency+=:${PROCESS[i]}
done

#Finally, we merge and sample the normalised files. This final command should
#be executed when the previous job has finished. If your PBS queuing system
#does not support dependencies, the lost job will need to be run manually.
#The user can specify which genomic region will be included in the merged file,
#and how dense the sampling will be (in bp), using the window variable. The default is 20bp.

FINAL=`qsub -W depend=afterok:$dependency -v jar=$JARDIR,out=$OUTPUT,chrom=$chr,start=$start,stop=$stop,window=20 merge_all.sh`
echo $FINAL
