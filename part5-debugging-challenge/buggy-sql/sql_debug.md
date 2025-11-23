# BUG FIXES

## Bug[1]: Date in select and not in GROUP BY

1. Date was used in Select but not in GROUP BY which was causing the issue of random date
2. Solution was to add Date in GROUP BY too DATE(tm.txn_date)