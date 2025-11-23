EXPLAIN
SELECT
   tm.*,
   tm.txn_id AS "tm.txnId",
   tm.local_txn_date_time AT TIME ZONE 'UTC' AS "tm.localTxnDateTime",
   /** aggregating all the data before tht subquery */
   td.details, 
    ins.member_name AS member,
   iss.member_name AS issuer
   FROM operators.transaction_master tm
   LEFT JOIN(
      SELECT
      master_txn_id, /* one row per master transaction to avoid duplication*/
      /* json to be buid as soon as the transaction is done* and aggregated in detauls*/
      json_agg(json_build_object(
            'txn_detail_id', txn_detail_id,
            'master_txn_id', master_txn_id,
            'detail_type', detail_type,
            'amount', amount,
            'currency', currency,
            'description', description,
            'local_txn_date_time', local_txn_date_time,
            'converted_date', local_txn_date_time AT TIME ZONE 'UTC'
      )
      ORDER BY local_txn_date_time DESC
   ) AS details
   From operators.transaction_details
   GROUP BY master_txn_id /* pre agreegated to avoid the N+1 subquery duplication*/
   )  td ON td.master_txn_id = tm.txn_id
   LEFT JOIN operators.members ins ON tm.gp_acquirer_id = ins.member_id
   LEFT JOIN operators.members iss ON tm.gp_issuer_id = iss.member_id
WHERE tm.txn_date > DATE '2025-11-16' /* 1=1 did nothing here just was a redundant*/
   AND tm.txn_date < DATE '2025-11-18' 
ORDER BY tm.local_txn_date_time DESC;
