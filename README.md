# Processing of dual RNA-seq data for the PhageExpressionAtlas

This repo contains the code for processing dual RNA-seq data as currently hosted in the PhageExpressionAtlas (**LINK**). First, a nextflow pipeline is used to trim paired-end or single-end RNA-seq reads, check their quality, map the reads to a dual genome, filter the alignments and count reads. A Jupyter Notebook is then used to annotate pre-process the count data for storage and analysis with the PhageExpressionAtlas.

## Nextflow pipeline


### Tools in the pipeline

This pipeline makes use of the following tools:

- quality control: fastQC, multiQC
- adapter & quality trimming: cutadapt
- read mapping (and dual reference genome indexing): hisat2
- alignment processing: samtools
- feature counting: featureCounts


### Installation & usage

Installation of conda environment from file:

```bash
conda env create -f /env/env_nextflow.yml
```

or, when using mamba:

```bash
mamba env create -f /env/env_nextflow.yml
```

- Nextflow installation on platform


### Input & parameters

Input can be specified from command line or in /nf/conf/params.config.

- hostGenome, phageGenome: provide absolute paths to full genomic fasta files.
- hostGFF, phageGFF: provide absolute paths to full genomic feature annotation files.
- pairedEnd: call, if dealing with paired-end RNA-seq data
- dRNAseq: this flag will direct to dRNA-seq processing, but is not yet implemented
- reads: absolute path to sreads in fastq format, can also be compressed as *.fastq.gz
- outputDir: absolute path to output directory
- adapter1, adapter2: by deafult Illumina TruSeq adapter sequences, which can be adjusted, if others used
- countFeature, featureIdentifier: specify feature to count with using featureCounts and the identifier used from the GFF file


### Pipeline steps explained intuitively



### Output


## Pre-processing with the Juypter notebook


### Steps


### Output


## Customization of workflow



## Contributing to the PhageExpressionAtlas


## References & Acknowledgements