class CreateMessagesJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :users, :messages do |t|
      
    end
  end
end
