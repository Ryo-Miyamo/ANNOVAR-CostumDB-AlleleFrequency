# ToMMoVCF-AnnovarDB-Converter
Convert ToMMo VCF files (allele frequency data of the Japanese from jMorp [https://jmorp.megabank.tohoku.ac.jp/]) to the ANNOVAR database format, including insertions and deletions.


## Prerequisites
1. bcftools

2. convert2annovar.pl

## Scripts Included
1. `ToMMoVCFtoAnnovarDB_main.sh` – The main script.

2. `ToMMo_indel_converter_DEL.py` – Subscript for converting deletions.

3. `ToMMo_indel_converter_INS.py` – Subscript for converting insertions.


## Quick Usage Guide
1. Clone the repository.

2. Place the ToMMo `.vcf` or `.vcf.gz` file(s), with or without index files, in the `data` directory. (As an example, place the `tommo-54kjpn-20230626r3-GRCh38-af-autosome.vcf.gz` and `tommo-54kjpn-20230626r3-GRCh38-af-chrX_PAR2.vcf.gz` files, along with their index files, into the data directory. Please be aware of the duplication between the PAR2 and PAR3 files. As of 2024/08/18.)
 
3. Edit the main script to update the `Paths Configuration` and, if necessary, specify the column name for ToMMo AF to be included in the ANNOVAR result file.

4. Run the main script.

5. The final output file will be generated in the result directory.


### Note
1. The processing time took 2 hours on a machine with an Intel® Core™ i9-10980XE CPU @ 3.00GHz × 36.

2. Restricting the input VCF file to the target region (e.g., for exome analysis) can significantly reduce the processing time with this tool.

3. Usage example in ANNOVAR:

   -protocol refGeneWithVer,54KJPN_v20230626r3,gnomad41_exome \

   -operation gx,f,f

