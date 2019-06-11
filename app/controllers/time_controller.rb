require 'singleton'
require 'aws-sdk-dynamodb'  # v2: require 'aws-sdk'

class TimeController
    include Singleton

    def add_time
        dynamodb = Aws::DynamoDB::Client.new(region: 'us-west-2')
        item = {
            user_id: "1",
            date_registered: Time.now.strftime("%d/%m/%Y %H:%M")
        }

        params = {
            table_name: 'Time',
            item: item
        }

        begin
            dynamodb.put_item(params)
            puts 'Added time'
        rescue  Aws::DynamoDB::Errors::ServiceError => error
            puts 'Unable to add Time'
            puts error.message
        end
    end

    def handle_request(event, context)
        add_time
        { statusCode: 200, body: JSON.generate(event) }
    end
end