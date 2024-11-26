import os
import sys

# Function to rename sequence names in a fasta file
def rename_fasta_sequences(file_name):
    with open(file_name, 'r') as file:
        lines = file.readlines()

    new_lines = []
    for line in lines:
        if line.startswith('>'):
            # Determine the new sequence name based on the file name pattern
            base_name = os.path.basename(file_name)
            if base_name.startswith('Densovirus_D'):
                number = base_name.split('_')[1].split('.')[0][1:]
                new_seq_name = f">Densovirinae_sp._isolate_RBHC_VM_{number}"
            elif base_name.startswith('Densovirus_P'):
                number = base_name.split('_')[1].split('.')[0][1:]
                new_seq_name = f">Densovirinae_sp._isolate_RBHC_NN_{number}"
            new_lines.append(new_seq_name + '\n')
        else:
            new_lines.append(line)

    # Write the new sequences back to the file
    with open(file_name, 'w') as file:
        file.writelines(new_lines)

# Main function to process all fasta files in the input folder
def main(input_folder):
    # List all fasta files in the specified folder
    fasta_files = [os.path.join(input_folder, f) for f in os.listdir(input_folder) if f.endswith('.fasta')]

    # Process each fasta file
    for fasta_file in fasta_files:
        rename_fasta_sequences(fasta_file)

# Execute main function if script is run directly
if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python rename_seqs.py {input_folder}")
        sys.exit(1)

    input_folder = sys.argv[1]

    if not os.path.isdir(input_folder):
        print(f"Error: {input_folder} is not a valid directory.")
        sys.exit(1)

    main(input_folder)
