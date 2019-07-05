# Watchson API

## Time API
Endpoint `/api/time`

### PUT
**Adds a time**

* Dates must be in epoch format
* Comments is an optional field, you could omit it if not necessary

Payload:

```JSON
{
  "user_id": "potato",
  "registered_date": "1562328837",
  "is_holiday": false,
  "is_leave": true,
  "comments": "is good"
}
```

### PATCH
**Updates a time**

```JSON
{
  "user_id": "potato",
  "registered_date": "1562328837",
  "is_leave": false
}
```

### GET
**Retrieve the times between a date range**

`/api/time?user_id=dawsonfi&start_date=1562288422&end_date=1562364022`