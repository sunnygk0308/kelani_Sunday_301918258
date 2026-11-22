-- Show related member, cooperative_account, loan records (up to 20).
SELECT t0."member_id" AS "member_member_id",
       t0."full_name" AS "member_full_name",
       t1."account_id" AS "cooperative_account_account_id",
       t1."account_number" AS "cooperative_account_account_number",
       t2."loan_id" AS "loan_loan_id",
       t2."application_number" AS "loan_application_number"
FROM portfolio."member" t0
JOIN portfolio."cooperative_account" t1 ON t1."member_id" = t0."member_id"
JOIN portfolio."loan" t2 ON t2."account_id" = t1."account_id"
ORDER BY t0."member_id", t1."account_id", t2."loan_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."member_id" AS "member_member_id",
       t0."full_name" AS "member_full_name",
       t1."account_id" AS "cooperative_account_account_id",
       t1."account_number" AS "cooperative_account_account_number",
       t2."loan_id" AS "loan_loan_id",
       t2."application_number" AS "loan_application_number"
FROM portfolio."member" t0
JOIN portfolio."cooperative_account" t1 ON t1."member_id" = t0."member_id"
JOIN portfolio."loan" t2 ON t2."account_id" = t1."account_id"
ORDER BY t0."member_id", t1."account_id", t2."loan_id"
LIMIT 20;

-- Find loan records where status matches "applied" (up to 20).
SELECT * FROM portfolio."loan"
WHERE "status" IS NOT DISTINCT FROM 'applied'
ORDER BY "loan_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."loan"
WHERE "status" IS NOT DISTINCT FROM 'applied'
ORDER BY "loan_id"
LIMIT 20;

-- Count loan records for each account_id (up to 20 groups).
SELECT "account_id", count(*) AS record_count
FROM portfolio."loan"
GROUP BY "account_id"
ORDER BY record_count DESC, "account_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "account_id", count(*) AS record_count
FROM portfolio."loan"
GROUP BY "account_id"
ORDER BY record_count DESC, "account_id" NULLS LAST
LIMIT 20;

-- Count cooperative_account records for each member_id (up to 20 groups).
SELECT "member_id", count(*) AS record_count
FROM portfolio."cooperative_account"
GROUP BY "member_id"
ORDER BY record_count DESC, "member_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "member_id", count(*) AS record_count
FROM portfolio."cooperative_account"
GROUP BY "member_id"
ORDER BY record_count DESC, "member_id" NULLS LAST
LIMIT 20;

-- Show related cooperative_account, loan, repayment records (up to 20).
SELECT t0."account_id" AS "cooperative_account_account_id",
       t0."account_number" AS "cooperative_account_account_number",
       t1."loan_id" AS "loan_loan_id",
       t1."application_number" AS "loan_application_number",
       t2."repayment_id" AS "repayment_repayment_id",
       t2."payment_sequence" AS "repayment_payment_sequence"
FROM portfolio."cooperative_account" t0
JOIN portfolio."loan" t1 ON t1."account_id" = t0."account_id"
JOIN portfolio."repayment" t2 ON t2."loan_id" = t1."loan_id"
ORDER BY t0."account_id", t1."loan_id", t2."repayment_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."account_id" AS "cooperative_account_account_id",
       t0."account_number" AS "cooperative_account_account_number",
       t1."loan_id" AS "loan_loan_id",
       t1."application_number" AS "loan_application_number",
       t2."repayment_id" AS "repayment_repayment_id",
       t2."payment_sequence" AS "repayment_payment_sequence"
FROM portfolio."cooperative_account" t0
JOIN portfolio."loan" t1 ON t1."account_id" = t0."account_id"
JOIN portfolio."repayment" t2 ON t2."loan_id" = t1."loan_id"
ORDER BY t0."account_id", t1."loan_id", t2."repayment_id"
LIMIT 20;
