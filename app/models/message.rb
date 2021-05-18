class Message < ApplicationRecord

  after_create do
    user=User.where(name: to).first
    if user
      user.messages<< self
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
end
