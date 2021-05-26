class Token < ApplicationRecord
  belongs_to :furbaby, required: false
  belongs_to :user
  validates :vibes, numericality: { only_integer: true }
  scope :active, -> {
    joins(:furbaby).merge(Furbaby.not_egg)
  }
  scope :w_syms, ->(a) {
    all.active.merge(Furbaby.with_syms(a))
  }
  scope :totaled, -> {
    all.inject(0) {|a,t| a+t.vibes }
  }

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

  def dname
    self.vibes?.to_s+'N '+(self.furbaby ? self.furbaby.dname+' '+self.furbaby.rarity : 'unoccupied')
  end

  def vibing?
    s=self.furbaby.trade_s
    Token.trade_sorted.first[:sym] == s
  end

  def pet
    m=1 #multiplier
    if self.vibing? then
      m+=1
    end
    self.vibes+=m*self.furbaby.count_rare_dna
    self.save
  end

  def transfer(t)
    if self != t
      t.vibes+=self.vibes
      t.save
      self.vibes=0
      self.save
    end
  end

  def split_with(t)
    if self != t
      v=(self.vibes.to_f)/2.0
      t.vibes+=v.ceil
      t.save
      self.vibes=v.floor
      self.save
    end
  end

  def self.symbol_id(s)
    active.w_syms([[Furbaby::NUM_GENES-1,s]])
  end
  def self.symbol_total!(s) # skip cache
    symbol_id(s).totaled
  end
  def self.symbol_total(s)
    e = Event.last_sample # caching through events
    if e.present?
      e.value.split(',')[s].to_i
    else
      symbol_total!(s)
    end
  end
  def self.squeezes_by_index(s)
    samp = Event.last_squeeze_sample_0
    sq = Event.last_squeeze
    if samp.present?
      sq = sq.value.split(',').map(&:to_i)
      if s==sq[0]
        samp
      elsif s==sq[1]
        Event.last_squeeze_sample_1
      end
    end
    3.times.map { |i|
      w_syms([[Event.squeeze_on,i],[Furbaby::NUM_GENES-1,s]]).totaled
    }
  end
  def self.squeeze?(s)
    sq = Event.last_squeeze
    if sq.present?
      sq = sq.value.split(',').map(&:to_i)
      if sq.take(2).include?(s)
        squeezes_by_index(s).each_with_index.inject([]) {|a,(e,i)|
          a.push [i,e]}.sort_by(&:second)
      end
    else
      false
    end
  end
  def self.beats?(a,b)
    a-1==b or (a==0 and b==2)
  end
  def self.do_squeeze!
    d = squeeze_data
    if  d[0][:squeeze].last[0]==d[1][:squeeze].last[0]
      # tie break goes to max count
      winner = d.max_by{|e|e[:squeeze].last[1]}
      loser = d.without(winner).first
    elsif Token.beats?(d[0][:squeeze].last[0],d[1][:squeeze].last[0])
      winner = d[0]
      loser = d[1]
    else
      winner = d[1]
      loser = d[0]
    end
    sq = Event.last_squeeze
    pool = Token.symbol_id(loser[:sym]).inject(0) {|a,e|
      a+=(e.vibes/2.0).floor
      e.vibes=(e.vibes/2.0).ceil
      e.save
      a
    }
    wins = Token.symbol_id(winner[:sym])
    wins.each {|e|
      e.vibes+=(pool.to_f/wins.length).ceil
      e.save
    }
  end
  def self.trade_data
    Furbaby::TRADE_SYMS.entries.each_with_index.inject([]) do |a,(e,i)|
      a.push({word: e[0], emoji: e[1], total: symbol_total(i), sym: i })
    end
  end
  def self.squeeze_data
    self.trade_data.map { |e|
      e[:squeeze] = squeeze?(e[:sym])
      e
    }.filter{|e|e[:squeeze]}
  end
  def self.trade_sorted
    self.trade_data.sort{|a,b|a[:total]<=>b[:total]}
  end
end
