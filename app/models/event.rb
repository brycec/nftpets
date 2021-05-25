class Event < ApplicationRecord
  belongs_to :user
  scope :last_sample, ->{
    where(user_id: 1).order(created_at: 'desc').first
  }
  scope :old, ->{
    where('created_at < ?', Time.now-1.day).order(created_at: 'desc').drop 100
  }
  after_create do
    if self.key.in? ['pet', 'inject', 'egg', 'hatch', 'fission',  'dump'] and
      !Event.where('user_id = 1 AND created_at > ?', Time.now-15.seconds).first
      Event.create(user_id:1, key:'total_sample',
        value: 3.times.map{|i|
          Token.symbol_total!(i)
        }.join(","))
    end
  end
end
