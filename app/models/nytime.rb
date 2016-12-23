class Nytime < ApplicationRecord

  scope :past_day, -> { where("created_at > ?", Time.now-1.days) }

  def self.third_count
    nytimes = Nytime.past_day.all
    daily_count = nytimes.count
    third_count = daily_count / 3
    third_count
  end

  def self.third_count_2
    nytimes = Nytime.past_day.all
    daily_count = nytimes.count
    third_count = daily_count / 3
    third_count * 2
  end

  def self.third_count_3
    nytimes = Nytime.past_day.all
    daily_count = nytimes.count
    third_count = daily_count / 3
    third_count * 3
  end

end
