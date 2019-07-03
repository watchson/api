class BaseRepository

  def initialize
    @dynamo_db = Aws::DynamoDB::Client.new(region: 'us-west-2')
  end

  def save(item)
    params = {
        table_name: table_name,
        item: item
    }

    begin
      puts "Saving item=#{item}"
      @dynamo_db.put_item(params)
      puts "Saved item=#{item} on #{table_name}"
    rescue  Aws::DynamoDB::Errors::ServiceError => error
      message = "Unable to save item=#{item} on table=#{table_name} with error=#{error.message}"
      puts message
      raise ArgumentError, message
    end
  end

end
