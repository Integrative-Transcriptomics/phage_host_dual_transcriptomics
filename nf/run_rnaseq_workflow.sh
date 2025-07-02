# Test run:
# nextflow run rnaseq_workflow.nf --reads '/ceph/ibmi/it/projects/ML_BI/06_PhageExpressionAtlas/Analysis_pipeline/input/reads/*.fastq.gz' -resume

# Run for entire Wolfram-Schauerte et al., 2022 dataset
#nextflow run rnaseq_workflow.nf --reads '/ceph/ibmi/it/projects/ML_BI/06_PhageExpressionAtlas/Data/Wolfram-Schauerte_2022/raw_data/*.fastq.gz'

# Run for entire Kuptsov et al., 2022 dataset
nextflow run rnaseq_workflow.nf --reads '/ceph/ibmi/it/projects/ML_BI/06_PhageExpressionAtlas/Data/Kuptsov_2022/raw_data/*_{1,2}.fastq.gz' --pairedEnd --hostGenome '/ceph/ibmi/it/projects/ML_BI/06_PhageExpressionAtlas/Analysis_pipeline/input/reference/GCA_022352045-1.fasta' --hostGFF '/ceph/ibmi/it/projects/ML_BI/06_PhageExpressionAtlas/Analysis_pipeline/input/reference/GCA_022352045-1.gff' --phageGenome '/ceph/ibmi/it/projects/ML_BI/06_PhageExpressionAtlas/Analysis_pipeline/input/reference/MN047438-1.fasta' --phageGFF '/ceph/ibmi/it/projects/ML_BI/06_PhageExpressionAtlas/Analysis_pipeline/input/reference/MN047438-1.gff3'