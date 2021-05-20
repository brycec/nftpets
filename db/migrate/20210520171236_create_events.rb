class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.references :user
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
