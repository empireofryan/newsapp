class Nytime < ApplicationRecord

  scope :past_day, -> { where("created_at > ?", Time.now-1.days) }

end
