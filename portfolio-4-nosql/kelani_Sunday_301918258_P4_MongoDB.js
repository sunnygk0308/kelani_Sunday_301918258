// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("loan_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("loan_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "loan_application_submitted",
                    "loan_disbursed"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "loan"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "loan_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("loan_events").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "loan_disbursed",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "loan",
                    "key": {
                        "loan_id": 5
                    },
                    "field": "status",
                    "value": "applied"
                },
                {
                    "entity": "loan",
                    "key": {
                        "loan_id": 5
                    },
                    "field": "principal",
                    "value": 1000
                },
                {
                    "entity": "loan",
                    "key": {
                        "loan_id": 5
                    },
                    "field": "interest_rate",
                    "value": 4.5
                }
            ],
            "examples": {
                "amount": "illustrative amount",
                "paid_on": "illustrative paid_on"
            }
        }
    },
    {
        "_id": "event_000003",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "loan_application_submitted",
        "occurredAt": ISODate("2030-01-01T10:02:00Z"),
        "source": {
            "entity": "loan",
            "key": {
                "loan_id": 6
            },
            "snapshot": {
                "loan_id": 6,
                "account_id": 4,
                "application_number": "SYN-APP-002",
                "principal": 750,
                "interest_rate": 5,
                "status": "approved",
                "opened_on": "2025-03-05"
            }
        },
        "embedded": {
            "cooperative_account": [
                {
                    "key": {
                        "account_id": 4
                    },
                    "snapshot": {
                        "account_id": 4,
                        "member_id": 2,
                        "account_number": "SYN-ACC-002",
                        "account_type": "share",
                        "balance": 400
                    },
                    "via": [
                        "loan.account_id → cooperative_account"
                    ]
                }
            ],
            "member": [
                {
                    "key": {
                        "member_id": 2
                    },
                    "snapshot": {
                        "member_id": 2,
                        "full_name": "Jordan Sample",
                        "email": "jordan@example.test",
                        "joined_on": "2025-02-15",
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
    },
    {
        "_id": "event_000004",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "loan_disbursed",
        "occurredAt": ISODate("2030-01-01T10:03:00Z"),
        "source": {
            "entity": "loan",
            "key": {
                "loan_id": 6
            },
            "snapshot": {
                "loan_id": 6,
                "account_id": 4,
                "application_number": "SYN-APP-002",
                "principal": 750,
                "interest_rate": 5,
                "status": "approved",
                "opened_on": "2025-03-05"
            }
        },
        "embedded": {
            "cooperative_account": [
                {
                    "key": {
                        "account_id": 4
                    },
                    "snapshot": {
                        "account_id": 4,
                        "member_id": 2,
                        "account_number": "SYN-ACC-002",
                        "account_type": "share",
                        "balance": 400
                    },
                    "via": [
                        "loan.account_id → cooperative_account"
                    ]
                }
            ],
            "member": [
                {
                    "key": {
                        "member_id": 2
                    },
                    "snapshot": {
                        "member_id": 2,
                        "full_name": "Jordan Sample",
                        "email": "jordan@example.test",
                        "joined_on": "2025-02-15",
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "loan",
                    "key": {
                        "loan_id": 6
                    },
                    "field": "status",
                    "value": "approved"
                },
                {
                    "entity": "loan",
                    "key": {
                        "loan_id": 6
                    },
                    "field": "principal",
                    "value": 750
                },
                {
                    "entity": "loan",
                    "key": {
                        "loan_id": 6
                    },
                    "field": "interest_rate",
                    "value": 5
                }
            ],
            "examples": {
                "amount": "illustrative amount",
                "paid_on": "illustrative paid_on"
            }
        }
    }
]));
  await db.getCollection("loan_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("loan_events").find({"eventType":"loan_application_submitted"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("loan_events").find({"source.key.loan_id":5}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("loan_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("loan_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("loan_events").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("loan_events").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("loan_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
