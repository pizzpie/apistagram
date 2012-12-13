class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :website, :string
    add_column :users, :bio, :text
  end
end
