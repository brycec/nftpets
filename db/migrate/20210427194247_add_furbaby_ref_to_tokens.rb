class AddFurbabyRefToTokens < ActiveRecord::Migration[6.1]
  def change
    add_reference :tokens, :furbaby, null: true, foreign_key: true
  end
end
