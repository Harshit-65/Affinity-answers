
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

SELECT f.rfam_acc, f.rfam_id, MAX(r.length) AS max_length
FROM family f
JOIN full_region fr ON fr.rfam_acc = f.rfam_acc
JOIN rfamseq r ON r.rfamseq_acc = fr.rfamseq_acc
WHERE r.length > 1000000
GROUP BY f.rfam_acc, f.rfam_id
ORDER BY max_length DESC
LIMIT 15 OFFSET 120;


-- +----------+-----------+------------+
-- | rfam_acc | rfam_id   | max_length |
-- +----------+-----------+------------+
-- | RF00135  | snoZ223   |  836514780 |
-- | RF00097  | snoR71    |  836514780 |
-- | RF00012  | U3        |  836514780 |
-- | RF01208  | snoR99    |  836514780 |
-- | RF00337  | snoZ112   |  836514780 |
-- | RF03674  | MIR5387   |  836514780 |
-- | RF00030  | RNase_MRP |  836514780 |
-- | RF00267  | snoR64    |  836514780 |
-- | RF00445  | mir-399   |  836514780 |
-- | RF01848  | ACEA_U3   |  836514780 |
-- | RF00350  | snoZ152   |  836514780 |
-- | RF00145  | snoZ105   |  830829764 |
-- | RF00451  | mir-395   |  801256715 |
-- | RF00329  | snoZ162   |  801256715 |
-- | RF01424  | snoR118   |  801256715 |
-- +----------+-----------+------------+
-- 15 rows in set (0.16 sec)
-- OFFSET = (page_number - 1) * results_per_page = (9-1) * 15 = 120



-- Filters rfamseq to include only sequences where length > 1000000.
-- Joins full_region to connect sequences to regions using rfamseq_acc.
-- Joins family to associate regions with families using rfam_acc.
-- Groups by rfam_acc, rfam_id to compute the maximum sequence length per family.
-- Sorts families by MAX(r.length) in descending order.
-- Gets the 9th page of results (skips 120 rows, takes 15).
-- Returns family IDs, names, and their maximum sequence lengths.

-- Joining Logic:
-- rfamseq.rfamseq_acc = full_region.rfamseq_acc -> Connects sequences to regions.
-- full_region.rfam_acc = family.rfam_acc -> Connects regions to families.