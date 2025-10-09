#!/usr/bin/env nextflow


include { BUILDHISAT2BASE } from './modules/buildHisatBase'
include { PROCESSRNASEQ } from './subworkflows/perReadProcessing'
include { FEATURECOUNTS } from './modules/readCounting'
include { PROCESSDRNASEQ } from './subworkflows/dRNAseqProcessing'
include { CLEANUP } from './modules/cleanDir'
include { MULTIQC } from './modules/multiQC'


def helpMessage() {
    log.info"""
    ==-------------------------------------------------------------------==
    Pipeline for processing dual RNA-seq data for the PhageExpression Atlas
    ==-------------------------------------------------------------------==
    Usage:
    The typical command for running the pipeline is as follows:
    nextflow run rnaseq_workflow.nf --reads '*_{1,2}.fastq.gz' --pairedEnd --hostGenome 'hostGenome.fasta' --hostGFF 'hostGenome.gff' --phageGenome 'phageGenome.fasta' --phageGFF 'phageGenome.gff3'

    Arguments:
      --reads                 Path specifying the reads. E.g. ./*_reads.fastq.gz for single-end, or ./*_reads_{1,2}.fastq.gz
      --outputDir             Output directory.
      --inputDir              Input directory, optional.
      --hostGenome            Host genome path in fasta format.
      --phageGenome           Phage genome path in fasta format.
      --hostGFF               Host genome annotation path in gff3 format.
      --phageGFF              Phage genome annotation path in gff3 format.

      --pairedEnd             Default is false. Set, if paired-end reads are supplied.
      --dRNAseq               Default is false. Would activate dRNA-seq specific processing. Currently not established!

      --adapter1              Default is sequence of TruSeq adapter.
      --adapter2              Default is sequence of TruSeq adapter.

    Arguments can also be set in the config file (./conf/params.config)
    """.stripIndent()
}

// Show help message
params.help = false
if (params.help){
    helpMessage()
    exit 0
}


workflow {
    
    BUILDHISAT2BASE(params.hostGenome, params.phageGenome, params.hostGFF, params.phageGFF)

    if (params.dRNAseq) { //dRNA-seq specific processing
        PROCESSDRNASEQ(params.reads, BUILDHISAT2BASE.out.alignmentBase)
    } 
    else { //RNA-seq processing
        PROCESSRNASEQ(params.reads, BUILDHISAT2BASE.out.alignmentBase)
        FEATURECOUNTS(PROCESSRNASEQ.out.sortedBamFile.collect(), BUILDHISAT2BASE.out.dualGFF)
        MULTIQC(FEATURECOUNTS.out.countSummary, PROCESSRNASEQ.out.cutadaptReport.collect().ifEmpty([]), PROCESSRNASEQ.out.fastqc_pre.collect(), PROCESSRNASEQ.out.fastqc_post.collect())    
    }

}