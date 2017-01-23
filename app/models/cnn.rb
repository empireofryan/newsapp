class Cnn < ApplicationRecord

  validates_uniqueness_of :title
  validates_uniqueness_of :url
#  validates :url, :presence => true, :uniqueness => true

  # validate :check_event_is_unique, :on => :create
  # after_create :create_vote_on_existing_event

  scope :past_day, -> { where("created_at > ?", Time.now-1.days) }

  # def check_event_is_unique
  #   if Cnn.where(title).any?
  #       errors.add(:base, :duplicate)
  #       return false
  #   end
  # end


end
