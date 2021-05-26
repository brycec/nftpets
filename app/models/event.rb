class Event < ApplicationRecord
  belongs_to :user
  scope :last_sample, ->{
    where(user_id: 1).where(key: 'total_sample').order(created_at: 'desc').first
  }
  scope :old, ->{
    where('created_at < ?', Time.now-1.day).order(created_at: 'desc').drop 100
  }
  scope :last_squeeze, ->{
    where(user_id: 1).where(key: 'squeeze').order(created_at: 'desc').first
  }
  scope :last_squeeze_sample_0, ->{
    where(user_id: 1).where(key: 'squeeze_sample_0').order(created_at: 'desc').first
  }
  scope :last_squeeze_sample_1, ->{
    where(user_id: 1).where(key: 'squeeze_sample_1').order(created_at: 'desc').first
  }
  before_create do
    if self.key.in? ['pet', 'inject', 'egg', 'hatch', 'fission',  'dump'] and
      !Event.where(user_id: 1).where('created_at > ?', Time.now-15.seconds).first
      Event.squeeze_check
      Event.create(user_id:1, key:'total_sample',
        value: 3.times.map{|i|
          Token.symbol_total!(i)
        }.join(","))
    end
  end

  SQUEEZE_T=1.hour
  SQUEEZE_ON=[Furbaby::EMOJI_COORDS[:fire][0],
    Furbaby::EMOJI_COORDS[:rock][0],
    Furbaby::EMOJI_COORDS[:telepathic][0]]
  def self.squeeze_on
    last_squeeze.present? ? last_squeeze.value.split(',')[2].to_i : SQUEEZE_ON.first
  end
  def self.start_squeeze
    t = Token.trade_sorted
    last_on = squeeze_on
    on = SQUEEZE_ON[(SQUEEZE_ON.index(last_on)+1)%3]
    ns = create(user_id:1, key:'squeeze', value: [t[1][:sym],t[2][:sym],on].join(','))
    ns
  end
  def self.squeeze_check
    if !last_squeeze.present?
      start_squeeze
    elsif last_squeeze.created_at < Time.now-SQUEEZE_T # do squeeze,
      Thread.new do
        Token.do_squeeze!
        start_squeeze
      end
    else
      l=last_squeeze.value.split(',').map(&:to_i)
      Event.create(user_id:1, key:'squeeze_sample_0',
        value: Token.squeezes_by_index(l[0]).join(','))
      Event.create(user_id:1, key:'squeeze_sample_1',
        value: Token.squeezes_by_index(l[1]).join(','))
    end
  end
  def self.squeeze_time
    Time.at((last_squeeze.created_at-Time.now).to_f).utc+SQUEEZE_T
  end
end
