import os
import pandas as pd
import warnings

def find_diff(ref, alt, row_data):
    """Find the contiguous sequence in 'ref' that is not in 'alt' and issue a warning if no match is found."""
    if pd.isna(ref) or pd.isna(alt):
        return ''  # Return an empty string if either ref or alt is NaN
    if len(ref) == 0:
        return alt
    if len(alt) == 0:
        return ref

    if len(alt) == 1:
        # Handle the case where alt is a single character
        if ref.startswith(alt):
            return ref[len(alt):]
        else:
            return ref

    # Handle the case where alt has 2 or more characters
    leftmost_seq = alt[0]
    right_seq = alt[1:]
    
    if ref.startswith(leftmost_seq):
        # Find the part of ref that matches right_seq from the end
        ref_suffix = ref[len(leftmost_seq):]
        
        if ref_suffix.endswith(right_seq):
            # Compute the difference sequence
            different_seq = ref[len(leftmost_seq): -len(right_seq)]
            return different_seq
    
    # If no match found with the pattern, issue a warning and return the entire ref as difference
    warnings.warn(f"No match found with the pattern for ref: '{ref}' and alt: '{alt}'. "
                  f"Returning entire ref as difference. Row data: {row_data}", UserWarning)
    return ref

def process_file(input_file, output_file):
    try:
        df = pd.read_csv(input_file, sep='\t')

        # Check for required columns
        required_columns = ['chr', 'pos', 'ref', 'alt', 'AF']
        for col in required_columns:
            if col not in df.columns:
                raise ValueError(f"Missing required column: {col}")

        # Compute difference
        df['Difference'] = df.apply(lambda row: find_diff(row['ref'], row['alt'], row.to_dict()), axis=1)
        # Compute difference length
        df['Difference_Length'] = df['Difference'].apply(len)
        # Compute pos+1 and insert it right after pos
        df.insert(df.columns.get_loc('pos') + 1, 'pos+1', df['pos'] + 1)
        # Compute end and insert it right after pos+1
        df.insert(df.columns.get_loc('pos+1') + 1, 'end', df['pos'] + df['Difference_Length'])
        # Add alt_new column with '-' in all rows
        df['alt_new'] = '-'

        # Drop specified columns
        df = df.drop(columns=['pos', 'ref', 'alt', 'Difference_Length'])

        # Reorder columns
        df = df[['chr', 'pos+1', 'end', 'Difference', 'alt_new', 'AF']]
        
        # Save to output file without headers
        df.to_csv(output_file, sep='\t', index=False, header=False)
    
    except Exception as e:
        print(f"An error occurred while processing the file: {e}")

if __name__ == "__main__":
    try:
        # **SET THE CURRENT WORKING DIRECTORY**
        os.chdir('/home/user/Research/Tools/ToMMoVCFtoAnnovarDB')

        # **SPECIFY THE INPUT AND OUTPUT FILES**
        input_file = 'tmp/query_combined_result_deletion.txt'
        output_file = 'tmp/query_combined_result_deletion_converted.txt'

        # **PROCESS THE FILE**
        process_file(input_file, output_file)
        print(f"Processing complete for DEL. Results saved to {output_file}.")
    except Exception as e:
        print(f"An error occurred: {e}")

