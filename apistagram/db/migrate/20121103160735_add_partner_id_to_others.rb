class AddPartnerIdToOthers < ActiveRecord::Migration
  def change
    add_column :users, :partner_id, :integer, :default => 1
    add_column :tags, :partner_id, :integer, :default => 1
    add_column :iphotos, :partner_id, :integer, :default => 1
    add_column :favorites, :partner_id, :integer, :default => 1
    add_column :comments, :partner_id, :integer, :default => 1

    add_index :users,     :partner_id
    add_index :tags,      :partner_id
    add_index :iphotos,   :partner_id
  end
end
