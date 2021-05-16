class AddNameToFurbabies < ActiveRecord::Migration[6.1]
  def change
    add_column :furbabies, :name, :string
  end
end
