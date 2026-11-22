# Cooperative and Loan Services — ER diagram

```mermaid
erDiagram
    direction LR
    member {
        bigint member_id PK
        text full_name
        text email UK
        date joined_on
        boolean active
    }
    cooperative_account {
        bigint account_id PK
        bigint member_id FK
        text account_number UK
        text account_type
        numeric balance
    }
    loan {
        bigint loan_id PK
        bigint account_id FK
        text application_number UK
        numeric principal
        numeric interest_rate
        text status
        date opened_on
    }
    repayment {
        bigint repayment_id PK
        bigint loan_id FK
        integer payment_sequence
        date paid_on
        numeric amount
        text payment_method
    }
    member ||--o{ cooperative_account : "member_id"
    cooperative_account ||--o{ loan : "account_id"
    loan ||--o{ repayment : "loan_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/kelani_Sunday_301918258_ERDiagram.png)
