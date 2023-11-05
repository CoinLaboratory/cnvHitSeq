#$1 is the memory to be requested for the job
CURRENTDIR=`pwd`
export GROUP=$CURRENTDIR
export RM=1
export SUB=1
index=1
column=1
loc=$2
prog=$4 ## this is optional with cnvHiTSeq.jar as default
time=$3
param='param.txt'
defi=$(echo $prog | wc -c)
if [ $defi -le 1 ]
then
prog="cnvHiTSeq.jar"
fi
defi=$(echo $time | wc -c)
if [ $defi -le 1 ]
then
time="03:00:00"
fi
defi=$(echo $loc | wc -c)
if [ $defi -le 1 ]
then
loc=$(date +%Y%m%d%H%M)
fi
defi=$(echo $RM | wc -c)
mem=$1mb
mem1=$(( $1 - 200 ))m
grep -v '^#' split.txt > split_temp.txt
n=$(wc -l split_temp.txt | cut -f 1 -d ' ')
echo $n
coli=$[$column+3]
id="cnv_analysis"
echo $id
m=1
path=$(pwd)
while [ $n -ge 1 ]; do
resl=$(tail -n $n split_temp.txt | head -1 )
res3=$(tail -n $n split_temp.txt | head -1| cut -d ' ' -f 2 | sed 's/ /_/g'| sed 's/:/_/g'| sed 's/	/_/g' | sed 's/--mid//g' )
 resfile=$path/$id-$loc
if [ ! -d $resfile ]
 then mkdir $resfile
fi
outpf=$resfile/$res3.zip
echo output is $outpf
if [ -s $outpf ]
   then 
     export sze=$(less $outpf | grep 'phased' | wc -l| cut -f 1)
echo $sze
else
   export sze=0
fi
if [ $sze -eq 0 ]
	then
   if [ $SUB -eq 1 ]
     then
	outp=$id.$n.$index.$column.$res3.sub
	echo "#!/bin/sh" >$outp
	cpu=$(grep 'Thread' $param | cut -d ' ' -f 2)
	cpu=4
	jobname="$sample$res3"
	jobname=`expr substr $jobname 1 15`
	echo "#PBS -N $jobname" >> $outp
	echo "#PBS -l walltime=$time" >> $outp
	echo "#PBS -l mem=$mem" >> $outp
	echo "#PBS -l ncpus=$cpu" >> $outp
	echo "module load java" >> $outp
	echo "export RESULTPAR=$resfile" >> $outp
	echo $resl
	echo "mkdir \$RESULTPAR" >> $outp
	echo "cp $path/data.* \$TMPDIR" >> $outp
	echo "cp $path/$param \$TMPDIR" >> $outp
	echo "cp $path/pheno.txt \$TMPDIR" >> $outp
	echo "cp $path/hmm.in \$TMPDIR" >> $outp
	echo "cp -r $path/results_hmm.txt \$TMPDIR/clust_in" >> $outp
   else
	outp=$n.$index.$column.$res3.sh
	chmod +x $outp
   fi
   echo "java -Xmx$mem1 -Djava.awt.headless=true -server -cp $GROUP/$prog lc1.dp.appl.CNVHap --paramFile $param $resl --baseDir $GROUP/cnvHiTSeq_data/ --numIt 10 --plot 0 --r_panel true --b_panel true --index $index --column $column --include 1000gen:1000genInsert:1000genSplit --weightedInsert true --expModelIntHotSpot 1:1:1e3 --collapseDupStates true" >>$outp
   echo "rm -rf \$TMPDIR/clust_in" >> $outp
   echo "zip -r $res3.zip *" >> $outp
  echo "cp -f $res3.zip \$RESULTPAR/" >> $outp
fi
echo $n
n=$(( $n - 1 ))
done
rm split_temp.txt
