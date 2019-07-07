require 'singleton'
require_relative 'base_repository'

class UserPreferencesRepository < BaseRepository
  include Singleton

  def table_name
    "UserPreferences"
  end

  def save_user_preferences(user_preferences)
    puts "Saving user preferences=#{user_preferences}"
    save(user_preferences)
  end

  def get_user_preferences(user_id)
    puts "Searching user preferences with user_id=#{user_id}"
    search_item("user_id", user_id)
  end

end
