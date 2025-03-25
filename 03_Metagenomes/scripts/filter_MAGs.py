import sys
from Bio import SeqIO

# Define input and output directories
input_file = sys.argv[1]
output_file = sys.argv[2]

# Length threshold
length_threshold = int(sys.argv[3])

sequences = SeqIO.parse(input_file, "fasta")
    
# Filter sequences longer than the threshold
filtered_sequences = (seq for seq in sequences if len(seq) >= length_threshold)
    
# Write filtered sequences to the output file
count = SeqIO.write(filtered_sequences, output_file, "fasta")
    
print(f"Filtered {count} sequences from {input_file} and saved to {output_file}")