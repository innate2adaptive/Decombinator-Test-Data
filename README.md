# innate2adaptive / Decombinator Test Data
## v2.0
##### Innate2Adaptive lab @ University College London, 2016

--- 

This repository hosts a small sample of TCR data as produced using the Innate2adaptive lab's ligation-mediated 5'RACE amplification protocol. This should allow users to test whether their Decombinator installation is installed and running correctly, and get a feel for how the scripts can be run.

---

## More in depth instructions and the scripts themselves are available from the Decombinator repository, which is located here:
## [https://innate2adaptive.github.io/Decombinator/](https://innate2adaptive.github.io/Decombinator/)

---

These data should no longer than about one minute or so to process on any standard PC or laptop, with the Demultiplexing taking the longest.
However it should be noted that these files are far smaller than what one might typically expect of an actual run.
Here one hundred reads in total are provided.
We typically multiplex six samples (with separate alpha/betas) over a MiSeq run, and therefore process just over 1 million reads per chain per sample.

The following code is sufficient to go from raw FASTQ data to error-corrected Decombinator indices and translated CDR3 sequences, and should hopefully give an overview of how to easily and reproducibly analyse your TCR repertoire files.

```bash
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
```

Included in this repository are also the log files produced by each of the script along the way, which should allow you to check whether your run-through produced the right results.
Note that Decombinator scripts by default will always produce such a log (unless supressed using the `-s` flag).
These files are named in accordance with the input files, where appropriate, and date stamped.
They contain all of the input fields, as well as the output data metrics, and in some cases even some internal variables that are counted as the script progresses (although these are only likely to be of debugging use in the event that users wish to make modifications to the scripts). 
