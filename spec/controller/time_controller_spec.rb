require_relative '../../app/controller/time_controller'

describe TimeController, "TimeController" do

  context "received unsupported request" do
    it "should return 501" do
      time_repository = double(:add_time => nil)
      time_controller = TimeController.send :new, time_repository
      event = { "httpMethod" => "DELETE" }

      response = time_controller.handle_request(event, nil)

      expect(response[:statusCode]).to eq(501)
    end
  end
  
  context "received a POST request" do
    before(:each) do
      @time_repository = double(:add_time => nil)
      @time_controller = TimeController.send :new, @time_repository
      @event = {
          "httpMethod" => "POST",
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
end