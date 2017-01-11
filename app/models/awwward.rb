class Awwward < ApplicationRecord
  scope :past_day, -> { where("created_at > ?", Time.now-1.days) }
  scope :past_month, -> { where("created_at > ?", Time.now-20.days) }
end
