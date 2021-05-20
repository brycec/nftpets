class RedoIndexes < ActiveRecord::Migration[6.1]
  def change
    add_index :events, :key
    add_index :messages_users, :user_id
    add_index :messages, :to
    remove_index :messages, :token_id
    add_index :furbabies_parents, :furbaby_id
    add_index :furbabies_parents, :parent_id
  end
end
