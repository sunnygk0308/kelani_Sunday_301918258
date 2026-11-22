# Cooperative and Loan Services — database design

My case study records member, cooperative_account, loan, repayment.

## Users

- member service officer
- loan officer
- cooperative accountant
- member

## Main operations

- Register synthetic members
- Maintain share or cooperative accounts
- Submit and approve loan applications
- Record loan disbursements and repayments
- Review balances and loan status

## Entities

| Entity | Information stored |
| --- | --- |
| member | Stores a synthetic cooperative member and contact identity. |
| cooperative_account | Links a member to a synthetic share or cooperative account. |
| loan | Stores a synthetic loan application and lifecycle status for an account. |
| repayment | Stores individual synthetic repayments against a loan. |

## member

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| member_id | BIGINT | PK | Yes |
| full_name | TEXT |  | Yes |
| email | TEXT | Unique | Yes |
| joined_on | DATE |  | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (email).

## cooperative_account

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| account_id | BIGINT | PK | Yes |
| member_id | BIGINT | FK | Yes |
| account_number | TEXT | Unique | Yes |
| account_type | TEXT |  | Yes |
| balance | NUMERIC(18,2) |  | Yes |
- member_id → member.member_id
- Unique key: (account_number).
- Unique key: (member_id, account_type).

## loan

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| loan_id | BIGINT | PK | Yes |
| account_id | BIGINT | FK | Yes |
| application_number | TEXT | Unique | Yes |
| principal | NUMERIC(18,2) |  | Yes |
| interest_rate | NUMERIC(18,2) |  | Yes |
| status | TEXT |  | Yes |
| opened_on | DATE |  | Yes |
- account_id → cooperative_account.account_id
- Unique key: (application_number).

## repayment

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| repayment_id | BIGINT | PK | Yes |
| loan_id | BIGINT | FK | Yes |
| payment_sequence | INTEGER |  | Yes |
| paid_on | DATE |  | Yes |
| amount | NUMERIC(18,2) |  | Yes |
| payment_method | TEXT |  | Yes |
- loan_id → loan.loan_id
- Unique key: (loan_id, payment_sequence).

## Relationships and business rules

- A member must have a synthetic full name.
- Member email addresses must be unique.
- Account numbers must be unique.
- Every cooperative account must reference an existing member.
- A cooperative account balance cannot be negative.
- A member may have at most one account of each account type.
- Every loan must reference an existing cooperative account.
- Loan application numbers must be unique.
- Loan principal must be greater than zero.
- Loan status must be one of applied, approved, disbursed, closed, or rejected.
- One account may have at most one row with status applied.
- Every repayment must reference an existing loan.
- Payment sequence numbers must be unique within each loan.
- A repayment amount must be greater than zero.

## Assumptions

- The system is in one currency and uses decimal monetary values.
- One account belongs to exactly one member, and one loan belongs to one account.
- Statuses use synthetic values: applied, approved, disbursed, closed, or rejected.
- Worked normalisation example: start with account membership details repeated in loan rows, move member attributes to Member, move the member-account relationship to CooperativeAccount, and retain only account_id in Loan; Loan is the foreign-key-rooted example and Member is used once.
- Benchmark plan: load 100000 synthetic Loan rows, collect cold and warm timings for status filtering, run both without and with a B-tree index, and report synthetic row counts separately from execution timings.
- All identifiers and sample names in the exercise are synthetic.
- This is a discussion specification, not a deployed database or replica set.

