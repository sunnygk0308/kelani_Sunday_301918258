# Cooperative and Loan Services — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| account_id | loan records (list) |
| --- | --- |
| 3 | [5] |
| 4 | [6] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| loan.loan_id | loan.account_id | loan.application_number | cooperative_account.account_id | cooperative_account.member_id | cooperative_account.account_number | member.member_id | member.full_name |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 5 | 3 | SYN-APP-001 | 3 | 1 | SYN-ACC-001 | 1 | Avery Example |
| 6 | 4 | SYN-APP-002 | 4 | 2 | SYN-ACC-002 | 2 | Jordan Sample |

Key: loan_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## loan_example

| loan.loan_id | loan.account_id | loan.application_number | cooperative_account.account_id | cooperative_account.member_id | cooperative_account.account_number | member.member_id | member.full_name |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 5 | 3 | SYN-APP-001 | 3 | 1 | SYN-ACC-001 | 1 | Avery Example |
| 6 | 4 | SYN-APP-002 | 4 | 2 | SYN-ACC-002 | 2 | Jordan Sample |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## member

| member_id | full_name | email | joined_on | active |
| --- | --- | --- | --- | --- |
| 1 | Avery Example | avery@example.test | 2025-01-10 | true |
| 2 | Jordan Sample | jordan@example.test | 2025-02-15 | true |

## cooperative_account

| account_id | member_id | account_number | account_type | balance |
| --- | --- | --- | --- | --- |
| 3 | 1 | SYN-ACC-001 | share | 250.5 |
| 4 | 2 | SYN-ACC-002 | share | 400 |

## loan

| loan_id | account_id | application_number | principal | interest_rate | status | opened_on |
| --- | --- | --- | --- | --- | --- | --- |
| 5 | 3 | SYN-APP-001 | 1000 | 4.5 | applied | 2025-03-01 |
| 6 | 4 | SYN-APP-002 | 750 | 5 | approved | 2025-03-05 |

## repayment

| repayment_id | loan_id | payment_sequence | paid_on | amount | payment_method |
| --- | --- | --- | --- | --- | --- |
| 7 | 5 | 1 | 2025-04-01 | 100 | transfer |
| 8 | 6 | 1 | 2025-04-05 | 75 | cash |

## Dependencies

- member: (member_id) → full_name, email, joined_on, active
- cooperative_account: (account_id) → member_id, account_number, account_type, balance
- loan: (loan_id) → account_id, application_number, principal, interest_rate, status, opened_on
- repayment: (repayment_id) → loan_id, payment_sequence, paid_on, amount, payment_method

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
