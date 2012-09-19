class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid
      t.string :provider
      t.string :token
      t.string :email

      t.timestamps
    end
  end
end
