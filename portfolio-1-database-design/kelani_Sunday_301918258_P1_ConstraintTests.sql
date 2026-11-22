-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. member primary key. Expected: pk_member, SQLSTATE 23505.
INSERT INTO portfolio."member" ("member_id", "full_name", "email", "joined_on", "active")
VALUES (1, 'Case Primary', 'case-primary@example.test', '2025-05-01', TRUE);

-- 2. member unique email. Expected: uq_member_0, SQLSTATE 23505.
INSERT INTO portfolio."member" ("member_id", "full_name", "email", "joined_on", "active")
VALUES (101, 'Case Email', 'avery@example.test', '2025-05-02', TRUE);

-- 3. member not null name. Expected: full_name, SQLSTATE 23502.
INSERT INTO portfolio."member" ("member_id", "full_name", "email", "joined_on", "active")
VALUES (114, NULL, 'case-null-name@example.test', '2025-05-03', TRUE);

-- 4. account primary key. Expected: pk_cooperative_account, SQLSTATE 23505.
INSERT INTO portfolio."cooperative_account" ("account_id", "member_id", "account_number", "account_type", "balance")
VALUES (3, 1, 'SYN-CASE-PK', 'primary-case', 10);

-- 5. account unique number. Expected: uq_cooperative_account_0, SQLSTATE 23505.
INSERT INTO portfolio."cooperative_account" ("account_id", "member_id", "account_number", "account_type", "balance")
VALUES (103, 2, 'SYN-ACC-001', 'term', 10);

-- 6. account unique member type. Expected: uq_cooperative_account_1, SQLSTATE 23505.
INSERT INTO portfolio."cooperative_account" ("account_id", "member_id", "account_number", "account_type", "balance")
VALUES (104, 1, 'SYN-CASE-TYPE', 'share', 10);

-- 7. account foreign key. Expected: fk_cooperative_account_0, SQLSTATE 23503.
INSERT INTO portfolio."cooperative_account" ("account_id", "member_id", "account_number", "account_type", "balance")
VALUES (102, 9001, 'SYN-CASE-FK', 'case-fk', 10);

-- 8. account balance check. Expected: br_account_balance_check, SQLSTATE 23514.
INSERT INTO portfolio."cooperative_account" ("account_id", "member_id", "account_number", "account_type", "balance")
VALUES (109, 1, 'SYN-CASE-BAL', 'case-balance', -1);

-- 9. loan primary key. Expected: pk_loan, SQLSTATE 23505.
INSERT INTO portfolio."loan" ("loan_id", "account_id", "application_number", "principal", "interest_rate", "status", "opened_on")
VALUES (5, 3, 'SYN-CASE-PK', 100, 4, 'approved', '2025-05-04');

-- 10. loan unique application. Expected: uq_loan_0, SQLSTATE 23505.
INSERT INTO portfolio."loan" ("loan_id", "account_id", "application_number", "principal", "interest_rate", "status", "opened_on")
VALUES (105, 3, 'SYN-APP-001', 100, 4, 'approved', '2025-05-05');

-- 11. loan foreign key. Expected: fk_loan_0, SQLSTATE 23503.
INSERT INTO portfolio."loan" ("loan_id", "account_id", "application_number", "principal", "interest_rate", "status", "opened_on")
VALUES (106, 9002, 'SYN-CASE-FK', 100, 4, 'approved', '2025-05-06');

-- 12. loan principal check. Expected: br_loan_principal_check, SQLSTATE 23514.
INSERT INTO portfolio."loan" ("loan_id", "account_id", "application_number", "principal", "interest_rate", "status", "opened_on")
VALUES (110, 3, 'SYN-CASE-PRINCIPAL', 0, 4, 'approved', '2025-05-07');

-- 13. loan status check. Expected: br_loan_status_check, SQLSTATE 23514.
INSERT INTO portfolio."loan" ("loan_id", "account_id", "application_number", "principal", "interest_rate", "status", "opened_on")
VALUES (111, 3, 'SYN-CASE-STATUS', 100, 4, 'pending', '2025-05-08');

-- 14. loan partial unique. Expected: br_one_pending_application, SQLSTATE 23505.
INSERT INTO portfolio."loan" ("loan_id", "account_id", "application_number", "principal", "interest_rate", "status", "opened_on")
VALUES (112, 3, 'SYN-CASE-PENDING', 100, 4, 'applied', '2025-05-09');

-- 15. repayment primary key. Expected: pk_repayment, SQLSTATE 23505.
INSERT INTO portfolio."repayment" ("repayment_id", "loan_id", "payment_sequence", "paid_on", "amount", "payment_method")
VALUES (7, 5, 2, '2025-05-10', 50, 'transfer');

-- 16. repayment unique sequence. Expected: uq_repayment_0, SQLSTATE 23505.
INSERT INTO portfolio."repayment" ("repayment_id", "loan_id", "payment_sequence", "paid_on", "amount", "payment_method")
VALUES (107, 5, 1, '2025-05-11', 50, 'transfer');

-- 17. repayment foreign key. Expected: fk_repayment_0, SQLSTATE 23503.
INSERT INTO portfolio."repayment" ("repayment_id", "loan_id", "payment_sequence", "paid_on", "amount", "payment_method")
VALUES (108, 9003, 2, '2025-05-12', 50, 'transfer');

-- 18. repayment amount check. Expected: br_repayment_amount_check, SQLSTATE 23514.
INSERT INTO portfolio."repayment" ("repayment_id", "loan_id", "payment_sequence", "paid_on", "amount", "payment_method")
VALUES (113, 5, 2, '2025-05-13', 0, 'transfer');
