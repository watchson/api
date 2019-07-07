require 'singleton'
require_relative '../repository/user_preferences_repository'

class UserPreferencesController
  include Singleton

  def initialize(repository=nil)
    @repository = repository.nil? ? UserPreferencesRepository.instance : repository
  end

  def add_operation(user_preferences)
    puts "Received request=#{user_preferences} save user preferences"
    @repository.save_user_preferences(user_preferences)
  end

  def update_operation(user_preferences)
    puts "Received request=#{user_preferences} save user preferences"
    @repository.save_user_preferences(user_preferences)
  end

  def get_operation(path_parameters, query_parameters)
    puts "Received request=[#{path_parameters} - #{query_parameters}] to list items"
    @repository.get_user_preferences(path_parameters[:user_id])
  end

end