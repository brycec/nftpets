class AddBodyToMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :body, :string
  end
end
