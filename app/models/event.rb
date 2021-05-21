class Event < ApplicationRecord
  belongs_to :user
  after_create do
    if self.key == 'pet' and
      !Event.where('user_id = 1 AND created_at > ?', Time.now-10.seconds).first
      Event.create(user_id:1, key:'total_sample',
        value: 3.times.map{|i|
          Token.symbol_total(i)
        }.join(","))
    end
  end
end
