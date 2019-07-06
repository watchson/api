require 'singleton'
require 'json'
require_relative '../repository/time_repository'

class TimeController
    include Singleton

    def initialize(time_repository = nil)
        @time_repository = time_repository.nil? ? TimeRepository.instance : time_repository
    end

    def handle_request(event, context)
        http_method = event["httpMethod"]

        begin
            case http_method
            when "PUT"
                add_operation(JSON.parse(event["body"], symbolize_names: true))
                { statusCode: 201 }
            when "PATCH"
                update_operation(JSON.parse(event["body"], symbolize_names: true))
                { statusCode: 200 }
            when "GET"
                body = get_operation(event["pathParameters"], event["queryStringParameters"]).to_json
                { statusCode: 200, body: body}
            else
                { statusCode: 501 }
            end
        rescue ArgumentError => error
            { statusCode: 500, body: error.message }
        end
    end

    private

    def add_operation(body)
        puts "Received request=#{body} to add time"
        @time_repository.add_time(body[:user_id],
                                  body[:registered_date],
                                  body[:is_holiday],
                                  body[:is_leave],
                                  body[:comments])
    end

    def update_operation(body)
        puts "Received request=#{body} to update time"
        @time_repository.update_time(body[:user_id],
                                     body[:registered_date],
                                     body[:is_holiday],
                                     body[:is_leave],
                                     body[:comments])
    end

    def get_operation(path_parameters, query_parameters)
        puts "Received request=[#{path_parameters} - #{query_parameters}] to list items"
        @time_repository.list_times(path_parameters["user_id"],
                                    query_parameters["start_date"],
                                    query_parameters["end_date"])
    end

end