class AddTokenRefToMessages < ActiveRecord::Migration[6.1]
  def change
    add_reference :messages, :token, null: true, foreign_key: true
  end
end
