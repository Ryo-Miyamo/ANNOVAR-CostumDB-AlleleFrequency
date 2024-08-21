import os
import pandas as pd
import warnings

def find_diff(ref, alt):
    """Find the contiguous sequence in 'ref' that is not in 'alt'."""
    if len(ref) == 1:
        # Handle the case where ref is a single character
        if alt.startswith(ref):
            return alt[len(ref):]
        else:
            return ref
    else:
        # Handle the case where ref has 2 or more characters
        leftmost_seq = ref[0]  # The first character of ref
        right_seq = ref[1:]    # The remaining part of ref after removing leftmost_seq

        if alt.startswith(leftmost_seq) and alt.endswith(right_seq):
            # Remove leftmost_seq and right_seq from alt to find different-sequence
            different_seq = alt[len(leftmost_seq):-len(right_seq)]
            return different_seq
        
        # If no match found with the pattern, issue a warning and return the entire ref as difference
        warnings.warn(f"No match found with the pattern for ref: '{ref}' and alt: '{alt}'. "
                      f"Returning entire ref as difference. Row data: {row_data}", UserWarning)
        return ref

def process_file(input_file, output_file):
    df = pd.read_csv(input_file, sep='\t')

    # Rename 'pos' column to 'start'
    df.rename(columns={'pos': 'start'}, inplace=True)

    # Compute 'end' column as a duplicate of 'start'
    df.insert(df.columns.get_loc('start') + 1, 'end', df['start'])

    # Compute difference
    df['Difference'] = df.apply(lambda row: find_diff(row['ref'], row['alt']), axis=1)

    # Replace ref column values with '-'
    df['ref'] = '-'

    # Replace alt column values with the Difference column values
    df['alt'] = df['Difference']

    # Drop the Difference column
    df.drop(columns=['Difference'], inplace=True)
    
    # Save to output file without headers
    df.to_csv(output_file, sep='\t', index=False, header=False)

if __name__ == "__main__":
    try:
#        # **SET THE CURRENT WORKING DIRECTORY**
#        os.chdir('')

        # **SPECIFY THE INPUT AND OUTPUT FILES**
        input_file = 'tmp/query_combined_result_insertion.txt'
        output_file = 'tmp/query_combined_result_insertion_converted.txt'

        # **PROCESS THE FILE**
        process_file(input_file, output_file)
        print(f"Processing complete for INS. Results saved to {output_file}.")
    except Exception as e:
        print(f"An error occurred: {e}")

