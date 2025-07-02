/*
    Performs fastqc analysis of a fastq file (gz or unzipped; trimmed or untrimmed)
*/
process FASTQCTRIMMED {

    conda "/home/schauerm/miniconda3/envs/RNASEQ"

    tag "FastQC analysis of trimmed sample ${sampleID}"
    publishDir "$params.outputDir/fastQC", mode: params.pubDirMode
    
    input:
    val sampleID
    path trimmedReads

    output:
    path "fastqc_trimmed_${sampleID}_*", emit: fastqc_post

    script:
    """
    mkdir fastqc_trimmed_${sampleID}_1
    mkdir fastqc_trimmed_${sampleID}_2
    fastqc -o fastqc_trimmed_${sampleID}_1 -q ${trimmedReads[0]}
    fastqc -o fastqc_trimmed_${sampleID}_2 -q ${trimmedReads[1]}
    """
}