class Tag < ActiveRecord::Base
  attr_accessible :name, :max_photo_id

  validates :name,
            :uniqueness => true
end
