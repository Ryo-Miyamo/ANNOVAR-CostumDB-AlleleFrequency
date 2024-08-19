# ToMMoVCF-AnnovarDB-Converter
Convert ToMMo VCF Files to ANNOVAR Database Format

# Prerequisites
bcftools

convert2annovar.pl

# Quick Usage Guide
1. Clone the repository:
git clone <repository-url>

2. Place the ToMMo .vcf or .vcf.gz file(s), with or without index files, in the data directory.
Update the Paths Configuration and specify the column name for ToMMo AF that will appear in the ANNOVAR result file.

3. Run the conversion script:
./ToMMoVCFtoAnnovarDB_main.sh
Note: This process will take approximately 2 hours on an Intel® Core™ i9-10980XE CPU @ 3.00GHz × 36. For exome analysis pipelines, using a VCF file focused on the target region will help save processing time.
