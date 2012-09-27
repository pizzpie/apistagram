class Setup < ActiveRecord::Base
  attr_accessible :key_name, :key_val

  def self.max_photo_id
    max_photo = Setup.find_or_create_by_key_name("Max Photo Id")
    max_photo.key_val
  end

  def self.set_max_photo_id(photo_id)
    max_photo = Setup.find_or_create_by_key_name("Max Photo Id")
    max_photo.update_attribute(:key_val, photo_id)
  end
end
