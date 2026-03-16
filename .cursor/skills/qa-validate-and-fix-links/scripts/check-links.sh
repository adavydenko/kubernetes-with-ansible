#!/bin/bash
# Script to validate markdown links in a project
# Usage: ./check-links.sh [directory]

set -e

PROJECT_ROOT="${1:-.}"
BROKEN_LINKS=0

echo "Checking markdown links in: $PROJECT_ROOT"
echo ""

# Find all markdown files
find "$PROJECT_ROOT" -name "*.md" -type f | while read -r file; do
    # Get directory of the file
    dir=$(dirname "$file")
    
    # Extract all markdown links
    grep -oP '\[.*?\]\([^)]+\.md\)' "$file" 2>/dev/null | while read -r link; do
        # Extract the path from the link
        path=$(echo "$link" | sed -n 's/.*](\(.*\))/\1/p')
        
        # Skip external links
        if [[ "$path" == http* ]]; then
            continue
        fi
        
        # Resolve relative path
        if [[ "$path" == /* ]]; then
            # Absolute path
            target="$path"
        elif [[ "$path" == ../* ]]; then
            # Parent directory
            target=$(cd "$dir" && cd "$(dirname "$path")" && pwd)/$(basename "$path")
        elif [[ "$path" == ./ ]]; then
            # Current directory
            target="$dir/$(basename "$path")"
        else
            # Relative to current file
            target="$dir/$path"
        fi
        
        # Check if file exists
        if [ ! -f "$target" ]; then
            echo "❌ Broken link in $file:"
            echo "   Link: $link"
            echo "   Expected: $target"
            echo ""
            BROKEN_LINKS=$((BROKEN_LINKS + 1))
        fi
    done
done

if [ $BROKEN_LINKS -eq 0 ]; then
    echo "✅ All links are valid!"
    exit 0
else
    echo "❌ Found $BROKEN_LINKS broken link(s)"
    exit 1
fi

