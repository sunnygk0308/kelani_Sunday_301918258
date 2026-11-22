-- Cooperative and Loan Services: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."member" (
  "member_id" bigint NOT NULL,
  "full_name" text NOT NULL,
  "email" text NOT NULL,
  "joined_on" date NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_member" PRIMARY KEY ("member_id"),
  CONSTRAINT "uq_member_0" UNIQUE ("email")
);
CREATE TABLE portfolio."cooperative_account" (
  "account_id" bigint NOT NULL,
  "member_id" bigint NOT NULL,
  "account_number" text NOT NULL,
  "account_type" text NOT NULL,
  "balance" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_cooperative_account" PRIMARY KEY ("account_id"),
  CONSTRAINT "uq_cooperative_account_0" UNIQUE ("account_number"),
  CONSTRAINT "uq_cooperative_account_1" UNIQUE ("member_id", "account_type")
);
CREATE TABLE portfolio."loan" (
  "loan_id" bigint NOT NULL,
  "account_id" bigint NOT NULL,
  "application_number" text NOT NULL,
  "principal" numeric(18,2) NOT NULL,
  "interest_rate" numeric(18,2) NOT NULL,
  "status" text NOT NULL,
  "opened_on" date NOT NULL,
  CONSTRAINT "pk_loan" PRIMARY KEY ("loan_id"),
  CONSTRAINT "uq_loan_0" UNIQUE ("application_number")
);
CREATE TABLE portfolio."repayment" (
  "repayment_id" bigint NOT NULL,
  "loan_id" bigint NOT NULL,
  "payment_sequence" bigint NOT NULL,
  "paid_on" date NOT NULL,
  "amount" numeric(18,2) NOT NULL,
  "payment_method" text NOT NULL,
  CONSTRAINT "pk_repayment" PRIMARY KEY ("repayment_id"),
  CONSTRAINT "uq_repayment_0" UNIQUE ("loan_id", "payment_sequence")
);
ALTER TABLE portfolio."cooperative_account" ADD CONSTRAINT "fk_cooperative_account_0" FOREIGN KEY ("member_id") REFERENCES portfolio."member" ("member_id");
ALTER TABLE portfolio."loan" ADD CONSTRAINT "fk_loan_0" FOREIGN KEY ("account_id") REFERENCES portfolio."cooperative_account" ("account_id");
ALTER TABLE portfolio."repayment" ADD CONSTRAINT "fk_repayment_0" FOREIGN KEY ("loan_id") REFERENCES portfolio."loan" ("loan_id");
ALTER TABLE portfolio."cooperative_account" ADD CONSTRAINT "br_account_balance_check" CHECK ("balance" >= 0);
ALTER TABLE portfolio."loan" ADD CONSTRAINT "br_loan_principal_check" CHECK ("principal" > 0);
ALTER TABLE portfolio."loan" ADD CONSTRAINT "br_loan_status_check" CHECK (("status" = 'applied') OR ("status" = 'approved') OR ("status" = 'disbursed') OR ("status" = 'closed') OR ("status" = 'rejected'));
CREATE UNIQUE INDEX "br_one_pending_application" ON portfolio."loan" ("account_id") WHERE ("status" = 'applied');
ALTER TABLE portfolio."repayment" ADD CONSTRAINT "br_repayment_amount_check" CHECK ("amount" > 0);
COMMIT;
