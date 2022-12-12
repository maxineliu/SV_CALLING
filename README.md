# README.md
Population-based SV calling protocol: 1) Run cuteSV for each sample to generate sample specific SV callsets. 2) Perform SURVIVOR to merge every single vcf into merged.vcf. 3) Rerun cuteSV for each sample with -Ivcf merged.vcf (force calling step). 4) Perform SURVIVOR again to merge every force called single vcf into final_merged.vcf

## 1.cutesv.sh
submit series jobs by slurm on cluster
### computational comsuming
| size of reference | size of bam | RAM | CPU | time |
| ----------------- | --- | --- | ---- | ----- |
|    4.3G      |   81G  |  24G  |  24  |  1.6 hours   |
|    4.3G    |   50G  |  24G   |  24  | 42 mins  |
|         |    |    |    |    |
## 2.survivor1.sh
running locally

## 3.cutesv_force.sh
submit series jobs by slurm on cluster
### computational comsuming
| size of reference | size of bam | RAM | CPU | time |
| ----------------- | --- | --- | ---- | ----- |
|    4.3G      |   81G  |  24G  |  24  |     |
|    4.3G    |   50G  |  24G   |  24  |     |
|         |    |    |    |    |
## 4.survivor2.sh
running locally
