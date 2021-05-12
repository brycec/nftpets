class AddSubjectToMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :subject, :string
  end
end
