#!/bin/bash
#salloc --time=4:0:0 --cpus-per-task=4 --mem=50G --account=def-jfu --mail-user=rliu13@uoguelph.ca --mail-type=BEGIN
module load python/3.9
source ~/p39_sniffles2.0.7/bin/activate
# set -xv

start_time=`date --date='0 days ago' "+%Y-%m-%d %H:%M:%S"`
sample_name=$(sed -n "7p" /home/maxine91/scratch/sniffles.dir/sample_list) # get the Nth line of sample_list, modify the number manually to get different samples

cd /home/maxine91/scratch/sniffles.dir/individual_calling.dir
echo "Current working directory is $(pwd)."

echo "Individual calling start!"
sniffles --input /home/maxine91/projects/def-jfu/results/divided_minimap.dir/divsorted.$sample_name.bam \
    --snf div.$sample_name.snf \
    --vcf div.$sample_name.vcf \
    --qc-output-all \
    --reference /home/maxine91/projects/def-jfu/data/bufo_genome/dividedNCBIgenome.fna \
    -t 4 \
    --allow-overwrite

if [ $? -eq 0 ]; then
  echo "SV calling for $sample_name succeed!"
else
  echo "SV calling for $sample_name failed."
  exit
fi

finish_time=`date --date='0 days ago' "+%Y-%m-%d %H:%M:%S"`
duration=$(($(($(date +%s -d "$finish_time")-$(date +%s -d "$start_time")))))
dhours=`echo "scale=5;a=$duration/3600;if(length(a)==scale(a)) print 0;print a"|bc`

echo "this shell script execution duration: $duration sec"
echo "this shell script execution duration: $dhours hours"