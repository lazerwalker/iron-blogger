class Blogger < ActiveRecord::Base
  attr_accessible :feed, :name

  def feed_title
    parsed_feed.title
  end

  def last_updated
    parsed_feed.entries.first.published
  end

  def has_blogged_this_week?
    has_blogged_x_weeks_ago? 0
  end

  def has_blogged_last_week?
    has_blogged_x_weeks_ago? 1
  end

  def last_post
    parsed_feed.entries.first
  end

  def last_week_end_date
    start_of_week
  end

  def total_owed
    missed_weeks = 0

    return "$0" if number_of_weeks < 1

    number_of_weeks.times do |x|
      if !has_blogged_x_weeks_ago?(x+1)
        missed_weeks += 1
      end
    end
    "$#{missed_weeks * 5}"
  end

  def streak
    return 1 if number_of_weeks < 1

    current_streak = 0
    number_of_weeks.times do |x|
      weeks_ago = x+1
      if has_blogged_x_weeks_ago?(weeks_ago)
        current_streak += 1
      else
        return current_streak
      end
    end
    return current_streak
  end

  private

  def start_date
    @start_date ||= noon Date.parse("2014-01-20")
  end

  def number_of_weeks
    @num_weeks ||= (((start_of_week + 1.week).to_date - start_date.to_date)/7).to_i
  end

  def has_blogged_x_weeks_ago?(x = 0)
    start_date = start_of_x_weeks_ago(x)
    end_date = start_date + 1.week

    return false if end_date < noon(start_date)

    entries = parsed_feed.entries.select { |e| e.published > start_date && e.published < end_date }
    entries.count > 0
  end

  def parsed_feed
    @parsed_feed ||= Feedzirra::Feed.fetch_and_parse(feed)
  end

  def noon(date)
    return date.midnight + 12.hours
  end

  def start_of_week
    noon Date.today.at_beginning_of_week
  end

  def start_of_x_weeks_ago(x = 0)
    start_of_week - x.weeks
  end
end
