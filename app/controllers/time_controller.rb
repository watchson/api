require 'json'

def lambda_handler(event:, context:)
    # { event: JSON.generate(event), context: JSON.generate(context.inspect) }
    { statusCode: 200, body: JSON.generate(event) }
end

