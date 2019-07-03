require 'singleton'
require 'aws-sdk-dynamodb'
require 'date'
require_relative 'base_repository'

class TimeRepository < BaseRepository
  include Singleton

  def table_name
    "Time"
  end

  def add_time(user_id, registered_date, is_holiday, is_leave, comments)
    now = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    item = {
        user_id: user_id,
        registered_date: registered_date,
        is_holiday: is_holiday,
        is_leave: is_leave,
        comments: comments,
        created_at: now,
        updated_at: now
    }

    puts "Adding item=#{item}"
    save(item)
  end

end