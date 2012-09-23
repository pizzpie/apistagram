class CreateIphotos < ActiveRecord::Migration
  def change
    create_table :iphotos do |t|
      t.string :i_id
      t.string :url
      t.string :username
      t.integer :tag_id
      t.boolean :status

      t.timestamps
    end
  end
end
