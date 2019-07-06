require_relative '../../app/controller/time_controller'

describe TimeController, "TimeController" do

  context "received a add or update operation request" do
    before(:each) do
      @time_repository = double(:add_time => nil, :update_time => nil)
      @time_controller = TimeController.send :new, @time_repository
      @body = {
          user_id: "potato",
          registered_date: "234789237842",
          is_holiday: false,
          is_leave: true,
          comments: "Batata"
      }
    end

    it "call repository to save time" do
      @time_controller.add_operation(@body)

      expect(@time_repository).to have_received(:add_time).with("potato", "234789237842", false, true, "Batata")
    end

    it "call repository to update time" do
      @time_controller.update_operation(@body)

      expect(@time_repository).to have_received(:update_time).with("potato", "234789237842", false, true, "Batata")
    end
  end

  context "received a GET request" do
    before(:each) do
      @time_repository = double(:list_times => nil)
      @time_controller = TimeController.send :new, @time_repository
      @path_parameters = { user_id: "potato" }
      @query_string_parameters = { start_date: "123", end_date: "456" }
    end

    it "return times" do
      time = {"user_id": "dawson"}
      allow(@time_repository).to receive(:list_times).with("potato", "123", "456") { [time] }

      response = @time_controller.get_operation(@path_parameters, @query_string_parameters)

      expect(response).to eq([time])
    end

  end
end
