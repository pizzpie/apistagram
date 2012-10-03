class AddMaxPhotoIdToTags < ActiveRecord::Migration
  def change
    add_column :tags, :max_photo_id, :string
  end
end
