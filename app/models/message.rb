class Message < ApplicationRecord
  belongs_to :token, required: false
  after_create do
    user=User.where(name: to).first
    if user
      user.messages<< self
    end
  end

  def vod
    if self.body and self.body.slice(0,5)=="_vod_"
      vod=/\A_vod_([0-9]+)/.match(self.body)[1].to_i
      if vod > 0
        return vod
      end
    end
    false
  end
end

def Message.new_welcome(u)
  token = Token.create({user_id: 1})
  Message.create({
    to: u.name,
    from: 'The Commissioner',
    subject: 'Your First Assignment',
    token_id: token.id,
    body: %{On behalf of the S.P.N.F., thank you. With volunteers operating our pet tokens, adopted Furbabies are protected from the Plutonian poachers seeking to harvest their extremely valuable fur.

      Attached is a new token as a gift. Use it to adopt a Furbaby and begin investing.
      }
    })
  Event.create(user_id: u.id, key: "welcome", value: token.id)
end
