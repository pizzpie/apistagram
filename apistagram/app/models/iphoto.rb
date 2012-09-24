class Iphoto < ActiveRecord::Base
  attr_accessible :i_id, :status, :tag_id, :url, :username

  validates :i_id, :url, :username,
            :presence => true

  validates :i_id,
            :uniqueness => true
end
