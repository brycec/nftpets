class AddToToMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :to, :string
  end
end
