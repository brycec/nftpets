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
    Token.trade_data.min{|a,b|a[:total]<=>b[:total]}[0] == s
  end
end
def Token.symbol_id(s)
  Furbaby.not_egg.with_symbol(s).joins(:token).map{|f|
      f.token
    }
end
def Token.symbol_total(s)
  Token.symbol_id(s).inject(0) {|a,t| a+t.vibes}
end
def Token.trade_data
  Furbaby::TRADE_SYMS.entries.each_with_index.inject([]) do |a,(e,i)|
    a.push({word: e[0], emoji: e[1], total: Token.symbol_total(i), sym: i})
    # sym coords would be [Furbaby::WORDS.length,i]
  end
end
