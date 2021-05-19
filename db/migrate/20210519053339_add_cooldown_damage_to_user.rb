class AddCooldownDamageToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :cooldown, :datetime
    add_column :users, :damage, :integer
  end
end
