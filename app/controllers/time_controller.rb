require 'singleton'

class TimeController
    include Singleton

    def handle_request(event, context)
        { statusCode: 200, body: JSON.generate(event) }
    end
end