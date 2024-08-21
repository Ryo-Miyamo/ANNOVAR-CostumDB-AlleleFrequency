# VCF-ANNOVARdb-Converter
Convert VCF files with allele frequency (AF) data to the ANNOVAR database format. This tool is primarily designed for ToMMo VCF files (allele frequency data from the Japanese population provided by jMorp: https://jmorp.megabank.tohoku.ac.jp/), but it supports other VCF files (e.g., VCFs from gnomAD), though compatibility may vary.


## Prerequisites
1. bcftools

2. convert2annovar.pl

## Scripts Included
1. `ToMMoVCFtoAnnovarDB_main.sh` – The main script.

2. `ToMMo_indel_converter_DEL.py` – Sub-script for converting deletions.

3. `ToMMo_indel_converter_INS.py` – Sub-script for converting insertions.


## Quick Usage Guide
1. Clone the repository.

2. Place your `.vcf`, `.vcf.gz`, or `.vcf.bgz` file(s), with or without index files, in the `data` directory. (For instance, place the *tommo-54kjpn-20230626r3-GRCh38-af-autosome.vcf.gz* and *tommo-54kjpn-20230626r3-GRCh38-af-chrX_PAR2.vcf.gz* files, along with their index files, into the data directory. Please be aware of the duplication between the PAR2 and PAR3 files.)
 
3. Edit the main script to update the `Paths Configuration` and, if necessary, specify the column name for ToMMo AF to be included in the final output file.

4. Run the main script.

5. The final output file will be generated in the result directory.


### Note
1. Processing a total of 46 GB of input .vcf.gz files took 2 hours on a machine with an Intel® Core™ i9-10980XE CPU @ 3.00GHz × 36.

2. For exome analysis, consider using a target region VCF from the original VCF, as it can significantly speed up processing with this tool.

3. Usage example in ANNOVAR:

   -protocol refGeneWithVer,*54KJPN_v20230626r3*,gnomad41_exome

   -operation gx,f,f

