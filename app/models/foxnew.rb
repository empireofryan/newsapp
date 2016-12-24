class Foxnew < ApplicationRecord
  scope :past_day, -> { where("created_at > ?", Time.now-1.days) }

  def self.headline
    foxnew = Foxnew.past_day.all
    foxnew[0]
  end

  def self.subhead
    foxnew = Foxnew.past_day.all
    foxnew[1..5]
  end
end
