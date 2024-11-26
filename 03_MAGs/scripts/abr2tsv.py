import sys
import pandas as pd

abr_summary_path = sys.argv[1]
df = pd.read_csv(abr_summary_path, sep='\t')

# Rename '#FILE' to 'SAMPLE'
df.rename(columns={'#FILE': 'SAMPLE'}, inplace=True)

# Extract the sample name from the 'SAMPLE' column
df['SAMPLE'] = df['SAMPLE'].apply(lambda x: x.split('/')[-1].split('_')[0])

# Save the modified dataframe to a .tsv file
output_path = sys.argv[2]
df.to_csv(output_path, sep='\t', index=False)

print(f"Modified file saved to: {output_path}")