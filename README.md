# innate2adaptive / Decombinator Test Data

## v3.0

### Innate2Adaptive lab @ University College London, 2016

---

This repository hosts a small sample of TCR data as produced using the Innate2adaptive lab's ligation-mediated 5'RACE amplification protocol. This should allow users to test whether their Decombinator installation is installed and running correctly, and get a feel for how the scripts can be run.

---

## More in depth instructions and the scripts themselves are available from the Decombinator repository, which is located here:
## [https://innate2adaptive.github.io/Decombinator/](https://innate2adaptive.github.io/Decombinator/)

---

These data should take no longer than about 10 seconds or so to process on any standard PC or laptop.
However, it should be noted that these files are far smaller than what one might typically expect of an actual run.
Here one hundred reads in total are provided.

The following code is sufficient to go from raw FASTQ data to error-corrected Decombinator indices and translated CDR3 sequences, and should hopefully give an overview of how to easily and reproducibly analyse your TCR repertoire files.

```bash
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
```

Included in this repository are also the log files produced by each of the main steps of the pipeline, which should allow you to check whether your run-through produced the right results.
Using your favourite method of file comparison (e.g. `diff` on Linux), the files should be identical except for the metadata at the top of each log.
Note that the pipeline by default will always produce such a log (unless suppressed using the `-s` flag).
These files are name-matched to the input files and date-stamped.
They contain all of the input fields, as well as the output data metrics, and in some cases even some internal variables that are counted as the script progresses (useful for debugging if users wish to make modifications to the scripts).
