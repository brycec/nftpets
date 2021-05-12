class Token < ApplicationRecord
  validates :vibes, numericality: { only_integer: true }
  before_validation do
    self.vibes = 0 if !self.vibes
  end
end
