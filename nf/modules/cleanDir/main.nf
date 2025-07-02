/* 
Remove temporary files that diminish storage
*/

process CLEANUP {

    tag "Clean intermediate files such as trimmed reads and sam files"

    conda "/home/schauerm/miniconda3/envs/RNASEQ"

    publishDir "$params.outputDir"

    input:
    path countTable

    script:
    """
    rm -rf ./alignments/*.sam
    rm -rf ./trimmed_reads/*.fastq
    """
}