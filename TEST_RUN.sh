# For use with Decombinator v4.3.0+

# The pipeline:
# 1. Searches the FASTQs produced for TCRs with Decombinator
# 2. Error-corrects the n12 files produced by Decombinator with Collapsinator
# Finally, CDR3translator translates the error-correct freq files and extracts their CDR3s

# Most recent sequencing protocols return raw data that is already demultiplexed.
# Therefore, for most cases nowadays, running Demultiplexor is no longer required.

# NOTE: we are running Decombinator on the source FASTQ file twice, once
# with the alpha chain setting (-c a) to detect and retrieve all alpha chain
# reads and again with the beta chain setting (-c b) to extract beta chain.

# NOTE: NovaSeq returns two reads containing FASTQ data in files named *_1.fq.gz, 
# and *_2.fq.gz. For our RACE TCRseq protocol, the *_1.fq.gz contains the 3'-5' read
# which has the V(D)J and CDR3 regions. The *_2.fq.gz read contains the 5'-3' read with the
# other end of the V gene and the barcoding region. More details can be found 
# here: https://www.frontiersin.org/journals/immunology/articles/10.3389/fimmu.2017.01267/full.
# For this reason, we run Decombinator on the data file (TINY_1.fq.gz) and set
# the barcode read file setting to R2 (which will tell Decombinator to look in
# the TINY_2.fq.gz file for barcodes).

# Edit this line to point at your downloaded copy of Decombinator.
PIPELINE=../Decombinator/dcr_pipeline.py

# Call the pipeline once for each chain. Argument descriptions can be found
# in the source code or on the Decombinator github repository.
python $PIPELINE -fq TINY_1.fq.gz -br R2 -bl 42 -c a -ol M13
python $PIPELINE -fq TINY_1.fq.gz -br R2 -bl 42 -c b -ol M13
