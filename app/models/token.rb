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
def Token.symbol_id(s)
  Token.where.not(furbaby_id:nil).filter{|t| t.furbaby.numerical_pheno.last == s}
end
def Token.symbol_total(s)
  Token.symbol_id(s).inject(0) {|a,t| a+t.vibes}
end
