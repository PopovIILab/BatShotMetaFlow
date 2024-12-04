import sys
import pandas as pd

# Load the TSV file
file_path = sys.argv[1]
df = pd.read_csv(file_path, sep='\t')

# Apply the modifications
for column in df.columns:
    if column not in ["SAMPLE", "NUM_FOUND"]:
        df[column] = df[column].apply(lambda x: "plus" if pd.notnull(x) and x != "." else "minus")

# Save the modified DataFrame back to a TSV file
output_path = sys.argv[2]
df.to_csv(output_path, sep='\t', index=False)

print(f"Modified file saved to: {output_path}")