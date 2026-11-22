-- Fictional sample records for Cooperative and Loan Services.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."member" ("member_id", "full_name", "email", "joined_on", "active") VALUES (1, 'Avery Example', 'avery@example.test', '2025-01-10', TRUE);
INSERT INTO portfolio."member" ("member_id", "full_name", "email", "joined_on", "active") VALUES (2, 'Jordan Sample', 'jordan@example.test', '2025-02-15', TRUE);
INSERT INTO portfolio."cooperative_account" ("account_id", "member_id", "account_number", "account_type", "balance") VALUES (3, 1, 'SYN-ACC-001', 'share', 250.5);
INSERT INTO portfolio."cooperative_account" ("account_id", "member_id", "account_number", "account_type", "balance") VALUES (4, 2, 'SYN-ACC-002', 'share', 400);
INSERT INTO portfolio."loan" ("loan_id", "account_id", "application_number", "principal", "interest_rate", "status", "opened_on") VALUES (5, 3, 'SYN-APP-001', 1000, 4.5, 'applied', '2025-03-01');
INSERT INTO portfolio."loan" ("loan_id", "account_id", "application_number", "principal", "interest_rate", "status", "opened_on") VALUES (6, 4, 'SYN-APP-002', 750, 5, 'approved', '2025-03-05');
INSERT INTO portfolio."repayment" ("repayment_id", "loan_id", "payment_sequence", "paid_on", "amount", "payment_method") VALUES (7, 5, 1, '2025-04-01', 100, 'transfer');
INSERT INTO portfolio."repayment" ("repayment_id", "loan_id", "payment_sequence", "paid_on", "amount", "payment_method") VALUES (8, 6, 1, '2025-04-05', 75, 'cash');
COMMIT;
