require 'json'
require_relative 'app/controller/time_controller'

def register_controllers
    @controllers = {}
    @controllers["/api/time"] = TimeController.instance
end

def get_controller(path)
    if @controllers.nil?
        register_controllers
    end

    @controllers[path]
end

def handle_request(event:, context:)
    controller = get_controller(event["path"])

    controller.nil? ?
        { statusCode: 404 } :
        controller.handle_request(event, context)
end