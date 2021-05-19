class CreateFurbabyJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :furbabies, :parents
  end
end
