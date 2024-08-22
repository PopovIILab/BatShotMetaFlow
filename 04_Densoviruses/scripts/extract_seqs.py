import sys
import os
from Bio import SeqIO

def extract_longest_sequence(blast_output, metagenome_file, output_file):
    longest_alignment_length = 0
    best_match_id = None

    # Read BLAST output and find the sequence with the longest alignment length
    with open(blast_output) as blast_handle:
        for line in blast_handle:
            parts = line.split("\t")
            alignment_length = int(parts[3])
            if alignment_length > longest_alignment_length:
                longest_alignment_length = alignment_length
                best_match_id = parts[0]

    if best_match_id is None:
        print("No alignments found in the BLAST output.")
        return

    # Extract the best matching sequence from the metagenome file
    with open(output_file, "w") as out_handle:
        for record in SeqIO.parse(metagenome_file, "fasta"):
            if record.id == best_match_id:
                SeqIO.write(record, out_handle, "fasta")
                print(f"Extracted longest alignment sequence to {output_file}")
                return

    print(f"Best match ID {best_match_id} not found in the metagenome file.")

def main():
    if len(sys.argv) != 4:
        print("Usage: python extract_seqs.py <metagenome_file> <blast_output> <output_file>")
        sys.exit(1)

    metagenome_file = sys.argv[1]
    blast_output = sys.argv[2]
    output_file = sys.argv[3]

    extract_longest_sequence(blast_output, metagenome_file, output_file)

if __name__ == "__main__":
    main()