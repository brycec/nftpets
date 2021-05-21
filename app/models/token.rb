class Token < ApplicationRecord
  belongs_to :furbaby, required: false

  belongs_to :user
  validates :vibes, numericality: { only_integer: true }
  before_validation do
    if !self.vibes
      self.vibes = 0
    end
  end

  def vibing?
    s=self.furbaby.trade_s
    Furbaby::TRADE_SYMS.entries.each_with_index.inject([]) { |a,(e,i)|
      a.push([i,Token.symbol_total(i)])
    }.min{|a,b|a[1]<=>b[1]}[0] == s
  end
end
def Token.symbol_id(s)
  Furbaby.with_symbol(s).joins(:token).map{|f|
      f.token
    }
end
def Token.symbol_total(s)
  Token.symbol_id(s).inject(0) {|a,t| a+t.vibes}
end
