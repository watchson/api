require 'json'
require_relative 'app/controller/time_controller'
require_relative 'app/controller/user_preferences_controller'

def register_controllers
    @controllers = {}
    @controllers["/api/time"] = TimeController.instance
    @controllers["/api/time/{user_id}"] = TimeController.instance
    @controllers["/api/user_preferences"] = UserPreferencesController.instance
    @controllers["/api/user_preferences/{user_id}"] = UserPreferencesController.instance
end

def get_controller(resource)
    if @controllers.nil?
        register_controllers
    end

    @controllers[resource]
end

def handle_request(event:, context:)
    controller = get_controller(event["resource"])

    controller.nil? ?
        { statusCode: 404 } :
        call_controller(event, controller)
end

private

def call_controller(event, controller)
    http_method = event["httpMethod"]

    begin
        case http_method
        when "PUT"
            controller.add_operation(JSON.parse(event["body"], symbolize_names: true))
            { statusCode: 201 }
        when "PATCH"
            controller.update_operation(JSON.parse(event["body"], symbolize_names: true))
            { statusCode: 200 }
        when "GET"
            path_parameters = event["pathParameters"].transform_keys(&:to_sym)
            query_string_parameters = event["queryStringParameters"].transform_keys(&:to_sym)
            body = controller.get_operation(path_parameters, query_string_parameters).to_json
            { statusCode: 200, body: body}
        else
            { statusCode: 501 }
        end
    rescue ArgumentError => error
        { statusCode: 500, body: error.message }
    end
end