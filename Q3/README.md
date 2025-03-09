# AMFI NAV Data Extractor

A shell script to extract and format mutual fund data from AMFI India's daily NAV file.

## What it Does

The script:

1. Downloads the latest NAV data from amfiindia.com
2. Extracts Scheme Name and Asset Value fields
3. Creates a clean TSV (Tab Separated Values) file

## Usage

Run the script:

```bash
./extract_nav.sh
```

This will create:

- `nav_data.tsv`: Contains the extracted data in TSV format

## Requirements

- Bash shell
- curl or wget
- awk

## TSV vs JSON

The original data is provided in a text format that's not very machine-friendly. While TSV is a good intermediate format for:

- Easy processing with Unix tools
- Smaller file size
- Faster parsing

JSON would be better for:

- API responses
- Web applications
- Better data structure representation
- Easy integration with modern applications

## Error Handling

The script includes error checking for:

- Failed downloads
- File permission issues
- Data format inconsistencies
