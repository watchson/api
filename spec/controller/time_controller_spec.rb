require_relative '../../app/controller/time_controller'

describe TimeController, "TimeController" do
  context "Add Time" do
    before(:each) do
      @time_repository = double(:add_time => nil)
      @time_controller = TimeController.send :new, @time_repository
      @event = {
          "httpMethod" => "POST",
          "body" => '{"user_id":"potato","registered_date":"2019-01-01 01:02:03","is_holiday":false,"is_leave":true,"comments":"Batata"}'
      }
    end

    it "call repository to save time" do
      @time_controller.handle_request(@event, nil)

      expect(@time_repository).to have_received(:add_time).with("potato", "2019-01-01 01:02:03", false, true, "Batata")
    end

    it "when repository throws error" do
      allow(@time_repository).to receive(:add_time).and_raise(ArgumentError.new)

      expect{@time_controller.handle_request(@event, nil)}.to raise_error(ArgumentError)
    end
  end
end
