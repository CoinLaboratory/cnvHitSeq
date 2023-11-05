#!/bin/sh
#PBS -l walltime=2:00:00
#PBS -l select=1:ncpus=2:mem=16000mb


module load bio-bwa/0.5.8

export JARDIR=$jar
export OUTPUTROOT=$out
export SUPPL=$suppl
export FASTQ=$OUTPUTROOT/split_fastq_files
export OUTPUT=$OUTPUTROOT/alignments
export TEMPDIR=$OUTPUTROOT/Temp

mkdir -p $OUTPUT
mkdir -p $TEMPDIR

bwa aln -o 0 -e -1 -i 50 -t 4 $SUPPL/chr$chr.fasta $FASTQ/$sample._1.fastq > $TEMPDIR/aln_$sample._1.bwa.sai
bwa aln -o 0 -e -1 -i 50 -t 4 $SUPPL/chr$chr.fasta $FASTQ/$sample._2.fastq > $TEMPDIR/aln_$sample._2.bwa.sai

bwa sampe $SUPPL/chr$chr.fasta $TEMPDIR/"aln_$sample._1.bwa.sai" $TEMPDIR/"aln_$sample._2.bwa.sai" $FASTQ/"$sample._1.fastq" $FASTQ/"$sample._2.fastq" -a $maxDistance -n 10000 -N 10000 -A -P | $JARDIR/splitBWA.pl > $OUTPUT/"$sample.sam"
