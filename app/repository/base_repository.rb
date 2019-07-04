class BaseRepository

  def initialize(dynamo_db=nil)
    @dynamo_db = dynamo_db.nil? ? Aws::DynamoDB::Client.new(region: 'us-west-2') : dynamo_db
  end

  def save(item)
    params = {
        table_name: table_name,
        item: item
    }

    execute do
      puts "Saving item=#{item}"
      @dynamo_db.put_item(params)
      puts "Saved item=#{item} on #{table_name}"
    end
  end

  def search_item(hash_key_name, hash_key, range_key_name=nil, range_key=nil)
    params = {
        table_name: table_name,
        key: {
            hash_key_name => hash_key,
        }
    }
    if range_key_name && range_key
      params[:key][range_key_name] = range_key
    end

    execute do
      result = @dynamo_db.get_item(params)
      puts "Found #{table_name}=#{result.item}"
      result.item
    end
  end

  private

  def execute
    begin
      yield
    rescue  Aws::DynamoDB::Errors::ServiceError => error
      message = "Unable to execute action table=#{table_name} with error=#{error.message}"
      puts message
      raise ArgumentError, message
    end
  end

end
