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
    item = {
        user_id: user_id,
        registered_date: registered_date,
        is_holiday: is_holiday,
        is_leave: is_leave,
        comments: comments,
        created_at: now,
        updated_at: now
    }

    item.delete_if {|_, value| value.nil? }

    puts "Adding item=#{item}"
    save(item)
  end

  def update_time(user_id, registered_date, is_holiday=nil, is_leave=nil, comments=nil)
    puts "Received request=[#{user_id} - #{registered_date}] to update Time"

    item = search_item("user_id", user_id, "registered_date", registered_date)
    puts "Found item=#{item}"

    item[:registered_date] = registered_date
    item[:is_holiday] = is_holiday unless is_holiday.nil?
    item[:is_leave] = is_leave unless is_leave.nil?
    item[:comments] = comments unless comments.nil?
    item[:updated_at] = now

    puts "Saving updated item=#{item}"
    save(item)
  end

  def list_times(user_id, start_date, end_date)
    params = {
        ":user_id" => user_id.to_s,
        ":start_date" => start_date.to_i,
        ":end_date" => end_date.to_i,
    }

    query("user_id = :user_id and registered_date between :start_date and :end_date", params)
  end

  private

  def now
    Time.now.to_i
  end

end