require 'iinstagram'
class User < ActiveRecord::Base
  # mount_uploader :image, ImageUploader
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
  has_many :favorite_photos, :through => :favorites, :source => :iphoto,
           :order => 'created_at desc'
  has_many :comments
  has_many :commented_photos, :through => :comments, :source => :iphoto,
                      :conditions => "comments.commentable_type = 'Iphoto'",
                      :order => 'created_at desc'

  before_create :set_admin_if_required                      

  def set_admin_if_required
    self.is_admin = true if self.name == 'apistagram' 
  end

  def self.authenticate(auth, cpartner)
    user        = self.where(:provider => auth['provider'], :uid => auth['uid']).first
    user        ||= self.new(:provider => auth['provider'], :uid => auth['uid'])
    user.token  = auth['credentials']['token']
    if auth['info']
      user.image      = auth['info']["image"]     || "" unless auth['info']["image"] == "http://images.instagram.com/profiles/anonymousUser.jpg"
      user.name       = auth['info']['nickname']  || ""
      user.full_name  = auth['info']['name']      || ""
      user.email      = auth['info']['email']     || ""
    end

    user.save!
    user
  end

  def get_grams
    cakesta_tags = Tag.where(:partner_id => 1)
    tattsta_tags = Tag.where(:partner_id => 2)

    cakesta_tags.each do |tag|
      50.times do |i|
        self.delay.fetch_grams(tag, tag.partner_id)
      end
    end

    tattsta_tags.each do |tag|
      50.times do |i|
        self.delay.fetch_grams_for_tattsta(tag, tag.partner_id)
      end
    end    
  end

  def fetch_grams(tag, cpartner_id)
    tatsagram = IInstagram.new(:token => self.token, :tag => tag.name, :max_id => tag.max_photo_id, :partner_id => cpartner_id, :client_key => AppConfiguration['cakesta']['instagram_client_id'])
    tatsagram.get_grams
  end

  def fetch_grams_for_tattsta(tag, cpartner_id)
    tatsagram = IInstagram.new(:token => self.token, :tag => tag.name, :max_id => tag.max_photo_id, :partner_id => cpartner_id, :client_key => AppConfiguration['tattsta']['instagram_client_id'])
    tatsagram.get_grams    
  end

  def likes?(photo)
    self.favorites.find_by_iphoto_id(photo.id)
  end

  def image_url
    self.image? ? self.image : "fallback/thumb_default.png"
  end
end
