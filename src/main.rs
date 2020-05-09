extern crate chrono;
extern crate log;
extern crate rusoto_core;
extern crate rusoto_dynamodb;
extern crate serde_json;

mod controller;
mod lambda_api;
mod repository;

use controller::time_controller::TimeController;
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
    let time_controller = TimeController::new();

    let response = match request.resource.as_str() {
        "/api/time" => time_controller.put(request),
        _ => ApiResponse {
            status_code: 404,
            ..Default::default()
        },
    };

    Ok(response)
}
