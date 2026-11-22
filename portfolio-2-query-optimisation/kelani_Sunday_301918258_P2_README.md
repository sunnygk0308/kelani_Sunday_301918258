# Cooperative and Loan Services — SQL queries

## 1. Show related member, cooperative_account, loan records (up to 20).

```sql
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
```

| member_member_id | member_full_name | cooperative_account_account_id | cooperative_account_account_number | loan_loan_id | loan_application_number |
| --- | --- | --- | --- | --- | --- |
| 1 | Avery Example | 3 | SYN-ACC-001 | 5 | SYN-APP-001 |
| 2 | Jordan Sample | 4 | SYN-ACC-002 | 6 | SYN-APP-002 |

## 2. Find loan records where status matches "applied" (up to 20).

```sql
SELECT * FROM portfolio."loan"
WHERE "status" IS NOT DISTINCT FROM 'applied'
ORDER BY "loan_id"
LIMIT 20;
```

| loan_id | account_id | application_number | principal | interest_rate | status | opened_on |
| --- | --- | --- | --- | --- | --- | --- |
| 5 | 3 | SYN-APP-001 | 1000 | 4.5 | applied | 2025-03-01 |

## 3. Count loan records for each account_id (up to 20 groups).

```sql
SELECT "account_id", count(*) AS record_count
FROM portfolio."loan"
GROUP BY "account_id"
ORDER BY record_count DESC, "account_id" NULLS LAST
LIMIT 20;
```

| account_id | record_count |
| --- | --- |
| 3 | 1 |
| 4 | 1 |

## 4. Count cooperative_account records for each member_id (up to 20 groups).

```sql
SELECT "member_id", count(*) AS record_count
FROM portfolio."cooperative_account"
GROUP BY "member_id"
ORDER BY record_count DESC, "member_id" NULLS LAST
LIMIT 20;
```

| member_id | record_count |
| --- | --- |
| 1 | 1 |
| 2 | 1 |

## 5. Show related cooperative_account, loan, repayment records (up to 20).

```sql
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
```

| cooperative_account_account_id | cooperative_account_account_number | loan_loan_id | loan_application_number | repayment_repayment_id | repayment_payment_sequence |
| --- | --- | --- | --- | --- | --- |
| 3 | SYN-ACC-001 | 5 | SYN-APP-001 | 7 | 1 |
| 4 | SYN-ACC-002 | 6 | SYN-APP-002 | 8 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 5.302 | 5.185, 5.302, 5.304 | Sort → Seq Scan | 640 |
| After index | 0.562 | 0.545, 1.794, 0.562 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 105 |

The median execution time changed from 5.302 ms to 0.562 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=5.151..5.156 rows=100 loops=1)
  Seq Scan on loan (actual time=0.016..5.101 rows=100 loops=1)
Planning Time: 0.382 ms
Execution Time: 5.185 ms
```

### Before index, run 2

```text
Sort (actual time=5.257..5.262 rows=100 loops=1)
  Seq Scan on loan (actual time=0.017..5.207 rows=100 loops=1)
Planning Time: 0.398 ms
Execution Time: 5.302 ms
```

### Before index, run 3

```text
Sort (actual time=5.271..5.276 rows=100 loops=1)
  Seq Scan on loan (actual time=0.016..5.22 rows=100 loops=1)
Planning Time: 0.383 ms
Execution Time: 5.304 ms
```

### After index, run 1

```text
Sort (actual time=0.484..0.489 rows=100 loops=1)
  Bitmap Heap Scan on loan (actual time=0.036..0.438 rows=100 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.019..0.019 rows=100 loops=1)
Planning Time: 0.582 ms
Execution Time: 0.545 ms
```

### After index, run 2

```text
Sort (actual time=1.151..1.159 rows=100 loops=1)
  Bitmap Heap Scan on loan (actual time=0.053..1.064 rows=100 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.028..0.029 rows=100 loops=1)
Planning Time: 2.757 ms
Execution Time: 1.794 ms
```

### After index, run 3

```text
Sort (actual time=0.504..0.509 rows=100 loops=1)
  Bitmap Heap Scan on loan (actual time=0.036..0.454 rows=100 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.019..0.02 rows=100 loops=1)
Planning Time: 0.607 ms
Execution Time: 0.562 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run kelani_Sunday_301918258_P2_Queries.sql, then kelani_Sunday_301918258_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/kelani_Sunday_301918258_P2_QueryResults.png) · [Index comparison](screenshots/kelani_Sunday_301918258_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

