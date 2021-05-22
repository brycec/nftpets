class ChangeTokenVibesToBigInt < ActiveRecord::Migration[6.1]
  def change
    change_column :tokens, :vibes, :bigint
  end
end
