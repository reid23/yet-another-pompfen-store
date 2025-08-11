#!/bin/bash

# Find all .scad files in the current directory
find . -maxdepth 1 -type f -name "*.scad" | while read source_file; do
    # Get just the filename without path
    source_filename=$(basename "$source_file")
    
    # Search for @build comments and module names in the file
    grep -A1 '^// @build' "$source_file" | while read -r comment_line && read -r module_line; do
        build_info=$(echo "$comment_line" | sed -n 's/^\/\/ @build \(.*\)$/\1/p')
        
        export_filename=$(echo "$build_info" | awk '{print $1}')

        if [ $(echo "$build_info" | wc -w) -gt 1 ]; then
            arguments=$(echo "$build_info" | cut -d' ' -f2-)
        else
            arguments=""
        fi
        
        module_name=$(echo "$module_line" | sed -n 's/^module \([^( ]*\).*$/\1/p')
        
        if [[ -n "$export_filename" && -n "$module_name" ]]; then
            tmpfile="${export_filename}.scad"
            
            {
                echo "include <$source_filename>"
                echo "$module_name($arguments);"
            } > "$tmpfile"
            
            if [[ "$export_filename" == *".stl" ]]; then
                openscad --export-format 'binstl' -o "build/${export_filename}" "$tmpfile"
            else 
                openscad -o "build/${export_filename}" "$tmpfile"
            fi
            rm "$tmpfile"
        fi
    done
done

python epp_cam.py
