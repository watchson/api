require_relative '../../app/repository/time_repository'

RSpec.describe TimeRepository, "TimeRepository" do
  context "Add Time" do
    it "with all parameters" do
      dynamo_db = double(:put_item => nil)
      time_repository = TimeRepository.send :new, dynamo_db

      time_repository.add_time("potato", "2019-01-01 01:02:03", false, true, "Batata")

      expect(dynamo_db).to have_received(:put_item) do |arg|
        expect(arg[:table_name]).to eq("Time")
        expect(arg[:item][:user_id]).to eq("potato")
        expect(arg[:item][:registered_date]).to eq("2019-01-01 01:02:03")
        expect(arg[:item][:is_holiday]).to be_falsey
        expect(arg[:item][:is_leave]).to be_truthy
        expect(arg[:item][:comments]).to eq("Batata")
        expect(arg[:item][:created_at]).to be_truthy
        expect(arg[:item][:updated_at]).to be_truthy
      end
    end
  end
end