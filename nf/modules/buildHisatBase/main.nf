/* 
Building the hisat2 base for alignment
*/

process BUILDHISAT2BASE {

    tag "Build dual reference genome and Hisat2Base for alignment"
    publishDir "$params.outputDir/alignments", pattern: "*.ht2", mode: params.pubDirMode
    publishDir "$params.outputDir/alignments", patern: "*.gff3", mode: params.pubDirMode

    conda "/home/schauerm/miniconda3/envs/RNASEQ"

    input:
    path hostGenome
    path phageGenome
    path hostGFF
    path phageGFF

    output:
    path("Hisat2Base*", arity: '1..*')
    val "Hisat2Base", emit: alignmentBase
    path "dualGenome.gff3", emit: dualGFF

    script:
    """
    cat $hostGenome $phageGenome > dualGenome.fasta
    cat $hostGFF $phageGFF > dualGenome.gff3
    hisat2-build -f -p 16 dualGenome.fasta Hisat2Base
    """
}