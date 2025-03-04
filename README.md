# Affinity Answers Technical Assessment

This repo contains my solutions to the Affinity Answers technical assessment.

## Q1: BestDelivery PIN Code Validator

The first challenge was about helping a courier company validate PIN codes in addresses. They were having issues with wrong deliveries due to incorrect PIN codes. I built a program that:

- Takes a free-flowing address as input
- Validates if the PIN code matches the address using the postalpincode.in API
- Handles various address formats and variations

Check out the solution and test cases in the [Q1 directory](./Q1).

## Q2: Rfam Database Queries

In this one had to write some SQL queries for the Rfam database (docs.rfam.org) to find:

- Tiger species in the taxonomy table (including the Sumatran Tiger's NCBI ID)
- Table relationships through common columns
- Rice species with the longest DNA sequence
- A paginated query for family names and DNA sequences

You can find all the queries and their explanations in the [Q2 directory](./Q2).

## Q3: AMFI Data Extraction Script

The last task was about shell scripting - had to create a script that:

- Fetches mutual fund data from amfiindia.com/spages/NAVAll.txt
- Extracts Scheme Name and Asset Value fields
- Saves them in a TSV format

The solution is in the [Q3 directory](./Q3).

## How to Run

Each solution has its own README with specific instructions on how to run.
