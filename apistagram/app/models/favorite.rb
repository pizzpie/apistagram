class Favorite < ActiveRecord::Base
  attr_accessible :iphoto_id, :user_id, :partner_id

  belongs_to :user
  belongs_to :iphoto
  belongs_to :partner

  scope :by_partner_id, lambda{ |partner_id| where(partner_id: partner_id) unless partner_id.nil? }
end
