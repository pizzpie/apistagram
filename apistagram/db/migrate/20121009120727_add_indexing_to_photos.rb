class AddIndexingToPhotos < ActiveRecord::Migration
  def change
    add_index :iphotos, :i_id, :unique => true
    add_index :iphotos, :username
    add_index :users, :name, :unique => true
  end
end
