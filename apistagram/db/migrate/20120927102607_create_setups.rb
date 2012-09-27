class CreateSetups < ActiveRecord::Migration
  def change
    create_table :setups do |t|
      t.string :key_name
      t.string :key_val

      t.timestamps
    end
  end
end
