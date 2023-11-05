#!/bin/sh
#PBS -l walltime=02:00:00
#PBS -l select=1:ncpus=1:mem=8000mb

module load samtools/0.1.18
module load java

export JARDIR=$jar
export OUTPUTROOT=$out
export INPUTDIR=$in
export OUTPUT=$OUTPUTROOT/Smoothed

mkdir -p $OUTPUT

n=$PBS_ARRAY_INDEX
sample=$(ls $INPUTDIR/*.bam | tail -n +$n | head -1)
sample=$(basename $sample)

java -Xmx7800m -server -cp $JARDIR/BAMFilter.jar doc.BAMFilter $INPUTDIR/$sample $TMPDIR

samtools sort $TMPDIR/$sample $TMPDIR/"$sample.sorted"   
samtools mpileup "$sample.sorted.bam" > $TMPDIR/"$sample.pile"

rm $TMPDIR/$sample
rm $TMPDIR/"$sample.sorted.bam"

java -Xmx7800m -server -cp $JARDIR/Smoothing.jar doc.Smoothing $smooth $sample $TMPDIR/"$sample.pile" $OUTPUT/"$sample.smoothed.txt" $start $stop

rm $TMPDIR/"$sample.pile"
