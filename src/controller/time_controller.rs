use crate::lambda_api::{ApiRequest, ApiResponse};
use crate::repository::time_repository::{Time, TimeRepository};
use serde_json;
use chrono::Utc;

pub struct TimeController {
    repository: TimeRepository,
}

impl TimeController {
    pub fn new() -> TimeController {
        TimeController {
            repository: TimeRepository::new(),
        }
    }

    pub fn put(&self, request: ApiRequest) -> ApiResponse {
        let mut time: Time = serde_json::from_str(request.body.as_str()).unwrap();
        time.created_at = Utc::now();
        time.updated_at = Utc::now();

        let result = self.repository.save(time);

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
}
