require 'singleton'
require 'json'
require_relative '../repository/time_repository'

class TimeController
    include Singleton

    def add_time(body)
        puts "Received request=#{body} to add time"
        TimeRepository.instance.add_time(body[:user_id],
                                         body[:registered_date],
                                         body[:is_holiday],
                                         body[:is_leave],
                                         body[:comments])
    end

    def handle_request(event, context)
        http_method = event["httpMethod"]

        case http_method
        when "POST"
            add_time(JSON.parse(event["body"], symbolize_names: true))
            { statusCode: 200 }
        else
            { statusCode: 501 }
        end
    end
end