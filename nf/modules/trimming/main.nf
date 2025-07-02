process CUTTING {

    conda "/home/schauerm/miniconda3/envs/FLEXBAR"

    tag "Trimming via flexbar"

    input:
    tuple val(sampleID), path(reads)

    output:
    val sampleID, emit: sampleID
    path "${sampleID}_trimmed*.fastq", emit: trimmedReads

    script:
    """
    flexbar -r ${reads[0]} -p ${reads[1]} -a $params.adapters1 --stdout-reads -at LEFT -ac ON -ad RIGHT -m 10 -n 16 | flexbar -r - -i -t ${sampleID}_trimmed -a $params.adapters2 -at RIGHT -m 10 -n 16
    """
}

process TRIM_SE {

    conda "/home/schauerm/miniconda3/envs/RNASEQ"

    tag "Trimming single-end reads via cutadapt $sampleID"
    publishDir "$params.outputDir/cutadapt", pattern: "*.cutadapt.json", mode: params.pubDirMode

    input:
    tuple val(sampleID), path(reads)

    output:
    val sampleID, emit: sampleID
    path "${sampleID}_trimmed.fastq", emit: trimmedReads
    path "${sampleID}.cutadapt.json", emit: cutadaptReport

    script:
    """
    cutadapt -a $params.adapter1 -g $params.adapter2 --json=${sampleID}.cutadapt.json -q 28 --quality-base 33 -o ${sampleID}_trimmed.fastq $reads
    """
}

process TRIM_PE {

    conda "/home/schauerm/miniconda3/envs/RNASEQ"

    tag "Trimming paired-end reads via cutadapt $sampleID"
    publishDir "$params.outputDir/cutadapt", pattern: "*.cutadapt.json", mode: params.pubDirMode

    input:
    tuple val(sampleID), path(reads)

    output:
    val sampleID, emit: sampleID
    path "${sampleID}_trimmed*.fastq", emit: trimmedReads
    path "${sampleID}.cutadapt.json", emit: cutadaptReport

    script:
    """
    cutadapt -a $params.adapter1 -A $params.adapter2 --json=${sampleID}.cutadapt.json -q 28 --quality-base 33 -o ${sampleID}_trimmed_R1.fastq -p ${sampleID}_trimmed_R2.fastq $reads
    """
}

//java -jar trimmomatic-0.39.jar SE $reads ${sampleID}_trimmed.fastq ILLUMINACLIP:TruSeq2-SE:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:20

process TRIMMOMATIC_PE {

    conda "/home/schauerm/miniconda3/envs/RNASEQ"

    tag "Trimming paired-end reads via trimmomatic"

    input:
    tuple val(sampleID), path(reads)

    output:
    val sampleID, emit: sampleID
    path "${sampleID}_trimmed*.fastq", emit: trimmedReads

    script:
    """
    java -jar trimmomatic-0.39.jar PE ${reads[0]} ${reads[1]} ${sampleID}_trimmed_1_paired.fastq ${sampleID}_trimmed_1_unpaired.fastq ${sampleID}_trimmed_2_paired.fastq ${sampleID}_trimmed_2_unpaired.fastq ILLUMINACLIP:TruSeq2-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:20
    """
}