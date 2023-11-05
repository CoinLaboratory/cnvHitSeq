#!/bin/sh

#This step requires the BWA aligner, which can be found
#here http://bio-bwa.sourceforge.net/
#We recommend using BWA version 0.5.8

export JARDIR=$1
export OUTPUTROOT=$2
export SUPPL=$4
export FASTQ=$OUTPUTROOT/split_fastq_files
export OUTPUT=$OUTPUTROOT/alignments
export TMPDIR=$OUTPUTROOT

mkdir -p $OUTPUT

#We use BWA to align the split fragments to the reference sequence.
#The reference sequence (FASTA file) needs to be in the auxilliary folder

bwa aln -o 0 -e -1 -i 50 -t 4 $SUPPL/chr$5.fasta $FASTQ/"$3._1.fastq" > $TMPDIR/"aln_$3._1.bwa.sai"
bwa aln -o 0 -e -1 -i 50 -t 4 $SUPPL/chr$5.fasta $FASTQ/"$3._2.fastq" > $TMPDIR/"aln_$3._2.bwa.sai"

#The BWA "sampe" command needs an indexed FASTA file of the reference which should be in the supplementary folder
#We also disable the estimation of the insert size (-A), because the splits are by definition abnormal and should not be modelled by BWA.
#By default we report a large number of alternative alignments for each split fragment (-N 10000)

#The result of sampe is piped to a perl script (splitBWA.pl) that processes the alignments,
#finds "consistent" splits and saves the result in the SAM format

bwa sampe $SUPPL/chr$5.fasta $TMPDIR/"aln_$3._1.bwa.sai" $TMPDIR/"aln_$3._2.bwa.sai" $FASTQ/"$3._1.fastq" $FASTQ/"$3._2.fastq" -a $maxDistance -n 10000 -N 10000 -A -P | $JARDIR/splitBWA.pl > $OUTPUT/"$3.sam"

rm -rf $TMPDIR/"aln_$3._1.bwa.sai"
rm -rf $TMPDIR/"aln_$3._2.bwa.sai"
rm -rf $FASTQ

echo "Finished aligning split reads for file: $3"
