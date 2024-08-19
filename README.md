# ToMMoVCF-AnnovarDB-Converter
Convert ToMMo VCF Files to ANNOVAR Database Format

## Prerequisites
1. bcftools

2. convert2annovar.pl

## Quick Usage Guide
1. Clone the repository.

3. Place the ToMMo .vcf or .vcf.gz file(s), with or without index files, in the data directory.
 
4. Update the Paths Configuration and specify the column name for ToMMo AF that will appear in the ANNOVAR result file.

5. Run the conversion script (ToMMoVCFtoAnnovarDB_main.sh)


### Note
1. This process will take approximately 2 hours on an Intel® Core™ i9-10980XE CPU @ 3.00GHz × 36.

3. For exome analysis pipelines, using a VCF file focused on the target region will help save processing time.
