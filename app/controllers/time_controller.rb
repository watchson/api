class TimeController

    def self.get_instance
        TimeController.new
    end

    def handle_request(event, context)
        { statusCode: 200, body: JSON.generate(event) }
    end
end