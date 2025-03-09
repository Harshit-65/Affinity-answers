
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
-- full_region connects to taxonomy via ncbi_id
-- family and clan_membership connect via rfam_acc
-- clan and clan_membership connect via clan_acc


-- 3. Finding rice type with longest DNA sequence:

SELECT t.species, r.length
FROM rfamseq r
JOIN taxonomy t ON r.ncbi_id = t.ncbi_id
WHERE t.species LIKE 'Oryza%'
ORDER BY r.length DESC
LIMIT 1;

 -- Oryza is the scientific name for rice
 
-- 4. Paginating family names with DNA sequences > 1,000,000:

SELECT f.rfam_acc, f.rfam_id, subq.max_len
FROM (
    SELECT DISTINCT fr.rfam_acc, MAX(r.length) as max_len
    FROM full_region fr
    JOIN (
        SELECT count(*), rfamseq_acc, length 
        FROM rfamseq 
        WHERE length > 1000000
    ) r ON fr.rfamseq_acc = r.rfamseq_acc
    GROUP BY fr.rfam_acc
    ORDER BY max_len DESC
    LIMIT 15 OFFSET 120 
) subq
JOIN family f ON f.rfam_acc = subq.rfam_acc
ORDER BY subq.max_len DESC;
-- OFFSET = (page_number - 1) * results_per_page = (9-1) * 15 = 120



-- Filters rfamseq to only include sequences > 1,000,000 
-- Joins filtered sequences with full_region to connect them to families ||rfam_acc: Family accession ID => family.rfam_acc || rfamseq_acc: Sequence accession ID => rfamseq.rfamseq_acc

-- Groups by family ID to find maximum sequence length per family  
-- Sorts families by their maximum sequence length (descending)
-- Gets the 9th page (skips 120 rows, takes 15)
-- Joins with family table to get the family names
-- Returns final sorted list of family IDs, names, and maximum lengths

-- Joining Logic

-- full_region.rfamseq_acc = rfamseq.rfamseq_acc: Connects sequences to regions
-- family.rfam_acc = full_region.rfam_acc: Connects regions to families