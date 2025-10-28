
include { FASTQC } from '/ceph/ibmi/it/projects/ML_BI/RNA-seq_pipeline/nf/modules/fastQC'
include { FASTQCTRIMMED } from '/ceph/ibmi/it/projects/ML_BI/RNA-seq_pipeline/nf/modules/fastQCTrimmed'
include { MAPPINGSE } from '/ceph/ibmi/it/projects/ML_BI/RNA-seq_pipeline/nf/modules/alignment'
include { FILTERSAMTOBAM } from '/ceph/ibmi/it/projects/ML_BI/RNA-seq_pipeline/nf/modules/filteringAlignment'
include { CUTTING } from '/ceph/ibmi/it/projects/ML_BI/RNA-seq_pipeline/nf/modules/trimming'

workflow PROCESSDRNASEQ {
    take: 
        reads
        alignmentBase

    main: 
        if(params.pairedEnd) {
            read_pairs_ch = channel.fromFilePairs(reads)
        }
        else {
            read_pairs_ch = channel.fromFilePairs(reads, size: 1)
        }

        FASTQC(read_pairs_ch)
        
        CUTTING(read_pairs_ch)
        
        FASTQCTRIMMED(CUTTING.out.sampleID, CUTTING.out.trimmedReads)
        
        MAPPINGSE(CUTTING.out.sampleID, CUTTING.out.trimmedReads, alignmentBase)
        
        FILTERSAMTOBAM(MAPPINGSE.out.sampleID, MAPPINGSE.out.samFile)

    emit:
        sortedBamFile = FILTERSAMTOBAM.out.sortedBamFile
        bamIndex = FILTERSAMTOBAM.out.baiFile
        
}