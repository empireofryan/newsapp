class Cnn < ApplicationRecord

  validates :title, :presence => true, :uniqueness => true
  validates :url, :presence => true, :uniqueness => true

  scope :past_day, -> { where("created_at > ?", Time.now-1.days) }

end
