#!/bin/bash
# Population-based SV calling protocol: 1) Run cuteSV for each sample to generate sample specific SV callsets. 2) Perform SURVIVOR to merge every single vcf into merged.vcf. 3) Rerun cuteSV for each sample with -Ivcf merged.vcf (force calling step). 4) Perform SURVIVOR again to merge every force called single vcf into final_merged.vcf.
# This is STEP 4 out of 4.
# setting variables
sample_list=/home/maxine91/scratch/cutesv2.dir/sample_list
##############################

module load StdEnv/2020 survivor/1.0.7
cd /home/maxine91/scratch/cutesv2.dir

# collect all vcf files
for i in {1..12}
do
sample_name=$(sed -n "${i}p" $sample_list)
ls $sample_name.dir/cutesv2.force.${sample_name}.vcf >> force_vcf_files
done 

# merge 12 individual vcfs to one
SURVIVOR merge force_vcf_files 1000 1 1 1 0 30 12bufo.force.cutesv.vcf