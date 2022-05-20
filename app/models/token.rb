class Token < ApplicationRecord
  belongs_to :user

  before_validation :generate_value
  before_validation :set_expires_at

  def generate_value
    self.value = SecureRandom.hex if self.value.nil?
  end

  def set_expires_at
    self.expires_at = 1.day.from_now if self.expires_at.nil?
  end
end
