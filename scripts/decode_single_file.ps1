# [System.IO.File]::WriteAllBytes("C:\path\to\decoded_file.html", [System.Convert]::FromBase64String((Get-Content -Path "C:\path\to\encoded_file.txt" -Raw)))

# Define parameters
$inputFile = "C:\path\to\encoded_file.txt"       # Path to the Base64-encoded file
$outputFile = "C:\path\to\decoded_file.html"     # Path to save the decoded file

# Check if the input file exists
if (!(Test-Path -Path $inputFile)) {
    Write-Output "Error: Input file '$inputFile' does not exist!"
    exit 1
}

# Step 1: Read the Base64 content from the file
Write-Output "Reading Base64 content from $inputFile..."
$base64Content = Get-Content -Path $inputFile -Raw

# Step 2: Decode the Base64 content into the original file
Write-Output "Decoding Base64 content to create the original file..."
[byte[]]$fileBytes = [System.Convert]::FromBase64String($base64Content)
[System.IO.File]::WriteAllBytes($outputFile, $fileBytes)

Write-Output "Decoding complete. The original file has been saved as $outputFile."
