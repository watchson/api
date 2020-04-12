use chrono::{DateTime, Utc};
use rusoto_core::Region;
use rusoto_dynamodb::{AttributeValue, DynamoDb, DynamoDbClient, PutItemInput};
use std::collections::HashMap;
use std::result::Result;

pub struct Time {
    pub user_id: String,
    pub is_holiday: bool,
    pub is_leave: bool,
    pub registered_date: DateTime<Utc>,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

pub fn save(time: Time) -> Result<(), String> {
    let client = DynamoDbClient::new(Region::UsEast1);
    let mut item = HashMap::new();
    item.insert(
        "created_at".to_string(),
        AttributeValue {
            n: Some(time.created_at.timestamp().to_string()),
            ..Default::default()
        },
    );

    item.insert(
        "updated_at".to_string(),
        AttributeValue {
            n: Some(time.updated_at.timestamp().to_string()),
            ..Default::default()
        },
    );

    item.insert(
        "registered_date".to_string(),
        AttributeValue {
            n: Some(time.registered_date.timestamp().to_string()),
            ..Default::default()
        },
    );

    item.insert(
        "user_id".to_string(),
        AttributeValue {
            s: Some(time.user_id),
            ..Default::default()
        },
    );

    item.insert(
        "is_holiday".to_string(),
        AttributeValue {
            bool: Some(time.is_holiday),
            ..Default::default()
        },
    );
    item.insert(
        "is_leave".to_string(),
        AttributeValue {
            bool: Some(time.is_leave),
            ..Default::default()
        },
    );

    let input = PutItemInput {
        table_name: "Time".to_string(),
        item: item,
        ..Default::default()
    };

    match client.put_item(input).sync() {
        Ok(_) => Ok(()),
        Err(error) => Err(error.to_string()),
    }
}
