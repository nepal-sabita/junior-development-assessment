-- ============================================================================
-- ORIGINAL PROBLEMATIC QUERY
-- ============================================================================
-- This query is currently running in production and causing performance issues.
-- 
-- PROBLEM: Takes 15-20 seconds for date ranges with 100K+ transactions
-- SYMPTOMS: Database CPU spikes, connection pool exhaustion, user timeouts
--
-- YOUR TASK: Analyze this query, identify the bottlenecks, and optimize it.
-- ============================================================================
EXPLAIN 
SELECT
   tm.*,
   tm.txn_id AS "tm.txnId",
   tm.local_txn_date_time AT TIME ZONE 'UTC' AS "tm.localTxnDateTime",
   (
      SELECT json_agg(td_conv ORDER BY td_conv.local_txn_date_time DESC)
      FROM (
         SELECT 
            td2.txn_detail_id,
            td2.master_txn_id,
            td2.detail_type,
            td2.amount,
            td2.currency,
            td2.description,
            td2.local_txn_date_time,
            td2.local_txn_date_time AT TIME ZONE 'UTC' AS converted_date
         FROM operators.transaction_details td2
         WHERE td2.master_txn_id = tm.txn_id
      ) td_conv
   ) AS details,
   ins.member_name AS member,
   iss.member_name AS issuer
FROM operators.transaction_master tm
   JOIN operators.transaction_details td ON tm.txn_id = td.master_txn_id
   LEFT JOIN operators.members ins ON tm.gp_acquirer_id = ins.member_id
   LEFT JOIN operators.members iss ON tm.gp_issuer_id = iss.member_id
WHERE 1=1
   AND tm.txn_date > DATE '2025-11-16' 
   AND tm.txn_date < DATE '2025-11-18' 
GROUP BY tm.txn_id, ins.member_id, iss.member_id 
ORDER BY tm.local_txn_date_time DESC;

-- ============================================================================
-- HINTS FOR ANALYSIS
-- ============================================================================
-- 
-- Questions to ask yourself:
-- 1. What happens in the SELECT clause? How many times does it execute?
-- 2. Why is there a JOIN to transaction_details in the main query?
-- 3. What is the GROUP BY doing? Is it necessary?
-- 4. How many times is the transaction_details table being scanned?
-- 5. What is the time complexity of this query?
--
-- Think about:
-- - Correlated subqueries (subqueries that reference the outer query)
-- - N+1 query problems
-- - Unnecessary table scans
-- - Aggregation strategies
--
-- ============================================================================
