class Tag < ActiveRecord::Base
  attr_accessible :name, :max_photo_id, :partner_id

  validates :name,
            :uniqueness => true

  belongs_to :partner
end
