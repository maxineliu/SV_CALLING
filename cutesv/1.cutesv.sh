#!/bin/bash
#SBATCH --time=3:00:00 #e.g. 24:00:00, 1-13:00:00
#SBATCH --job-name=cutesv
#SBATCH --mem=24G #e.g. 100G
#SBATCH --account=def-jfu
#SBATCH --cpus-per-task=24
#SBATCH --mail-type=All #Valid type values are NONE, BEGIN, END, FAIL, REQUEUE, ALL (equivalent to BEGIN, END, FAIL, INVALID_DEPEND, REQUEUE, and STAGE_OUT), INVALID_DEPEND (dependency never satisfied), STAGE_OUT (burst buffer stage out and teardown completed), TIME_LIMIT, TIME_LIMIT_90 (reached 90 percent of time limit), TIME_LIMIT_80 (reached 80 percent of time limit), TIME_LIMIT_50 (reached 50 percent of time limit) and ARRAY_TASKS (send emails for each array task).
#SBATCH --mail-user=rliu13@uoguelph.ca
#SBATCH --array=1-12 #e.g.--array=0,6,16-32, --array=0-15:4 (equivalent to --array=0,4,8,12), --array=0-15%4 (limit number of simultaneously running jobs) 
##SBATCH --begin=now #e.g. --begin=16:00, --begin=now+1hour

set -xv
start_time=`date --date='0 days ago' "+%Y-%m-%d %H:%M:%S"`

cd /home/maxine91/scratch/cutesv2.dir
echo "Starting task $SLURM_ARRAY_TASK_ID"
sample_name=$(sed -n "${SLURM_ARRAY_TASK_ID}p" sample_list)

mkdir ${sample_name}.dir
cd ${sample_name}.dir

module load apptainer/1.0

# svs calling
apptainer exec -e -B /home -B /scratch -B /project ~/cutesv_2.0.2.sif \
    cuteSV --max_cluster_bias_INS 100 --diff_ratio_merging_INS 0.3 --max_cluster_bias_DEL 200 --diff_ratio_merging_DEL 0.5 \
        --report_readid -t 24 --genotype \
        /home/maxine91/projects/def-jfu/results/minimap2_bufo.dir/aln.sorted.${sample_name}.bam \
        /home/maxine91/projects/def-jfu/data/bufo_genome/GCF_014858855.1_ASM1485885v1_genomic.fa \
        cutesv2.${sample_name}.vcf \
        ./

if [ $? -eq 0 ]
then
    echo "cutesv completes!"
else 
    echo "cutesv failed!"
fi

finish_time=`date --date='0 days ago' "+%Y-%m-%d %H:%M:%S"`
duration=$(($(($(date +%s -d "$finish_time")-$(date +%s -d "$start_time")))))
dhours=`echo "scale=5;a=$duration/3600;if(length(a)==scale(a)) print 0;print a"|bc`

echo "this shell script execution duration: $duration sec"
echo "this shell script execution duration: $dhours hours"

