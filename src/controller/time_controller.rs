use crate::lambda_api::{ApiRequest, ApiResponse};
use crate::repository::time_repository;
use crate::repository::time_repository::Time;
use chrono::Utc;

pub fn put(request: ApiRequest) -> ApiResponse {
    time_repository::save(Time {
        user_id: "batata".to_string(),
        is_holiday: false,
        is_leave: false,
        registered_date: Utc::now(),
        created_at: Utc::now(),
        updated_at: Utc::now(),
    });

    ApiResponse {
        status_code: 201,
        ..Default::default()
    }
}
