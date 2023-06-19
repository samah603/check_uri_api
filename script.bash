#!/bin/bash

folder_input="input"
folder_tmp="tmp"
folder_logs="../logs"
folder_output="../output"

# Iterate over each file in the folder
for file_name_input in "$folder_input"/*; do
    # Check if the file is a regular file
    if [ -f "$file_name_input" ]; then
        # Extract only the file name using basename
        file_name_input=$(basename "$file_name_input")
        # echo "File name: $file_name"
        cp input/$file_name_input tmp/$file_name_input
    fi
done

# Iterate over each zip file
for zip_file in tmp/*.zip; do

    # Unzip the file to the temporary folder
    unzip "$zip_file" -d "$folder_tmp"
    rm -f $zip_file

    # Change the working directory to the temporary folder
    cd "$folder_tmp"

    # Iterate over each file in the temporary folder
    for file_name_tmp in *; do
        # Check if the file is a regular file
        if [ -f "$file_name_tmp" ]; then
            # echo "File name: $file_name_tmp"
            sed -i 's/|/ /g' "$file_name_tmp"
            awk '{print $8}' "$file_name_tmp" >> "$folder_logs/access.log"
            # awk '{print $8}' "$file_name_tmp" | sed 's/\/[^/]*\/[^/]*$//' >> "$folder_output/output.log"
            awk '{print $8}' "$file_name_tmp" | sed 's/\/[^/]*$//' >> "$folder_output/output.log"
            # sed 's/\/[^/]*$//' "$folder_logs/$file_name_tmp" >> "$folder_output/$file_name_tmp"
            rm -rf $file_name_tmp
        fi
    done
done