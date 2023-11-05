#!/bin/sh

#This step requires SAMtools (http://samtools.sourceforge.net/)
#We recommend using SAMtools version 0.1.18

export JARDIR=$1
export OUTPUTROOT=$2
export INPUT=$3
export OUTPUT=$OUTPUTROOT/Processed
export TMPDIR=$OUTPUTROOT

mkdir -p $OUTPUT

#First we sort and index the input BAM file using SAMtools

samtools sort $INPUT/$4 $TMPDIR/"$4.sorted"
samtools index "$TMPDIR/$4.sorted.bam"

#Then we split the BAM file into its individual libraries and normalize the libraries
#The "ProcessInsertSize" class takes 4 arguments:
#-1 the path of the input BAM file
#-2 the path of the temporary directory where the intermediate files will be stored
#-3 the output path
#-4 the maximum allowed RP distance (defaults to 200000bp)

java -Xmx3800m -cp $JARDIR/ProcessInsertSize.jar paired_end.ProcessInsertSize $TMPDIR/"$4.sorted.bam" $TMPDIR $OUTPUT 200000> $OUTPUTROOT/process_output.txt

#Delete the intermediate files
rm $TMPDIR/"$4.sorted.bam"
rm $TMPDIR/"$4.sorted.bam.bai"
rm -rf $TMPDIR/full_split
rm -rf $TMPDIR/sorted_ranked_signed_libraries
rm -rf $TMPDIR/normalized_to_each_other
rm -rf $TMPDIR/final_libraries

echo "Finished processing file: $4"
