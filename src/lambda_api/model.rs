use serde_derive::{Deserialize, Serialize};
use std::collections::HashMap;

#[derive(Deserialize)]
pub enum HttpMethod {
    DELETE,
    GET,
    HEAD,
    OPTIONS,
    PATCH,
    POST,
    PUT,
}

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct ApiRequest {
    pub http_method: HttpMethod,
    pub resource: String,
    pub headers: Option<HashMap<String, String>>,
    pub path_parameters: Option<HashMap<String, String>>,
    pub query_string_parameters: Option<HashMap<String, String>>,
    pub multi_value_query_string_parameters: Option<HashMap<String, HashMap<String, String>>>,
    pub body: String,
}

#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
#[derive(Default)]
pub struct ApiResponse {
    pub status_code: i32,
    pub body: String,
    pub is_base64_encoded: bool,
    pub headers: HashMap<String, String>,
}
