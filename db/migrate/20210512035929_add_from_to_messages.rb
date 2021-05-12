class AddFromToMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :from, :string
  end
end
