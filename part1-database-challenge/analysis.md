# Performance Analysis

 ## Performance Bottlenecks

### 1. What are the main performance issues?
- The original-query had a select with json_agg function which was run each time for every transaction.

    Time complexity: if there are a rows and b transaction detauls the query will have the a times details so O(ab)

2. Join issue 
- Here join occursd between transaction_details and td_master but it is duplicated in every row which is causing more memory usage

3. Sorting issue
- The query is sorting local_txn_date_time in descending order but after grouping which means duplicated data are being sorted and which causes more cpu and membory as it will create multiple rows.
time complexity: O(n log n) n is the number of rows which can be larger 

<!-- 4. Where 1=1 issue
Though this issue would not cause a big issue but is redundant and can be removed  -->

### Explaining Query Execution
 
 - Transaction_master is filtered by date 
 - Transaction masrer is joined with transaction_details which is one the issue that duplicated the rows 
 - At first the subquery of transaction_master  scans all table for matching txn_id  and then build json 
 - Joins members for acquirer and issuer
 - gropus rm_txn_id, ins.member_id, iss.member_id to remove duplicates.
 - Sort the local date by descending order.

 ### Most expensive operators

 - The subquery selectjson_add() it is one of the expensive operator thta caused the repeated N+1 scans causing the high cpu cost 
 - JOIN and group by: spike in result size also sort cost


 ### Performace impact estimation
- The cost was more then 40k and row scans was more than 5k whoch was the duplciated and slow after optimisation the cost became less than 8k and rows scans was 1k which was faster