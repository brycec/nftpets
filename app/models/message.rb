class Message < ApplicationRecord

  after_create do
    user=User.where(name: to).first
    if user
      user.messages<< self
    end
    if self.to=="The Chat"
      Event.create(user_id: current_user_id, key: "chat", value: self.id)
    end
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
  Event.create(user_id: u.id, key: "welcome", value: @token.id)
end
