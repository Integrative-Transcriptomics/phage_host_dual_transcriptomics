process MULTIQC {

    conda "/home/schauerm/miniconda3/envs/MULTIQC"

    tag "multiQC analysis of processes"
    publishDir "$params.outputDir/multiQC", pattern: "*.html", mode: params.pubDirMode

    input:
    path countSummary
    path cutadaptReport
    path fastqc_pre
    path fastqc_post

    output:
    path "multiQC_report.html"

    script:
    """
    multiqc . -n multiQC_report.html --no-data-dir -m custom_content -m preseq -m rseqc -m featureCounts -m star -m cutadapt -m fastqc -m qualimap -m salmon
    """
}