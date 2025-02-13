
--1. Finding types of tigers and Sumatran Tiger's ncbi_id:

SELECT scientific_name, ncbi_id
FROM taxonomy 
WHERE scientific_name LIKE '%Panthera tigris%';

-- For specifically Sumatran Tiger:
SELECT ncbi_id 
FROM taxonomy 
WHERE scientific_name = 'Panthera tigris sumatrae';

-- 2. Finding connecting columns between tables:


-- family and full_region connect via rfam_acc
-- rfamseq and full_region connect via rfamseq_acc
-- rfamseq and taxonomy connect via ncbi_id
-- family and clan_membership connect via rfam_acc
-- clan and clan_membership connect via clan_acc


-- 3. Finding rice type with longest DNA sequence:

SELECT t.species, MAX(r.length) as seq_length
FROM taxonomy t
JOIN rfamseq r ON t.ncbi_id = r.ncbi_id
WHERE t.species LIKE '%Oryza%'  -- Oryza is the genus name for rice
GROUP BY t.species
ORDER BY seq_length DESC
LIMIT 1;

-- 4. Paginating family names with DNA sequences > 1,000,000:

SELECT f.rfam_acc, f.family_name, MAX(r.length) as max_length
FROM family f
JOIN full_region fr ON f.rfam_acc = fr.rfam_acc
JOIN rfamseq r ON fr.rfamseq_acc = r.rfamseq_acc
GROUP BY f.rfam_acc, f.family_name
HAVING max_length > 1000000
ORDER BY max_length DESC
LIMIT 15 OFFSET 120;  -- OFFSET = (page_number - 1) * results_per_page = (9-1) * 15 = 120


-- We join the family, full_region, and rfamseq tables to get family information and sequence lengths
-- Group by family to get one row per family
-- Filter for sequences > 1,000,000 using HAVING
-- Order by length in descending order
-- LIMIT 15 gets 15 results per page
-- OFFSET 120 skips the first 8 pages (8 * 15 = 120 rows) to get to the 9th page