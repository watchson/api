extern crate log;
extern crate chrono;
extern crate rusoto_core;
extern crate rusoto_dynamodb;

mod controller;
mod lambda_api;
mod repository;

use controller::time_controller;
use lambda_api::{ApiRequest, ApiResponse};
use lambda_runtime::{error::HandlerError, lambda, Context};

use simple_logger;
use std::error::Error;

fn main() -> Result<(), Box<dyn Error>> {
    simple_logger::init_with_level(log::Level::Info)?;
    lambda!(api_gateway_handler);

    Ok(())
}

pub fn api_gateway_handler(request: ApiRequest, _c: Context) -> Result<ApiResponse, HandlerError> {
    let response = match request.resource.as_str() {
        "/api/time" => time_controller::put(request),
        "/api/time/{user_id}" => ApiResponse {
            status_code: 200,
            ..Default::default()
        },
        "/api/user_preferences" => ApiResponse {
            status_code: 200,
            ..Default::default()
        },
        "/api/user_preferences/{user_id}" => ApiResponse {
            status_code: 200,
            ..Default::default()
        },
        _ => ApiResponse {
            status_code: 404,
            ..Default::default()
        },
    };

    Ok(response)
}
