require 'json'
require_relative 'app/controller/time_controller'

def register_controllers
    @controllers = {}
    @controllers["/api/time"] = TimeController.instance
    @controllers["/api/time/{user_id}"] = TimeController.instance
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
        controller.handle_request(event, context)
end