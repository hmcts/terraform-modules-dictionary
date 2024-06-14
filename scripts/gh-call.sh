#!/bin/bash

# set -ex

# List repositories in the organization and filter by module and HCL

limit=5
repos=$(gh search repos "org:hmcts" "language:HCL" "module in:name" --limit $limit | awk '{print $1}')

# Initialize the ReadMe.md file with the table header
echo "| TF Module | Consuming Repo Count |" > README.md
echo "| --- | --- |" >> README.md

# Loop through the filtered repositories and get their count
for repo in $repos; do
    count=$(gh search code "org:hmcts" "language:HCL" $repo --limit $limit  | wc -l)
    search_url="https://github.com/search?q=org%3Ahmcts+$repo+language%3AHCL&type=code&l=HCL"
    # echo "$repo is used by $count repos"
    echo "| $repo | [$count]($search_url) |" >> README.md
    # sleep 7 # due to rate limit on github, we can only have 10 requests per minute for Code Search API - check using   gh api rate_limit
done