class Favorite < ActiveRecord::Base
  attr_accessible :iphoto_id, :user_id

  belongs_to :user
  belongs_to :iphoto
end
