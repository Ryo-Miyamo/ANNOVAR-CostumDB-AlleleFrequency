#!/bin/bash

# Paths Configuration

# Base directory for the ToMMoVCFtoAnnovarDB project
# Update this path to point to your local ToMMoVCFtoAnnovarDB directory
Home_Dir="/home/user/Research/Tools/ToMMoVCFtoAnnovarDB/"

# Path to the ANNOVAR conversion script (convert2annovar.pl)
# Update this path to point to your local copy of convert2annovar.pl
annovar_script="/home/user/Research/Pipeline_Rev1/Command/annovar-2019Oct24/convert2annovar.pl"

# Directory Paths Configuration
# Input_Dir: Directory where the input files are located
# Tmp_Dir: Directory used for temporary files during processing
# Output_Dir: Directory where the final output files will be saved
Input_Dir="data/"
Tmp_Dir="tmp/"
Output_Dir="result/"

# Culumn name for ToMMo AF
# Change this value to the appropriate column name for your dataset
colname_ToMMo="54KJPN_v20230626r3"  # Example value, customize as needed

# Check if the Home_Dir exists
if [ ! -d "$Home_Dir" ]; then
    echo "Home directory $Home_Dir does not exist."
    exit 1
fi

cd "$Home_Dir" || exit

# Check if the necessary scripts exist
required_scripts=(
    "ToMMoVCFtoAnnovarDB_main.sh"
    "ToMMo_indel_converter_DEL.py"
    "ToMMo_indel_converter_INS.py"
)

for script in "${required_scripts[@]}"; do
    script_path="${Home_Dir}script/$script"
    if [ ! -f "$script_path" ]; then
        echo "Required script $script_path does not exist."
        exit 1
    fi
done

# Create the temporary and output directory if it does not exist
mkdir -p "$Tmp_Dir"
mkdir -p "$Output_Dir"

# Process each .vcf and .vcf.gz file in the Input_Dir
# For each file, run `bcftools query` to extract fields and save results to Tmp_Dir
echo "Executing bcftools query to extract relevant fields..."
for file in "${Input_Dir}"*.vcf "${Input_Dir}"*.vcf.gz; do
    # Ensure that the file exists and has a .vcf or .vcf.gz extension
    if [[ -f "$file" && ( "$file" == *.vcf || "$file" == *.vcf.gz ) ]]; then
        filename=$(basename "$file")
        output_file="${Tmp_Dir}${filename%.*}_query_result.txt"

        # Run bcftools query command
        bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%AF\n' "$file" > "$output_file"

        # Print status message
        echo "Processed $file -> $output_file"
    fi
done
echo "Field extraction with bcftools query completed."

# Concatenate all query_result.txt files in the Tmp_Dir into a single file
echo "Concatenating query_result.txt files into query_combined_result.txt..."
cat "${Tmp_Dir}"*query_result.txt > "${Tmp_Dir}query_combined_result.txt"
echo "Concatenation complete. All files combined into query_combined_result.txt."


# Remove individual query_result.txt files
rm "${Tmp_Dir}"*query_result.txt

# Convert combined_query_result.txt to one variant per line
echo "Transforming to one variant per line..."
awk 'BEGIN {FS="\t"; OFS="\t"}
{
    split($4, alt_variants, ",");
    split($5, frequencies, ",");

    if (length(alt_variants) == length(frequencies)) {
        for (i = 1; i <= length(alt_variants); i++) {
            print $1, $2, $3, alt_variants[i], frequencies[i];
        }
    }
    else {
        print "Error: Number of variants does not match number of frequencies at line", NR;
    }
}' "${Tmp_Dir}query_combined_result.txt" > "${Tmp_Dir}query_combined_result_1perline.txt"

rm "${Tmp_Dir}query_combined_result.txt"
echo "Transformation completed: One variant per line."

# Split file based on length comparison of fields 3 and 4
echo "Splitting file based on length comparison of fields 3(ref) and 4(alt)..."
awk '
{
    len3 = length($3)
    len4 = length($4)
    
    if (len3 == len4) {
        print $0 >> "'${Tmp_Dir}query_combined_result_others.txt'"
    } else if (len3 > len4) {
        print $0 >> "'${Tmp_Dir}query_combined_result_deletion.txt'"
    } else {
        print $0 >> "'${Tmp_Dir}query_combined_result_insertion.txt'"
    }
}
' "${Tmp_Dir}query_combined_result_1perline.txt"
echo "Data splitting completed."

# Delete temporary line-by-line result file
rm "${Tmp_Dir}query_combined_result_1perline.txt"

# Add header
header="chr\tpos\tref\talt\tAF"
echo "Adding header to split files..."
files=(
    "${Tmp_Dir}query_combined_result_others.txt"
    "${Tmp_Dir}query_combined_result_deletion.txt"
    "${Tmp_Dir}query_combined_result_insertion.txt"
)

for file in "${files[@]}"; do
    {
        echo -e "$header"
        cat "$file"
    } > "${file}.tmp" && mv "${file}.tmp" "$file"
done
echo "Headers added to split files."

# INDEL conversion and transform to annovardb format
echo "Converting INDELs..."

python "${Home_Dir}script/ToMMo_indel_converter_DEL.py"
echo "Python script (DEL conversion) executed."

python "${Home_Dir}script/ToMMo_indel_converter_INS.py"
echo "Python script (INS conversion) executed."

echo "INDEL conversion completed."

# Run convert2annovar.pl for "others.txt"
echo "Running ANNOVAR conversion for 'others.txt'..."
cat "${Tmp_Dir}query_combined_result_others.txt" | awk 'BEGIN {FS="\t";OFS="\t"} {print $1,$2,".",$3,$4,"1000","PASS",$5}' | sed -e '1d' | sed '1i#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO' > "${Tmp_Dir}query_combined_result_others.vcf"
perl $annovar_script -format vcf4 "${Tmp_Dir}query_combined_result_others.vcf" > "${Tmp_Dir}query_combined_result_others_C2A.txt" -includeinfo
cat "${Tmp_Dir}query_combined_result_others_C2A.txt" | awk 'BEGIN {FS="\t";OFS="\t"} {print $1,$2,$3,$4,$5,$13}' > "${Tmp_Dir}query_combined_result_others_converted.txt"

# Concatenate and sort converted files, add header
echo "Concatenating and sorting converted files..."
cat "${Tmp_Dir}"*converted.txt | sort -k 1V -k 2n -k 3n | sed '1i#Chr\tStart\tEnd\tRef\tAlt\t'"$colname_ToMMo" > "${Output_Dir}hg38_${colname_ToMMo}.txt"
echo "Final output saved to ${Output_Dir}hg38_${colname_ToMMo}.txt."

# Remove query_combined files in the tmp directory
echo "Removing temporary files in the tmp directory..."
rm -f "${Tmp_Dir}"query_combined_*
echo "Temporary files in the tmp directory have been removed."


