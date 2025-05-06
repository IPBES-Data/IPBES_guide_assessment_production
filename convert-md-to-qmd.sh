#!/bin/bash

# Source and target directories
md_dir="md"
attachments_dir="$md_dir/attachments"
output_images_dir="images"

# Ensure images directory exists
mkdir -p "$output_images_dir"

# Loop through all .md files
for mdfile in "$md_dir"/*.md; do
  [ -e "$mdfile" ] || continue

  filename=$(basename "$mdfile" .md)
  qmdfile="./$filename.qmd"
  image_source_dir="$attachments_dir/$filename"
  image_target_dir="$output_images_dir/$filename"

  # Copy images to images/<filename>/ if they exist
  if [ -d "$image_source_dir" ]; then
    mkdir -p "$image_target_dir"
    cp -r "$image_source_dir"/* "$image_target_dir"/
  fi

  # Convert to .qmd with updated image paths
  {
    # Add YAML header
    echo "---"
    echo "title: \"$filename\""
    echo "format: html"
    echo "---"
    echo ""

    # Fix image paths in content
    sed "s|md/attachments/$filename/|images/$filename/|g" "$mdfile"
  } > "$qmdfile"

  echo "✅ Converted: $mdfile → $qmdfile (images copied and paths updated)"
done