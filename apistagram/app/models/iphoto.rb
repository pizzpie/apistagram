class Iphoto < ActiveRecord::Base
  attr_accessible :i_id, :status, :tag_id, :url, :username

  validates :i_id, :url, :username,
            :presence => true

  validates :i_id,
            :uniqueness => true

  scope :pending, where("status is false")
  scope :selected, where("status is true")

  self.per_page = 18

  def self.update_all_with_callbacks(photo_ids, all_photo_ids)
    photo_ids     ||= []
    all_photo_ids = all_photo_ids.split(" ")
    
    approved_count = 0
    removed_count  = 0

    all_photo_ids.each do |pic|
      photo = self.find_by_id(pic.to_i)
        
      if photo
        if photo_ids.include?(pic)
          approved_count = approved_count + 1 if photo.update_attribute(:status, true)
        else
          removed_count = removed_count + 1 if photo.destroy
        end
      end
    end
    
    [approved_count, removed_count]
  end
end
