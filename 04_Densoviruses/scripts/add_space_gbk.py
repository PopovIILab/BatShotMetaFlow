import os

def modify_gbk_file(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    # Modify the first line
    first_line = lines[0]
    parts = first_line.split()
    
    # Assuming the first part is the strain name and the last part is the length
    strain_name = parts[1][:-4]  # Extract everything except the last 4 digits
    seq_length = parts[1][-4:]    # Extract the last 4 digits
    
    # Rebuild the first line
    modified_first_line = f"{parts[0]:<12}{strain_name} {seq_length} bp   {' '.join(parts[3:])}\n"
    lines[0] = modified_first_line

    # Write the modified lines back to the file
    with open(file_path, 'w') as file:
        file.writelines(lines)

def process_gbk_files(base_dir, samples):
    for sample in samples:
        sample_dir = f"annotated_densovirus_{sample}"
        gbk_file = f"Densovirus_{sample}_annot.gbk"
        file_path = os.path.join(base_dir, sample_dir, gbk_file)
        
        if os.path.exists(file_path):
            print(f"Processing file: {file_path}")
            modify_gbk_file(file_path)
        else:
            print(f"File not found: {file_path}")

# List of your sample names
samples = ['D1', 'D2', 'D3', 'D4', 'D5', 'P1', 'P2', 'P3', 'P4', 'P5']

# Specify the base directory where the files are located
base_dir = "prokka_results/"
process_gbk_files(base_dir, samples)
