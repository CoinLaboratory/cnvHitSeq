#!/bin/sh
#PBS -l walltime=1:00:00
#PBS -l select=1:ncpus=1:mem=8000mb

module load java
module load samtools

export JARDIR=$jar
export OUTPUTROOT=$out
export INPUT=$in
export OUTPUT=$OUTPUTROOT/Processed

mkdir -p $OUTPUT

n=$PBS_ARRAY_INDEX
sample=$(ls $INPUT/*.bam | tail -n +$n | head -1)
sample=$(basename $sample)

samtools sort $INPUT/$sample $TMPDIR/"$sample.sorted"
samtools index "$sample.sorted.bam"

java -Xms7800m -Xmx7800m -server -cp $JARDIR/ProcessInsertSize.jar paired_end.ProcessInsertSize $TMPDIR/"$sample.sorted.bam" $TMPDIR $OUTPUT $maxInsertSize

rm -rf $TMPDIR/full_split
rm -rf $TMPDIR/sorted_ranked_signed_libraries
rm -rf $TMPDIR/normalized_to_each_other
rm -rf $TMPDIR/final_libraries
