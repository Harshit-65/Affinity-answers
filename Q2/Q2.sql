
--1. Finding types of tigers and Sumatran Tiger's ncbi_id:

SELECT species, ncbi_id
FROM taxonomy
WHERE species LIKE '%Panthera tigris%';

-- How many types of tigers are in the taxonomy table? => 8
--  What is the "ncbi_id" of the Sumatran Tiger? => 9695

-- 2. Finding connecting columns between tables:


-- family and full_region connect via rfam_acc
-- rfamseq and full_region connect via rfamseq_acc
-- rfamseq and taxonomy connect via ncbi_id
-- family and clan_membership connect via rfam_acc
-- clan and clan_membership connect via clan_acc


-- 3. Finding rice type with longest DNA sequence:

SELECT t.species, r.length
FROM rfamseq r
JOIN taxonomy t ON r.ncbi_id = t.ncbi_id
WHERE t.species LIKE 'Oryza%'
ORDER BY r.length DESC
LIMIT 1;

 -- Oryza is the genus name for rice
 
-- 4. Paginating family names with DNA sequences > 1,000,000:

SELECT f.rfam_acc, f.rfam_id, MAX(r.length) AS max_length
FROM family f
JOIN rfamseq r ON f.rfam_acc = r.rfamseq_acc
WHERE r.length > 1000000
GROUP BY f.rfam_acc, f.rfam_id
ORDER BY max_length DESC
LIMIT 15 OFFSET 120;  -- OFFSET = (page_number - 1) * results_per_page = (9-1) * 15 = 120



-- We join the family, full_region, and rfamseq tables to get family information and sequence lengths
-- Group by family to get one row per family
-- Filter for sequences > 1,000,000 using HAVING
-- Order by length in descending order
-- LIMIT 15 gets 15 results per page
-- OFFSET 120 skips the first 8 pages (8 * 15 = 120 rows) to get to the 9th page