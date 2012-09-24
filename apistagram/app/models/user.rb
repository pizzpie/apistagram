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

  def self.authenticate(auth)
    user    = self.where(:provider => auth['provider'], :uid => auth['uid']).first
    user  ||= self.new(:provider => auth['provider'], :uid => auth['uid'])
    user.token    = auth['token']
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
      tatsagram = IInstagram.new(:token => self.token, :tag => tag.name)
      photos    = tatsagram.get_grams
      photos.each do |ipic|
        Iphoto.create!(ipic) rescue nil
      end
    end
  end
end
