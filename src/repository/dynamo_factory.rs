use rusoto_core::Region;
use rusoto_dynamodb::{AttributeValue, DynamoDb, DynamoDbClient, PutItemInput};
use std::result::Result;

pub struct AttributeValueFactory {}

impl AttributeValueFactory {
    pub fn build_number<I>(value: I) -> AttributeValue
    where
        I: Into<String>,
    {
        AttributeValue {
            n: Some(value.into()),
            ..Default::default()
        }
    }

    pub fn build_bool(value: bool) -> AttributeValue {
        AttributeValue {
            bool: Some(value),
            ..Default::default()
        }
    }
}

pub struct PutItemInputFactory {}
impl PutItemInputFactory {
    pub fn build<I>(table_name: I, items: Vec<(I, AttributeValue)>) -> PutItemInput
    where
        I: Into<String>,
    {
        PutItemInput {
            table_name: table_name.into(),
            item: items
                .into_iter()
                .map(|(name, value)| (name.into(), value))
                .collect(),
            ..Default::default()
        }
    }
}

pub struct DynamoDbProxy {
    client: DynamoDbClient,
}
impl DynamoDbProxy {
    pub fn new() -> DynamoDbProxy {
        DynamoDbProxy {
            client: DynamoDbClient::new(Region::UsEast1),
        }
    }

    pub fn put_item(&self, input: PutItemInput) -> Result<(), String> {
        match self.client.put_item(input).sync() {
            Ok(_) => Ok(()),
            Err(error) => Err(error.to_string()),
        }
    }
}
