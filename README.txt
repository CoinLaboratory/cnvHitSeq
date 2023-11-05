*******************************************************************************
                                  cnvHiTSeq
*******************************************************************************

SUMMARY
-------

cnvHiTSeq is a set of Java-based command-line tools for detecting Copy Number
Variants (CNVs) using next-generation sequencing data.


AUTHORS
-------

Evangelos Bellos: evangelos.bellos09[at]imperial.ac.uk
Lachlan Coin: l.coin[at]imperial.ac.uk


LICENSE
-------

Copyright (C) <2012>  <Evangelos Bellos>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.


VERSION HISTORY
---------------

Version 0.1.2
- Added auxilliary files and instructions for running the analysis
  on a computer cluster (using the PBS queuing system).

Version 0.1.1
- First public release. Also includes a toy example for illustration
  purposes.


SOFTWARE REQUIREMENTS
---------------------

* Java(TM) Runtime Environment 1.6 (up to update 19) 
* SAMtools (recommended version 0.1.18)
* BWA (recommended version 0.5.8)


SYSTEM REQUIREMENTS
-------------------

Pre-processing (low-coverage, whole chromosome):
- 4GB of RAM
- 4GB of temporary disk space for read depth and read pair
- 8GB of temporary disk space for split read

CNV calling (whole chromosome, regardless of coverage)
- 8GB of RAM
- 1GB of temporary disk space


INSTALL
-------

cnvHiTSeq takes BAM alignment files as input. These files should be placed in
the "input" folder. The software can be run in two separate stages. The first
stage are the pre-processing pipelines and the second is the CNV detection. 
The pre-processing pipelines are optimized for BAM files that contain (at most)
an entire chromosome. Therefore we have provided a script to extract a region
of interest from a large BAM file (extract_chromosome_from_BAM.sh). Here's an
example of how to extract chr8:24,000,000-25,000,000 from a local BAM file:

sh extract_region_from_BAM.sh "./input/test.bam" "./input/chr8_test.bam" "8:24000000-25000000"

The pre-processing pipelines can be run individually per data source using the
3 scripts as follows:

* for read depth: sh RD_pipeline.sh 8 24000000 25000000

* for read pair: sh RP_pipeline.sh 8 24000001 25000001

* for split read: sh SR_pipeline.sh 8 24000002 25000002

or all together using the pre-processing.sh script. The split read pipeline
requires the FASTA sequence file against which the the unmapped read will
be aligned. This file should be placed in the /SR_pipeline/supplementary
folder and renamed to chr*.fasta, where * is the chromosome name. 

Further instructions for the pipelines can be found in the individual scripts
and are also provided by running each jar file with the --help argument.

We also provide examples of parallelized scripts for use with a
PBS queuing system on a computer cluster. These need to be modified
to include the correct paths on the cluster, but otherwise perform
similarly to the previous scripts.

These pre-processing scripts place the results in a new folder named
"pre_processing_results" and copy the pre-processed data sources into
the ./CNV_detection/cnvHiTSeq_data folder. In the end of the pre-processing,
this folder should contain the zip files with the sampled data from each
data source.

Once the pre-processing step is finished, the main algorithm can be run using
the ./CNV_detection/results/run_cnvHiTSeq.sh script without any arguments.
The script uses default settings for the various parameters, which may not be
appropriate for all datasets. These parameters can be changed from the
param.txt and the data.csv files. 

The main algorithm creates separate folders for each run and names them after
the region of choice. Inside these folders, you can find a variety of results,
with the actual CNV calls contained in text files in the "cnv" folder (which are
all identical). If you chose to plot the results using the run_cnvHiTSeq.sh
script, they will appear in the "plot_all_predictionsB" folder. By default
the ploting option is turned off to save time.

