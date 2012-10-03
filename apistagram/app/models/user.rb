require 'iinstagram'
class User < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  include IInstagram

  attr_accessible :uid,
                  :token,
                  :image, 
                  :provider, 
                  :remote_image_url

  validates :uid, :provider,
            :presence => true

  validates :uid,
            :uniqueness => true

  has_many :favorites
  has_many :favorite_photos, :through => :favorites, :source => :iphoto
  has_many :comments

  def self.authenticate(auth)
    user        = self.where(:provider => auth['provider'], :uid => auth['uid']).first
    user        ||= self.new(:provider => auth['provider'], :uid => auth['uid'])
    user.token  = auth['credentials']['token']
    if auth['info']
      user.remote_image_url   = auth['info']["image"]     || ""
      user.name               = auth['info']['nickname']  || ""
      user.email              = auth['info']['email']     || ""
    end

    user.save!
    user
  end

  def get_grams
    Tag.all.each do |tag|
      self.delay.fetch_grams(tag)
    end
  end

  def fetch_grams(tag)
    tatsagram = IInstagram.new(:token => self.token, :tag => tag.name, :max_id => Setup.max_photo_id)
    tatsagram.get_grams
  end

  def likes?(photo)
    self.favorites.find_by_iphoto_id(photo.id)
  end
end
