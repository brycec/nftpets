class AddDnaIndexToFurbabies < ActiveRecord::Migration[6.1]
  def change
    add_index :furbabies, :dna
  end
end
