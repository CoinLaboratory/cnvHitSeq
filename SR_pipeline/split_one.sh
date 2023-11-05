#!/bin/sh

export JARDIR=$1
export OUTPUTROOT=$2
export INPUT=$3
export SUPPL=$5
export OUTPUT=$OUTPUTROOT/split_fastq_files

mkdir -p $OUTPUT

#This class takes a BAM file as input and finds the 
#read pairs that only have one of the reads mapped properly.
#Then it splits the unmapped read in many possible ways and
#stores the results in FASTA files.

#The "SplitUnmappedReads" class takes 5 arguments:
#-1 the path of the input BAM file
#-2 the output path
#-3 the path of the supplementary folder that contains auxilliary files. For this class the folder should contain a text file with gaps in the reference assembly. This can be obtained from http://genome.ucsc.edu/cgi-bin/hgTables using the "Gap" track.
#-4 the chromosome that we are processing
#-5 the minimum length that a split fragment is allowed to have (defaults to 15 but should be set higher for reads longer than 35bp).

java -Xmx3400m -cp $JARDIR/SplitUnmappedReads.jar split_read.SplitUnmappedReads $INPUT/$4 $OUTPUT $SUPPL $6 15

echo "Finished spliting file: $4"
