#!/bin/sh

#First, we need to define the working directory and the input directory. The 
#input directory should only contain the BAM files. BAI index files will be created as
#necessary. BAM files are assumed to contain reads from one sample, for one chromosome.
#The working directory is were all the intermediate and final results will be saved

chr=$1 #chromosome to perform analysis on
start=${2:-1} #start coordinate
stop=$3 #end coordinate
INPUT=$4 #input folder (containing the BAM files)

export OUTPUT=./pre_processing_results/RP_results
export JARDIR=./RP_pipeline/
export INPUT=${INPUT:="./input/"}
export FINAL=./CNV_detection/cnvHiTSeq_data/1000genInsert

mkdir -p $OUTPUT
mkdir -p $FINAL

#Then, we process the BAM files by filtering duplicate & ambiguous mappings.
#The filtered files are split files into their original sequencing libraries
#which are then quantile normalised to a Gaussian N(200,15).
#The following command filters and normalising each library file.
#This step requires SAMtools (http://samtools.sourceforge.net/)

for f in $INPUT/*.bam
do
	echo "Processing file: $(basename $f) ..."	
	sh $JARDIR/process_one.sh $JARDIR $OUTPUT $INPUT $(basename $f)
done

#The next step is to consolidate the library files. This
#command should only be executed when all the individual BAM
#files have been processed.

sh $JARDIR/consolidate_files.sh $JARDIR $OUTPUT $start $stop

#Finally, we merge and sample the normalised files. This final command should
#be executed when the files have been consolidated. The user can specify which
#genomic region will be included in the merged file, and how dense the sampling
#will be (in bp), using the window variable. The default is 20bp.

sh $JARDIR/merge_all.sh $JARDIR $OUTPUT $FINAL $chr $start $stop 20
