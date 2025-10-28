
include { FASTQC } from "${projectDir}/modules/fastQC"
include { FASTQCTRIMMED } from "${projectDir}/modules/fastQCTrimmed"
include { MAPPINGPE } from "${projectDir}/modules/alignment"
include { MAPPINGSE } from "${projectDir}/modules/alignment"
include { FILTERSAMTOBAM } from "${projectDir}/modules/filteringAlignment"
include { TRIM_SE } from "${projectDir}/modules/trimming"
include { TRIM_PE } from "${projectDir}/modules/trimming"

workflow PROCESSRNASEQ {
    take: 
        reads
        alignmentBase

    main: 
        if(params.pairedEnd) {
            read_pairs_ch = channel.fromFilePairs(reads, size: 2, checkIfExists: true)
            FASTQC(read_pairs_ch)
            TRIM_PE(read_pairs_ch)
            FASTQCTRIMMED(TRIM_PE.out.sampleID, TRIM_PE.out.trimmedReads)
            MAPPINGPE(TRIM_PE.out.sampleID, TRIM_PE.out.trimmedReads, alignmentBase)
            FILTERSAMTOBAM(MAPPINGPE.out.sampleID, MAPPINGPE.out.samFile)
            cutadaptReport = TRIM_PE.out.cutadaptReport
        }
        else {
            read_pairs_ch = channel.fromFilePairs(reads, size: -1, checkIfExists: true)
            FASTQC(read_pairs_ch)
            TRIM_SE(read_pairs_ch)
            FASTQCTRIMMED(TRIM_SE.out.sampleID, TRIM_SE.out.trimmedReads)
            MAPPINGSE(TRIM_SE.out.sampleID, TRIM_SE.out.trimmedReads, alignmentBase)
            FILTERSAMTOBAM(MAPPINGSE.out.sampleID, MAPPINGSE.out.samFile)
            cutadaptReport = TRIM_SE.out.cutadaptReport
        }

    emit:
        sortedBamFile = FILTERSAMTOBAM.out.sortedBamFile
        bamIndex = FILTERSAMTOBAM.out.baiFile
        cutadaptReport = cutadaptReport
        fastqc_pre = FASTQC.out.fastqc_pre
        fastqc_post = FASTQCTRIMMED.out.fastqc_post
}