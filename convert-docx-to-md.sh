#!/bin/bash

# Directories
input_dir="docx"
output_dir="md"

# Ensure output base directory exists
mkdir -p "$output_dir"

# Loop through all .docx files
for filepath in "$input_dir"/*.docx; do
  [ -e "$filepath" ] || continue

  filename=$(basename "$filepath" .docx)

  # Extracted media path (relative to the .md file location)
  relative_media_path="attachments/$filename"
  absolute_media_path="$output_dir/$relative_media_path"

  # Ensure the attachments directory exists
  mkdir -p "$absolute_media_path"

  echo "Converting: $filename.docx → $output_dir/$filename.md"

  # Run Pandoc with a relative path embedded in the Markdown
  pandoc \
    -t markdown \
    --extract-media="$absolute_media_path" \
    "$filepath" \
    -o "$output_dir/$filename.md"
done

echo "✅ Conversion complete. Markdown and media saved in '$output_dir'."