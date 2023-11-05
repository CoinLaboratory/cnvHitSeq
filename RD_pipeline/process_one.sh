#!/bin/sh

#This step requires SAMtools (http://samtools.sourceforge.net/)
#We recommend SAMtools 0.1.18 and above

export JARDIR=$1
export OUTPUTROOT=$2
export INPUTDIR=$3
export OUTPUT=$OUTPUTROOT/Smoothed
export TMPDIR=$OUTPUTROOT

mkdir -p $OUTPUT

#First we filter the BAM file for unmapped and duplicate reads
#The "BAMFilter" class takes 2 arguments:
#-1 the path of the input BAM file
#-2: the path of the filtered output BAM file
java -Xmx3800m -cp $JARDIR/BAMFilter.jar doc.BAMFilter $INPUTDIR/$4 $TMPDIR

echo "Finished filtering file."

#The next step is to sort and pileup the filtered
#BAM file using SAMTools

samtools sort $TMPDIR/$4 $TMPDIR/"$4.sorted"   
samtools mpileup "$TMPDIR/$4.sorted.bam" > $TMPDIR/"$4.pile"
echo "Created BAM pileup."

rm $TMPDIR/$4
rm $TMPDIR/"$4.sorted.bam"

#Then we perform LOESS smoothing on the raw read depth data
#The "Smoothing" class takes 6 arguments:
#-1 the number of neighbouring probes used in the LOESS smoothing
#-2 the name of the sample
#-3 tha path of the pileup file (created using SAMTools)
#-4 the output path
#-5 the start coordinate
#-6 the stop coordinate

java -Xmx3800m -cp $JARDIR/Smoothing.jar doc.Smoothing $5 $4 $TMPDIR/"$4.pile" $OUTPUT/"$4.smoothed.txt" $6 $7
rm $TMPDIR/"$4.pile" 
echo "Finished smoothing file: $4"
