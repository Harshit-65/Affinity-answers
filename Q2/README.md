# Rfam Database Queries

A collection of SQL queries for analyzing the Rfam database (docs.rfam.org).

## Queries Explained

The `Q2.sql` file contains solutions for the following questions:

1. **Tiger Species Query**

   - Finds all types of tigers in the taxonomy table
   - Gets the NCBI ID of the Sumatran Tiger
   - Uses scientific names for accurate results

2. **Table Relationships**

   - Identifies all columns that connect different tables
   - Helps understand the database schema
   - Useful for joining tables correctly

3. **Rice DNA Sequence**

   - Finds the rice species with the longest DNA sequence
   - Uses joins between rfamseq and taxonomy tables
   - Orders by sequence length

4. **Paginated Family Query**
   - Lists family names and their longest DNA sequences
   - Filters for sequences > 1,000,000 in length
   - Implements pagination (15 results per page, showing 9th page)

## How to Run

1. Connect to the Rfam database:

```bash
mysql -h mysql-rfam-public.ebi.ac.uk -u rfamro -P 4497 rfam
```

2. Run the queries:

```bash
mysql -h mysql-rfam-public.ebi.ac.uk -u rfamro -P 4497 rfam < Q2.sql
```

## Database Details

- Host: mysql-rfam-public.ebi.ac.uk
- Port: 4497
- User: rfamro
- Database: rfam
- Access: Read-only
