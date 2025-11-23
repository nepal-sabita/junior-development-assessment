/* FOR filtering by date*/
CREATE INDEX IF NOT EXISTS idx_transaction_master_txn_date
ON operators.transaction.master(txn_date);

/* for filtering by local date */
CREATE INDEX IF NOT EXISTS idx_transation_master_local_txn_date_time
ON operators.transaction.master(local_txn_date_time DESC);
