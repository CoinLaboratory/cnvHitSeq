#!/bin/sh

#First, we need to define the working directory and the input directory. The 
#input directory should only contain the BAM files. BAI index files will created as
#necessary. BAM files are assumed to contain reads from one sample, for one chromosome.
#The working directory is were all the intermediate and final results will be saved.

#The supplementary directory must contain the FASTA files against which the unmapped anchored
#reads will be realigned (the file should be named in the format: chr#.fasta). These FASTA files
#must be downloaded from http://hgdownload.cse.ucsc.edu/goldenPath/hg19/chromosomes/ and placed
#in the ./SR_pipeline/supplementary directory before running the preprocessing!

#The directory must also contain a file with the position of the gaps (centromeres and telomeres)
#in the sequence as obtained from UCSC: http://genome.ucsc.edu/cgi-bin/hgTables?org=Human&db=hg19&hgsid=228404685

chr=$1 #chromosome to perform analysis on
start=${2:-2} #start coordinate
stop=$3 #end coordinate
INPUT=$4 #input folder (containing the BAM files)

export OUTPUT=./pre_processing_results/SR_results
export JARDIR=./SR_pipeline/
export INPUT=${INPUT:="./input/"}
export SUPPL=./SR_pipeline/supplementary
export FINAL=./CNV_detection/cnvHiTSeq_data/1000genSplit

mkdir -p $OUTPUT
mkdir -p $FINAL

#The first step is to index the fasta file for use with the BWA aligner
#If the fasta file has been previously indexed, this step can be safely
#skipped. The index files should be placed in the supplementary folder.

for f in $SUPPL/*.fasta
do
	echo "Indexing file: $f" 	
	sh $SUPPL/bwa_index_one.sh $f
done

#Then, we process the BAM files to obtain all orphaned reads and
#split the unmapped mate in all possible configurations. The split
#reads are then realigned to the reference using BWA (which needs to be
#installed for this step: http://bio-bwa.sourceforge.net/)
#The pipeline was tested using BWA 0.5.8

#To reduce the search space we can specify the maximum allowed distance
#of 2 split fragments. The default is 50000

maxDistance=50000

for f in $INPUT/*.bam
do
	sampleName=$(basename $f)
	echo "Processing file: $sampleName"
	sh $JARDIR/split_one.sh $JARDIR $OUTPUT $INPUT $sampleName $SUPPL $chr
	sh $JARDIR/align_one.sh $JARDIR $OUTPUT $sampleName $SUPPL $chr $maxDistance
	sh $JARDIR/process_split_one.sh $JARDIR $OUTPUT $sampleName $SUPPL $chr $maxDistance $start $stop
done

#Finally, we merge and sample the consolidated split read files.
#The user can specify which genomic region will be included 
#in the merged file, and how dense the sampling will be (in bp),
#using the window variable. The default is 20bp.

sh $JARDIR/merge_all.sh $JARDIR $OUTPUT $FINAL $chr $start $stop 20
