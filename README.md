# innate2adaptive / Decombinator Test Data
## v1.1
##### Innate2Adaptive lab @ University College London, 2016

--- 

This repository hosts a small sample of TCR data as produced using the Innate2adaptive lab's ligation-mediated 5'RACE amplification protoco. This should allow users to test whether their Decombinator installation is installed and running correctly, and get a feel for how the scripts can be run.

---

## More in depth instructions and the scripts themselves are available from the Decombinator repository, which is located here:
## [https://innate2adaptive.github.io/Decombinator/](https://innate2adaptive.github.io/Decombinator/)

---

These data should no longer than about ten minutes or so to process on any standard PC or laptop, with the Demultiplexing taking the longest. However it should be noted that these files are far smaller than what one might typically expect of an actual run. Here half a million reads in total are provided, pooled and subsampled from two separate samples (with alpha and beta chains sequenced on separate indexes). We typically multiplex six samples (with separate alpha/betas) over a MiSeq run, and therefore process just over 1 million reads per chain per sample.

The following code is sufficient to go from raw FASTQ data to error-corrected Decombinator indices and translated CDR3 sequences, and should hopefully give an overview of how to easily and reproducibly analyse your TCR repertoire files.

```bash
# Demultiplex the data, using the index combinations provided in the Indexes.ndx comma-delimited file 
 # Note that I've used the -dz flag, so the FASTQs produced won't be zipped, speeding up the process
python Demultiplexor.py -r1 R1.fastq.gz -r2 R2.fastq.gz -i1 I1.fastq.gz -ix Indexes.ndx -dz

# Search the FASTQs produced for TCRs with Decombinator
 # Note that as the samples have their chains in the file name, no chain designation is required
for f in *fq*; do echo $f; python Decombinator.py -fq $f; done

# Error-correct the n12 files produced by Decombinator
for f in *n12*; do echo $f; python Collapsinator.py -in $f; done

# Finally, translate the error-correct freq files and extract their CDR3s
for f in *freq*; do echo $f; python CDR3translator.py -in $f; done

# Optional tidying up
gzip *fq
mkdir FQ N12 FREQ CDR3
mv *fq* FQ/
mv *n12* N12/
mv *freq* FREQ/
mv *cdr3* CDR3/

```

Included in this repository are also the log files produced by each of the script along the way, which should allow you to check whether your run-through produced the right results. Note that Decombinator scripts by default will always produce such a log (unless supressed using the `-s` flag). These files are named in accordance with the input files, where appropriate, and date stamped. They contain all of the input fields, as well as the output data metrics, and in some cases even some internal variables that are counted as the script progresses (although these are only likely to be of debugging use in the event that users wish to make modifications to the scripts). 