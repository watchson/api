require_relative '../../app/controller/time_controller'

describe TimeController, "TimeController" do

  context "received unsupported request" do
    it "should return 501" do
      time_repository = double(:add_time => nil)
      time_controller = TimeController.send :new, time_repository
      event = { "httpMethod" => "POST" }

      response = time_controller.handle_request(event, nil)

      expect(response[:statusCode]).to eq(501)
    end
  end
  
  context "received a PUT request" do
    before(:each) do
      @time_repository = double(:add_time => nil)
      @time_controller = TimeController.send :new, @time_repository
      @event = {
          "httpMethod" => "PUT",
          "body" => '{"user_id":"potato","registered_date":"2019-01-01 01:02:03","is_holiday":false,"is_leave":true,"comments":"Batata"}'
      }
    end

    it "return 201 as response" do
      response = @time_controller.handle_request(@event, nil)

      expect(response[:statusCode]).to eq(201)
    end
    
    it "call repository to save time" do
      @time_controller.handle_request(@event, nil)

      expect(@time_repository).to have_received(:add_time).with("potato", "2019-01-01 01:02:03", false, true, "Batata")
    end

    it "return 500 when repository fails" do
      allow(@time_repository).to receive(:add_time).and_raise(ArgumentError.new("Error Message"))

      response = @time_controller.handle_request(@event, nil)

      expect(response[:statusCode]).to eq(500)
      expect(response[:body]).to eq("Error Message")
    end
  end

  context "received a PATCH request" do
    before(:each) do
      @time_repository = double(:update_time => nil)
      @time_controller = TimeController.send :new, @time_repository
      @event = {
          "httpMethod" => "PATCH",
          "body" => '{"user_id":"potato","registered_date":"2019-01-01 01:02:03","is_holiday":false,"is_leave":true,"comments":"Batata"}'
      }
    end

    it "return 200 as response" do
      response = @time_controller.handle_request(@event, nil)

      expect(response[:statusCode]).to eq(200)
    end

    it "call repository to update time" do
      @time_controller.handle_request(@event, nil)

      expect(@time_repository).to have_received(:update_time).with("potato", "2019-01-01 01:02:03", false, true, "Batata")
    end

    it "return 500 when repository fails" do
      allow(@time_repository).to receive(:update_time).and_raise(ArgumentError.new("Error Message"))

      response = @time_controller.handle_request(@event, nil)

      expect(response[:statusCode]).to eq(500)
      expect(response[:body]).to eq("Error Message")
    end
  end

  context "received a GET request" do
    before(:each) do
      @time_repository = double(:list_times => nil)
      @time_controller = TimeController.send :new, @time_repository
      @event = {
          "httpMethod" => "GET",
          "queryStringParameters" => {"user_id" => "potato", "start_date" => "123", "end_date" => "456"}
      }
    end

    it "return 200 as response" do
      response = @time_controller.handle_request(@event, nil)

      expect(response[:statusCode]).to eq(200)
    end

    it "return times" do
      time = {"user_id": "dawson"}
      allow(@time_repository).to receive(:list_times).with("potato", "123", "456") { [time] }

      response = @time_controller.handle_request(@event, nil)

      expect(response[:body]).to eq([time].to_json)
    end

    it "return 500 when repository fails" do
      allow(@time_repository).to receive(:list_times).and_raise(ArgumentError.new("Error Message"))

      response = @time_controller.handle_request(@event, nil)

      expect(response[:statusCode]).to eq(500)
      expect(response[:body]).to eq("Error Message")
    end
  end
end
