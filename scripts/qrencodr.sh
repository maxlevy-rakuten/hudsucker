#!/bin/bash

# Check if an input file is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"                        # Input file path from the first argument
output_folder="$(mktemp -d -t qrencodr)" # Create a temporary directory for output
chunk_size=2800                        # Chunk size in bytes (~2.8KB)

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: File '$input_file' not found!"
    exit 1
fi

# Check if qrencode is installed
if ! command -v qrencode &>/dev/null; then
    echo "Error: qrencode is not installed. Please install it with 'brew install qrencode'."
    exit 1
fi

echo "Encoding '$input_file' to Base64 and splitting into chunks..."
echo "Output directory: $output_folder"

# Step 1: Encode the file to Base64 and save to a temporary file in the output folder
base64 -i "$input_file" >"$output_folder/file_encoded.txt"
echo "File encoded to Base64 and saved as file_encoded.txt in $output_folder."

# Step 2: Split the encoded file into smaller chunks
cd "$output_folder" || exit 1
split -b "$chunk_size" "file_encoded.txt" "qr_part_"

# Step 3: Rename split files to have .txt extensions and generate QR codes
a=0
for part in qr_part_*; do
    # Rename the part file
    mv "$part" "${part}.txt"
    part_file="${part}.txt"
    echo "Saved chunk $a as $part_file"

    # Generate QR code for each part
    qrencode -o "qr_part_$a.png" <"$part_file"
    echo "QR code generated for chunk $a as qr_part_$a.png"

    a=$((a + 1))
done

# Summary output
echo
echo "Total chunks created: $a"
echo "Each chunk is saved in $output_folder as qr_part_0.txt, qr_part_1.txt, ..., up to qr_part_$((a - 1)).txt"
echo "QR codes are saved as qr_part_0.png, qr_part_1.png, etc."
echo "Temporary files are stored in: $output_folder"
open $output_folder
