import sys
import pandas as pd

humann_df = pd.read_csv(sys.argv[1], sep='\t')

# Transpose the dataframe
data_transposed = humann_df.T
data_transposed.columns = data_transposed.iloc[0]
data_transposed = data_transposed.drop(data_transposed.index[0])

# Save the transposed dataframe to a .csv file
output_path = sys.argv[2]
data_transposed.to_csv(output_path, index_label='Sample_id')

print(f"Transposed file saved to: {output_path}")