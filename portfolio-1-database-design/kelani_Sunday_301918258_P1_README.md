# Portfolio 1 — Database Design and Modelling

I organised the data into member, cooperative_account, loan, repayment. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| member | 2 |
| cooperative_account | 2 |
| loan | 2 |
| repayment | 2 |

The 18 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](kelani_Sunday_301918258_P1_Design.md)
- [ER diagram](kelani_Sunday_301918258_P1_ERDiagram.md)
- [Normalisation](kelani_Sunday_301918258_P1_Normalisation.md)
- [Schema](kelani_Sunday_301918258_P1_Schema.sql)
- [Sample data](kelani_Sunday_301918258_P1_SampleData.sql)
- [Constraint tests](kelani_Sunday_301918258_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/kelani_Sunday_301918258_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

