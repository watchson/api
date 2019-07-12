require_relative '../../app/repository/time_repository'

describe TimeRepository, "TimeRepository" do
  context "Add Time" do
    before(:each) do
      @dynamo_db = double(:put_item => nil)
      @time_repository = TimeRepository.send :new, @dynamo_db
    end

    it "with all parameters" do
      @time_repository.add_time("potato", 2132131232, false, true, "Batata")

      expect(@dynamo_db).to have_received(:put_item) do |arg|
        expect(arg[:table_name]).to eq("Time")
        expect(arg[:item][:user_id]).to eq("potato")
        expect(arg[:item][:registered_date]).to eq(2132131232)
        expect(arg[:item][:is_holiday]).to be_falsey
        expect(arg[:item][:is_leave]).to be_truthy
        expect(arg[:item][:comments]).to eq("Batata")
        expect(arg[:item][:created_at]).to be_truthy
        expect(arg[:item][:updated_at]).to be_truthy
      end
    end

    it "save without comments" do
      @time_repository.add_time("potato", 231323213, false, true, nil)

      expect(@dynamo_db).to have_received(:put_item) do |arg|
        expect(arg[:table_name]).to eq("Time")
        expect(arg[:item][:user_id]).to eq("potato")
        expect(arg[:item][:registered_date]).to eq(231323213)
        expect(arg[:item][:is_holiday]).to be_falsey
        expect(arg[:item][:is_leave]).to be_truthy
        expect(arg[:item][:created_at]).to be_truthy
        expect(arg[:item][:updated_at]).to be_truthy
        expect(arg[:item]).not_to have_key(:comments)
      end
    end

    it "update item" do
      result = double(:item => {
          "user_id": "potato",
          registered_date: 231323213,
          is_holiday: true,
          is_leave: false
      })
      allow(@dynamo_db).to receive(:get_item) { result }

      @time_repository.update_time("potato", 231323213, false, true, "OPAAA")

      expect(@dynamo_db).to have_received(:put_item) do |arg|
        expect(arg[:table_name]).to eq("Time")
        expect(arg[:item][:user_id]).to eq("potato")
        expect(arg[:item][:registered_date]).to eq(231323213)
        expect(arg[:item][:is_holiday]).to be_falsey
        expect(arg[:item][:is_leave]).to be_truthy
        expect(arg[:item][:updated_at]).to be_truthy
        expect(arg[:item][:comments]).to eq("OPAAA")
      end
    end

    it "update item without null fields" do
      result = double(:item => {
          "user_id": "potato",
          registered_date: 231323213,
          is_holiday: true,
          is_leave: false
      })
      allow(@dynamo_db).to receive(:get_item) { result }

      @time_repository.update_time("potato", 231323213)

      expect(@dynamo_db).to have_received(:put_item) do |arg|
        expect(arg[:table_name]).to eq("Time")
        expect(arg[:item][:user_id]).to eq("potato")
        expect(arg[:item][:registered_date]).to eq(231323213)
        expect(arg[:item][:is_holiday]).to be_truthy
        expect(arg[:item][:is_leave]).to be_falsey
        expect(arg[:item][:updated_at]).to be_truthy
        expect(arg[:item]).not_to have_key(:comments)
      end
    end

    it "search items" do
      params = {
          table_name: "Time",
          key_condition_expression: "user_id = :user_id and registered_date between :start_date and :end_date",
          expression_attribute_values: {
              ":user_id" => "potato",
              ":start_date" => 231323213,
              ":end_date" => 231323213,
          }
      }

      item = {
          "user_id": "potato",
          registered_date: 231323213,
          is_holiday: true,
          is_leave: false
      }
      result = double(:items => [item])
      allow(@dynamo_db).to receive(:query).with(params) { result }

      items = @time_repository.list_times("potato", 231323213, 231323213)

      expect(items).to eq([item])
    end

    it "when DynamoDB throws error" do
      allow(@dynamo_db).to receive(:put_item).and_raise(ArgumentError.new)

      expect{@time_repository.add_time("potato", 231323213, false, true, "Batata")}.to raise_error(ArgumentError)
    end
  end
end