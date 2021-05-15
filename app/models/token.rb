class Token < ApplicationRecord
  belongs_to :furbaby, required: false

  belongs_to :user
  validates :vibes, numericality: { only_integer: true }
  before_validation do
    if !self.vibes
      self.vibes = 0
    end
  end
end
