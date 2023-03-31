#!/bin/bash
#salloc --time=1:0:0 --cpus-per-task=10 --mem=50G --account=def-jfu --mail-user=rliu13@uoguelph.ca --mail-type=BEGIN
module load python/3.9
source ~/p39_sniffles2.0.7/bin/activate
# set -xv

start_time=`date --date='0 days ago' "+%Y-%m-%d %H:%M:%S"`
cd /home/maxine91/scratch/sniffles.dir   

echo "Current working directory is $(pwd)."
echo "Multiple merge start!"

sniffles --input /home/maxine91/scratch/sniffles.dir/snf_list.tsv \
    --vcf div.12bufo.vcf \
    --allow-overwrite \
    -t 10

if [ $? -eq 0 ]; then
  echo "Multiple merge succeed!"
else
  echo "Multiple merge failed."
  exit
fi

finish_time=`date --date='0 days ago' "+%Y-%m-%d %H:%M:%S"`
duration=$(($(($(date +%s -d "$finish_time")-$(date +%s -d "$start_time")))))
dhours=`echo "scale=5;a=$duration/3600;if(length(a)==scale(a)) print 0;print a"|bc`

echo "this shell script execution duration: $duration sec"
echo "this shell script execution duration: $dhours hours"