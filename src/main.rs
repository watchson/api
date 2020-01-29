use lambda_runtime::{error::HandlerError, lambda, Context};
use serde_derive::{Deserialize, Serialize};
use simple_logger;
use std::collections::HashMap;
use std::error::Error;

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
struct ApiRequest {
    query_string_parameters: Option<HashMap<String, String>>,
}

#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
struct ApiResponse {    
    status_code: i32,
    body: String,    
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
            "{{\"response\": \"Welcome, {}!\" }}",
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