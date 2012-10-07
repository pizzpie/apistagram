class AddPublicUrlToIphotos < ActiveRecord::Migration
  def change
    add_column :iphotos, :public_id, :string
  end
end
