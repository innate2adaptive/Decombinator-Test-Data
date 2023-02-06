# Most recent sequencing protocols return raw data that is already demultiplexed.
# Therefore, for most cases nowadays, running Demultiplexor is no longer required.

# Search the FASTQs produced for TCRs with Decombinator

# NOTE: we are running Decombinator on the source FASTQ file twice, once
# with the alpha chain setting (-c a) to detect and retrieve all alpha chain
# reads and again with the beta chain setting (-c b) to extract beta chain.

# NOTE: NovaSeq returns sequencing FASTQ data in files named *_1.fq.gz, while
# the barcoding data is stored in a near-equivalently named *_2.fq.gz file.
# For this reason, we run Decombinator on the data file (TINY_1.fq.gz) and set
# the barcode read file setting to R2 (which will tell Decombinator to look in
# the TINY_2.fq.gz file for barcodes).
python Decombinator.py -fq TINY_1.fq.gz -br R2 -bl 42 -c a
python Decombinator.py -fq TINY_1.fq.gz -br R2 -bl 42 -c b

# Error-correct the n12 files produced by Decombinator
for f in *n12*; do echo $f; python Collapsinator.py -in $f -ol M13; done

# Finally, translate the error-correct freq files and extract their CDR3s
for f in *freq*; do echo $f; python CDR3translator.py -in $f; done

# Optional tidying up
mkdir FQ N12 FREQ TSV
mv *fq* FQ/
mv *n12* N12/
mv *freq* FREQ/
mv *tsv* TSV/
