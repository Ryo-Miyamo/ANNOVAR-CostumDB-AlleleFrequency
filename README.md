sorry now updating...

# VCF-ANNOVARdb-Converter
Convert VCF files with allele frequency (AF) data to the ANNOVAR database format. This tool is primarily designed for ToMMo VCF files (allele frequency data from the Japanese population provided by jMorp: https://jmorp.megabank.tohoku.ac.jp/), but it supports other VCF files (e.g., VCFs from gnomAD), though compatibility may vary.


## Prerequisites
1. bcftools

2. convert2annovar.pl

## Scripts Included
1. `VCFtoAnnovarDB_main.sh` – The main script.

2. `VCFtoAnnovarDB_indel_converter_DEL.py` – Sub-script for converting deletions.

3. `VCFtoAnnovarDB_indel_converter_INS.py` – Sub-script for converting insertions.

#### Processing Flow
1. Extract fields from the VCF file by bcftools query.
2. Convert the data to one variant per line.
3. Split the file based on the comparison of REF and ALT lengths: REF > ALT: _deletion.txt, REF < ALT: _insertion.txt, REF = ALT: _others.txt
4. Convert to ANNOVAR database format using the .py scripts for _deletion.txt and _insertion.txt, and convert2annovar.pl for _others.txt.

## Quick Usage Guide
1. Clone the repository.

2. Place your `.vcf`, `.vcf.gz`, or `.vcf.bgz` file(s), with or without index files, in the `data` directory. (For instance, place the *tommo-54kjpn-20230626r3-GRCh38-af-autosome.vcf.gz* and *tommo-54kjpn-20230626r3-GRCh38-af-chrX_PAR2.vcf.gz* files, along with their index files, into the data directory. Please be aware of the duplication between the PAR2 and PAR3 files.)
 
3. Edit the main script to update the `Paths Configuration` and, if necessary, specify the column name (`colname_ANN`) to be included in the final output file.

4. Assign execution permissions to the main script and run the script.

5. The final output file will be generated in the result directory.


### Note
1. Processing a total of 46 GB of input .vcf.gz files took 2 hours on a machine with an Intel® Core™ i9-10980XE CPU @ 3.00GHz × 36.

2. For exome analysis, using a target region VCF significantly save time.

3. This tool processes all VCF files in the data directory, so ensure that only the VCF files you want to process are placed there.

4. Usage example in ANNOVAR:

   -protocol refGeneWithVer,`54KJPN_v20230626r3`,gnomad41_exome

   -operation gx,`f`,f

   (The protocol name corresponds to the `colname_ANN` in the main script. The value of `colname_ANN` is also reflected in the name of the final output file.)

