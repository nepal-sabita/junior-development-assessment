/*
 * BUGGY SQL - DO NOT USE IN PRODUCTION
 * This query has a logical error in the GROUP BY clause
 * that causes incorrect results.
 * Candidates should identify and fix the issue.
 */

-- Calculate daily settlement amounts per merchant
SELECT 
    m.member_id,
    m.member_name,
    DATE(tm.txn_date) as settlement_date,  -- BUG: This is in SELECT but not in GROUP BY!
    SUM(tm.local_amount) as total_amount,
    COUNT(tm.txn_id) as transaction_count,
    AVG(tm.local_amount) as avg_transaction
FROM operators.members m
INNER JOIN operators.transaction_master tm ON m.member_id = tm.acq_id
WHERE tm.status = 'COMPLETED'
  AND tm.txn_date >= '2025-11-16'
  AND tm.txn_date < '2025-11-19'
GROUP BY m.member_id, m.member_name, DATE(tm.txn_date)  -- BUG: Missing DATE(tm.txn_date) here!
ORDER BY settlement_date, total_amount DESC;

/*
 * EXPECTED OUTPUT (Wrong!):
 * For each merchant, shows ONE row with:
 * - Random settlement_date from their transactions
 * - Total amount ACROSS ALL DAYS (not per day)
 * - Count ACROSS ALL DAYS
 * 
 * WHAT WE WANT:
 * For each merchant, show MULTIPLE rows:
 * - One row per day
 * - Daily totals per merchant
 */
