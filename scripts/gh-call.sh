#!/bin/bash

export GH_TOKEN=$1

# List repositories in the organization and filter by module and HCL
limit=500
repos=$(gh search repos "org:hmcts" "language:HCL" "module in:name" --limit $limit | awk '{print $1}')

# Define the new section header
new_section_header="## Module Consumption Counts"

# Path to the README.md file
readme_path="../README.md"

# Remove the existing section if it exists
if grep -q "$new_section_header" "$readme_path"; then
    # Use sed to delete the section from the new_section_header to the end of the file
    sed -i.bak "/$new_section_header/,\$d" "$readme_path"
    # Remove the backup file created by sed (optional)
    rm "${readme_path}.bak"
fi

# Append the new section header and table header to the README.md file
{
    echo -e "\n$new_section_header\n"
    echo "| Modules |"
    echo "| --- |"
} >> "$readme_path"

# Loop through the filtered repositories and get their count
for repo in $repos; do
    # this below commmand works but there seems to be discrepancy between count I am getting from gh command line and github site search so turning it off
    # count=$(gh search code "org:hmcts" "language:HCL" "$repo" --limit 500 | wc -l)
    search_url="https://github.com/search?q=org%3Ahmcts+$repo+language%3AHCL++NOT+is%3Aarchived&type=code&l=HCL"
    echo "| <a href=\"$search_url\" target=\"_blank\">$repo</a> |" >> "$readme_path"
    # sleep 10  # due to rate limit on github, we can only have 10 requests per minute for Code Search API
done
