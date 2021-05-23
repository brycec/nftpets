class Token < ApplicationRecord
  belongs_to :furbaby, required: false

  belongs_to :user
  validates :vibes, numericality: { only_integer: true }
  before_validation do
    if !self.vibes
      self.vibes = 0
    end
  end

  def vibes?
    if self.furbaby and self.furbaby.egg?
      '?'
    else
      self.vibes
    end
  end

  def vibing?
    s=self.furbaby.trade_s
    Token.trade_data.min{|a,b|a[:total]<=>b[:total]}[0] == s
  end

  def pet
    m=1 #multiplier
    if self.vibing? then m+=1 end
    self.vibes+=m*self.furbaby.count_rare_dna
    self.save
  end

  def transfer(t)
    t.vibes+=self.vibes
    t.save
    self.vibes=0
    self.save
  end

  def split_with(t)
    v=self.vibes
    t.vibes=(v.to_f/2.0).ceil
    t.save
    self.vibes=(v.to_f/2.0).floor
    self.save
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
