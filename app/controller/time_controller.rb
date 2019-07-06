require 'singleton'
require 'json'
require_relative '../repository/time_repository'

class TimeController
    include Singleton

    def initialize(time_repository = nil)
        @time_repository = time_repository.nil? ? TimeRepository.instance : time_repository
    end

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
        @time_repository.list_times(path_parameters[:user_id],
                                    query_parameters[:start_date],
                                    query_parameters[:end_date])
    end

end