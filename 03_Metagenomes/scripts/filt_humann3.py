import sys
import pandas as pd

pathabund_df = pd.read_csv(sys.argv[1], sep='\t')

# Define unwanted substrings
unwanted_strings = ['UNMAPPED', 'UNINTEGRATED', 'unclassified']

# Create a boolean mask for rows that do not contain any of the unwanted substrings
mask = ~pathabund_df.iloc[:, 0].str.contains('|'.join(unwanted_strings), case=False, na=False)

# Apply the mask to filter the DataFrame
filtered_pathabund_df = pathabund_df[mask]

# Rename '# Pathway' to 'Pathway'
filtered_pathabund_df.columns = filtered_pathabund_df.columns.str.replace('# ', '')

# Rename '{sample}_Abundance' to '{sample}' in case of `pathabundance` dataset
filtered_pathabund_df.columns = filtered_pathabund_df.columns.str.replace('_Abundance', '')

# Rename '{sample}-RPKs' to '{sample}' in case of `genefamilies` dataset
filtered_pathabund_df.columns = filtered_pathabund_df.columns.str.replace('-RPKs', '')

# Save the filtered dataframe to a .tsv file
output_path = sys.argv[2]
filtered_pathabund_df.to_csv(output_path, sep='\t', index=None)

print(f"Modified file saved to: {output_path}")