use crate::lambda_api::{ApiRequest, ApiResponse};
use crate::repository::time_repository;
use crate::repository::time_repository::Time;
use chrono::Utc;

pub fn put(_request: ApiRequest) -> ApiResponse {
    let result = time_repository::save(Time {
        user_id: "batata".to_string(),
        is_holiday: false,
        is_leave: false,
        registered_date: Utc::now(),
        created_at: Utc::now(),
        updated_at: Utc::now(),
    });

    match result {
        Ok(_) => ApiResponse {
            status_code: 201,
            ..Default::default()
        },
        Err(error) => ApiResponse {
            status_code: 500,
            body: error,
            ..Default::default()
        },
    }
}
