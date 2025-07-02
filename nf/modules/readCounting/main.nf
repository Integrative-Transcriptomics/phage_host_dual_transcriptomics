

process FEATURECOUNTS {

    conda "/home/schauerm/miniconda3/envs/RNASEQ"

    tag "Count reads for all samples"
    publishDir "$params.outputDir/countData", pattern: "*.tsv", mode: params.pubDirMode
    publishDir "$params.outputDir/countData", pattern: "*.tsv.summary", mode: params.pubDirMode
    
    input:
    path sortedBamFiles
    path inputGFF

    output:
    path "countData.tsv", emit: countTable
    path "countData.tsv.summary", emit: countSummary    

    script:
    """
    featureCounts -p -M -O --primary \\
    -a $inputGFF \\
    -t gene \\
    -o countData.tsv \\
    -g ID \\
    $sortedBamFiles
    """

}
