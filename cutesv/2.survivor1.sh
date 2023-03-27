#!/bin/bash
#SBATCH --time=3:00:00 #e.g. 24:00:00, 1-13:00:00
#SBATCH --job-name=2.survivor1.sh
#SBATCH --mem=14G #e.g. 100G
#SBATCH --account=def-jfu
#SBATCH --cpus-per-task=1
#SBATCH --mail-type=All #Valid type values are NONE, BEGIN, END, FAIL, REQUEUE, ALL (equivalent to BEGIN, END, FAIL, INVALID_DEPEND, REQUEUE, and STAGE_OUT), INVALID_DEPEND (dependency never satisfied), STAGE_OUT (burst buffer stage out and teardown completed), TIME_LIMIT, TIME_LIMIT_90 (reached 90 percent of time limit), TIME_LIMIT_80 (reached 80 percent of time limit), TIME_LIMIT_50 (reached 50 percent of time limit) and ARRAY_TASKS (send emails for each array task).
#SBATCH --mail-user=rliu13@uoguelph.ca
##SBATCH --array=1-12 #e.g.--array=0,6,16-32, --array=0-15:4 (equivalent to --array=0,4,8,12), --array=0-15%4 (limit number of simultaneously running jobs) 
##SBATCH --begin=now #e.g. --begin=16:00, --begin=now+1hour
# Population-based SV calling protocol: 1) Run cuteSV for each sample to generate sample specific SV callsets. 2) Perform SURVIVOR to merge every single vcf into merged.vcf. 3) Rerun cuteSV for each sample with -Ivcf merged.vcf (force calling step). 4) Perform SURVIVOR again to merge every force called single vcf into final_merged.vcf.
# This is STEP 2 out of 4.
set -xv
start_time=`date --date='0 days ago' "+%Y-%m-%d %H:%M:%S"`

# setting variables
sample_list=/home/maxine91/scratch/cutesv2.dir/sample_list
##############################

module load StdEnv/2020 survivor/1.0.7
cd /home/maxine91/scratch/cutesv2.dir

# collect all vcf files
for i in {1..12}
do
sample_name=$(sed -n "${i}p" $sample_list)
ls $sample_name.dir/cutesv2.${sample_name}.vcf >> vcf_files
done 

# merge 12 individual vcfs to one
SURVIVOR merge vcf_files 1000 1 1 1 0 30 12bufo.cutesv.vcf

rm vcf_files

finish_time=`date --date='0 days ago' "+%Y-%m-%d %H:%M:%S"`
duration=$(($(($(date +%s -d "$finish_time")-$(date +%s -d "$start_time")))))
dhours=`echo "scale=5;a=$duration/3600;if(length(a)==scale(a)) print 0;print a"|bc`

echo "this shell script execution duration: $duration sec"
echo "this shell script execution duration: $dhours hours"