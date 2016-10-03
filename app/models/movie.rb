class Movie < ApplicationRecord

  scope :past_day, -> { where("created_at > ?", Time.now-1.days) }

  def self.first_three
    Movie.first(3)
  end
end
