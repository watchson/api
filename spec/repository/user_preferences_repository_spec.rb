
require_relative '../../app/repository/user_preferences_repository'

describe UserPreferencesRepository, "UserPreferencesRepository" do
  context "UserPreferences" do
    before(:each) do
      @dynamo_db = double(:put_item => nil)
      @user_preferences_repository = UserPreferencesRepository.send :new, @dynamo_db
      @user_preferences = { user_id: "batata" }
    end

    it "save user preferences" do
      @user_preferences_repository.save_user_preferences(@user_preferences)

      expect(@dynamo_db).to have_received(:put_item) do |arg|
        expect(arg[:table_name]).to eq("UserPreferences")
        expect(arg[:item][:user_id]).to eq("batata")
      end
    end

    it "search user preferences" do
      params = {
          table_name: "UserPreferences",
          key: {
              "user_id" => "batata",
          }
      }
      allow(@dynamo_db).to receive(:get_item).with(params) { double(:item =>  @user_preferences) }

      @user_preferences_repository.save_user_preferences(@user_preferences)
    end

  end
end