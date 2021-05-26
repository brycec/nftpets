class User < ApplicationRecord
  has_many :tokens
  has_many :furbabies, through: :tokens
  has_and_belongs_to_many :messages
  validates :name, presence: true
  validates :name, format: { with: /\A[_a-zA-Z0-9]+\z/,
    message: "can only be: _, a-z, A-Z, or 0-9" }
  validates :name, uniqueness: true
  has_secure_password
  scope :old_anon, ->{
    where('name ~ ?', '^anon\d+$')
      .where('created_at < ?', Time.now-1.day)
      .order(created_at: 'desc')
  }
  before_destroy do
    self.tokens.each do |t| t.destroy end
  end

  def networth
    self.tokens.inject(0) do |a,b| a+b.vibes end
  end

  def holding(s)
    self.tokens.symbol_id(s).inject(0){|a,b|
        a+b.vibes
      }
  end

  def holdings
    Token.trade_data.map do |m|
      [m[:emoji],self.holding(m[:sym])]
    end
  end

  def empty_token
    self.tokens.filter {|t|!t.furbaby}.first
  end

  def tokens_map
    self.tokens.map { |t|
      [t.dname,t.vibes?.to_i,t.id]
    }
  end

  def egg
    self.tokens.filter {|t|t.furbaby and t.furbaby.egg?}.first
  end

  def egg?
    !!self.egg
  end

  def dead?
    self.damage? >= 3
  end

  def cooldown?
    if !self.cooldown or self.cooldown < DateTime.now.utc
      self.cooldown = DateTime.now.utc
    end
    self.cooldown.utc
  end

  def damage?
    self.damage or 0
  end

  def took_damage?
    self.cooldown==DateTime.new.utc
  end

  MAX_HEAT = 9
  def heat
    self.cooldown = self.cooldown? + 3
    if self.cooldown > DateTime.now.utc + MAX_HEAT
      self.damage=self.damage?+1
      self.cooldown=DateTime.new.utc
    end
    self.save
  end

  def how_hot # , gatdam, call the police and the fireman
    (self.cooldown? - DateTime.now.utc) / MAX_HEAT
  end
end
