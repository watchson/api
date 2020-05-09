use crate::repository::dynamo_factory::{
    AttributeValueFactory, DynamoDbProxy, PutItemInputFactory,
};
use chrono::{DateTime, Utc};
use serde_derive::Deserialize;
use std::result::Result;

#[derive(Deserialize)]
pub struct Time {
    pub user_id: String,
    pub is_holiday: bool,
    pub is_leave: bool,
    pub registered_date: DateTime<Utc>,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

pub struct TimeRepository {
    database_proxy: DynamoDbProxy,
}
impl TimeRepository {
    pub fn new() -> TimeRepository {
        TimeRepository {
            database_proxy: DynamoDbProxy::new(),
        }
    }

    pub fn save(&self, time: Time) -> Result<(), String> {
        let input = PutItemInputFactory::build(
            "Time",
            vec![
                (
                    "created_at",
                    AttributeValueFactory::build_number(time.created_at.timestamp().to_string()),
                ),
                (
                    "updated_at",
                    AttributeValueFactory::build_number(time.updated_at.timestamp().to_string()),
                ),
                (
                    "registered_date",
                    AttributeValueFactory::build_number(
                        time.registered_date.timestamp().to_string(),
                    ),
                ),
                (
                    "is_holiday",
                    AttributeValueFactory::build_bool(time.is_holiday),
                ),
                ("user_id", AttributeValueFactory::build_number(time.user_id)),
                ("is_leave", AttributeValueFactory::build_bool(time.is_leave)),
            ],
        );

        self.database_proxy.put_item(input)
    }
}
