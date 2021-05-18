class User < ApplicationRecord
  has_many :tokens
  has_many :furbabies, through: :tokens
  has_and_belongs_to_many :messages
  validates :name, presence: true
  validates :name, format: { with: /\A[_a-zA-Z0-9]+\z/,
    message: "can only be: _, a-z, A-Z, or 0-9"}
  validates :name, uniqueness: true
  has_secure_password

  def networth
    self.tokens.inject(0) do |a,b| a+b.vibes end
  end

  def empty_token
    self.tokens.filter {|t|!t.furbaby}.first
  end

  def egg
    self.tokens.filter {|t|t.furbaby and t.furbaby.egg?}.first
  end

  def egg?
    !!self.egg
  end
end
