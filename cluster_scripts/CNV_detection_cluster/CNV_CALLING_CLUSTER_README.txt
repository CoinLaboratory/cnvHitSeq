INSTRUCTIONS
------------

To perform the CNV calling step on a computer cluster we provide an
auxilliary script (create_cluster_jobs.sh) which creates the jobs
to be submitted to the queue. This script requires an extra file
called split.txt, which contains the regions that will be analyzed.
The pre-processed zip files need to be placed in the cnvHiTSeq_data
folder. Also the cnvHiTSeq.jar file needs to be copied into the folder
that contains the script. Once these steps have been completed, the
script can be run with 1 argument that specifies the amount of requested
RAM in Mb:

sh create_cluster_jobs.sh 32000

The script will create one folder and separate job files for each
of the regions defined in split.txt. These job files need to be
submitted to the queue and when finished the results will be saved
in the newly created folder. The queue parameters may need to be
adapted depending on the queueing system and the requirements of
each analysis.
