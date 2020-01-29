use lambda_runtime::{error::HandlerError, lambda, Context};
use serde_derive::{Deserialize, Serialize};
use simple_logger;
use std::collections::HashMap;
use std::error::Error;

#[derive(Deserialize)]
struct ApiRequest {
    #[serde(rename = "queryStringParameters")]
    query_string_parameters: Option<HashMap<String, String>>,
}

#[derive(Serialize)]
struct ApiResponse {
    #[serde(rename = "statusCode")]
    status_code: i32,
    body: String,
    #[serde(rename = "isBase64Encoded")]
    is_base64_encoded: bool,
    headers: HashMap<String, String>,
}

fn main() -> Result<(), Box<dyn Error>> {
    simple_logger::init_with_level(log::Level::Debug)?;
    lambda!(my_handler);

    Ok(())
}

fn my_handler(request: ApiRequest, _c: Context) -> Result<ApiResponse, HandlerError> {
    Ok(ApiResponse {
        status_code: 200,
        body: format!(
            "{{\"response\": \"Hellooooooooooooo, {}!\" }}",
            request
                .query_string_parameters
                .unwrap_or_default()
                .get("name")
                .unwrap_or(&"Stranger".to_string())
        ),
        is_base64_encoded: false,
        headers: HashMap::new(),
    })
}