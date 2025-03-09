#!/bin/bash

# Configuration
URL="https://www.amfiindia.com/spages/NAVAll.txt"
OUTPUT_FILE="nav_data.tsv"
TEMP_FILE="temp_nav_data.txt"

cleanup() {
    rm -f "$TEMP_FILE"
}

trap cleanup EXIT

# here we check if required commands exist
check_dependencies() {
    for cmd in curl awk ; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            echo "Error: Required command '$cmd' not found"
            exit 1
        fi
    done
}

download_data() {
    if ! curl -s "$URL" > "$TEMP_FILE"; then
        echo "Error: Failed to download data from $URL"
        exit 1
    fi

    if [ ! -s "$TEMP_FILE" ]; then
        echo "Error: Downloaded file is empty"
        exit 1
    fi
}

process_data() {
    echo -e "Scheme Name\tAsset Value" > "$OUTPUT_FILE"

    # Process the data:
    # 1. we look for lines with semicolons
    # 2. extract fields 4 (Scheme Name) and 5 (Asset Value)
    # 3. we remove any quotes
    # 4. then we convert to TSV format
    awk -F';' '
        NF >= 5 {
            # Remove any leading/trailing spaces
            gsub(/^[ \t]+|[ \t]+$/, "", $4)
            gsub(/^[ \t]+|[ \t]+$/, "", $5)
            
            # Skip empty or header lines
            if ($4 != "" && $5 != "" && $4 !~ /^Scheme Name/) {
                # Remove any quotes
                gsub(/"/, "", $4)
                gsub(/"/, "", $5)
                
                # Output in TSV format
                print $4 "\t" $5
            }
        }
    ' "$TEMP_FILE" >> "$OUTPUT_FILE"
}


validate_output() {
    if [ ! -s "$OUTPUT_FILE" ]; then
        echo "Error: Failed to create output file"
        exit 1
    fi
    
    local line_count=$(wc -l < "$OUTPUT_FILE")
    echo "Successfully processed NAV data"
    echo "Created $OUTPUT_FILE with $((line_count - 1)) entries"
}

main() {
    echo "Starting NAV data extraction..."
    check_dependencies
    download_data
    process_data
    validate_output
}

main


# Regarding storing this data in JSON format - yes, it would be more appropriate to store this data in JSON for several reasons:

# Better Data Structure:

# {
#   "schemes": [
#     {
#       "scheme_name": "Aditya Birla Sun Life Banking & PSU Debt Fund - Direct Plan-Growth",
#       "scheme_code": "119550",
#       "isin": {
#         "Payout": "INF209K01YN0",
#         "Reinvestment": null
#       },
#       "nav": 366.7709,
#       "date": "2025-02-12",
#       "category": "Debt Scheme - Banking and PSU Fund",
#       "fund_house": "Aditya Birla Sun Life Mutual Fund"
#     }
#   ]
# }
# Benefits of JSON format:

# Hierarchical structure preserves relationships between data
# Self-documenting field names
# Better type support (numbers vs strings)
# Easier to parse in modern programming languages
# Support for nested structures and arrays
# Better handling of optional fields
# Widely supported format for APIs
