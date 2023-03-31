# README.md

Multi-sample SV calling using Sniffles2 population mode works in two steps:

    1.Call SV candidates and create an associated .snf file for each sample: sniffles --input sample1.bam --snf sample1.snf
    2.Combined calling using multiple .snf files into a single .vcf: sniffles --input sample1.snf sample2.snf ... sampleN.snf --vcf multisample.vcf
Alternatively, for step 2. you can supply a .tsv file, containing a list of .snf files, and custom sample ids in an optional second column (one sample per line), .e.g.: 2. Combined calling using a .tsv as sample list: sniffles --input snf_files_list.tsv --vcf multisample.vcf

## 1.individual calling
run interactively on cluster. Usage:
    ```bash
    $ salloc --time=4:0:0 --cpus-per-task=4 --mem=50G --account=def-jfu --mail-user=xxx --mail-type=BEGIN
    salloc: Granted job allocation 1234567
    $ module load python/3.9
    $ source ~/p39_sniffles2.0.7/bin/activate
    $ ./1.individual_calling.sh
