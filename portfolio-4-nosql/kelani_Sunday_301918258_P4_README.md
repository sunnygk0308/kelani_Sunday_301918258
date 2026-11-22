# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection loan_events for loan_application_submitted and loan_disbursed events. These are fictional event examples based on loan, cooperative_account, member.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related cooperative_account, member details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "loan_application_submitted",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "loan",
        "key": {
            "loan_id": 5
        },
        "snapshot": {
            "loan_id": 5,
            "account_id": 3,
            "application_number": "SYN-APP-001",
            "principal": 1000,
            "interest_rate": 4.5,
            "status": "applied",
            "opened_on": "2025-03-01"
        }
    },
    "embedded": {
        "cooperative_account": [
            {
                "key": {
                    "account_id": 3
                },
                "snapshot": {
                    "account_id": 3,
                    "member_id": 1,
                    "account_number": "SYN-ACC-001",
                    "account_type": "share",
                    "balance": 250.5
                },
                "via": [
                    "loan.account_id → cooperative_account"
                ]
            }
        ],
        "member": [
            {
                "key": {
                    "member_id": 1
                },
                "snapshot": {
                    "member_id": 1,
                    "full_name": "Avery Example",
                    "email": "avery@example.test",
                    "joined_on": "2025-01-10",
                    "active": true
                },
                "via": [
                    "loan.account_id → cooperative_account.member_id → member"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 2 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 4 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("loan_events").find({"eventType":"loan_application_submitted"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "loan_application_submitted",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "loan_id": 5
    }
  },
  {
    "_id": "event_000003",
    "eventType": "loan_application_submitted",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "loan_id": 6
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("loan_events").find({"source.key.loan_id":5}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "loan_application_submitted",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "loan_id": 5
    }
  },
  {
    "_id": "event_000002",
    "eventType": "loan_disbursed",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "loan_id": 5
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("loan_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "loan_application_submitted",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "loan_id": 5
    }
  },
  {
    "_id": "event_000002",
    "eventType": "loan_disbursed",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "loan_id": 5
    }
  },
  {
    "_id": "event_000003",
    "eventType": "loan_application_submitted",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "loan_id": 6
    }
  },
  {
    "_id": "event_000004",
    "eventType": "loan_disbursed",
    "occurredAt": {
      "$date": "2030-01-01T10:03:00Z"
    },
    "source": {
      "loan_id": 6
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("loan_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| loan_application_submitted | 2 |
| loan_disbursed | 2 |

## Validation and suitability

MongoDB inserted 4 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 4 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run kelani_Sunday_301918258_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/kelani_Sunday_301918258_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

