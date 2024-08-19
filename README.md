# ToMMoVCF-AnnovarDB-Converter
Convert ToMMo VCF files to the ANNOVAR database format, including insertions and deletions.


## Prerequisites
1. bcftools

2. convert2annovar.pl

## Scripts Included
1. `ToMMoVCFtoAnnovarDB_main.sh` – The main script.

2. `ToMMo_indel_converter_DEL.py` – Subscript for converting deletions.

3. `ToMMo_indel_converter_INS.py` – Subscript for converting insertions.


## Quick Usage Guide
1. Clone the repository.

2. Place the ToMMo `.vcf` or `.vcf.gz` file(s), with or without index files, in the `data` directory.
 
3. Edit the main conversion shell script to update the `Paths Configuration` and, if necessary, specify the column name for ToMMo AF to be included in the ANNOVAR result file.

4. Run the main conversion shell script.

5. The final output file will be generated in the result directory.


### Note
1. This process will take approximately 2 hours on an Intel® Core™ i9-10980XE CPU @ 3.00GHz × 36.

2. Restricting the input VCF file to the target region (e.g., for exome analysis) can significantly reduce the analysis time with this tool.

3. Usage example in ANNOVAR:

   -protocol refGeneWithVer,54KJPN_v20230626r3,gnomad41_exome \

   -operation gx,f,f

