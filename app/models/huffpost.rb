class Huffpost < ApplicationRecord
  scope :past_day, -> { where("created_at > ?", Time.now-1.days) }

  def odd?(n)
    if n % 2 == 0
      @num = false
    end
    @num
  end
  
end
