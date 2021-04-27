class CreateFurbabies < ActiveRecord::Migration[6.1]
  def change
    create_table :furbabies do |t|
      t.string :dna

      t.timestamps
    end
  end
end
