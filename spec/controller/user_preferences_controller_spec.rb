
require_relative '../../app/controller/user_preferences_controller'

describe UserPreferencesController, "UserPreferencesController" do

  context "received a add or update operation request" do
    before(:each) do
      @user_preferences_repository = double(:save_user_preferences => nil)
      @user_preferences_controller = UserPreferencesController.send :new, @user_preferences_repository
      @user_preferences = {
          user_id: "potato"
      }
    end

    it "call repository to save user preferences" do
      @user_preferences_controller.add_operation(@user_preferences)

      expect(@user_preferences_repository).to have_received(:save_user_preferences).with(@user_preferences)
    end

    it "call repository to update user preferences" do
      @user_preferences_controller.update_operation(@user_preferences)

      expect(@user_preferences_repository).to have_received(:save_user_preferences).with(@user_preferences)
    end
  end

  context "received a get operation request" do
    before(:each) do
      @user_preferences_repository = double(:get_user_preferences => nil)
      @user_preferences_controller = UserPreferencesController.send :new, @user_preferences_repository
      @user_preferences = {
          user_id: "potato"
      }
      @path_parameters = { user_id: "potato" }
    end

    it "return user preferences" do
      allow(@user_preferences_repository).to receive(:get_user_preferences).with("potato") { [@user_preferences] }

      response = @user_preferences_controller.get_operation(@path_parameters, nil)

      expect(response).to eq([@user_preferences])
    end

  end
end
