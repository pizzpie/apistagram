class Partner < ActiveRecord::Base
  attr_accessible :name

  validates :name,
            :presence => true,
            :uniqueness => true

  has_many :comments
  has_many :iphotos
  has_many :users
  has_many :favorites
  has_many :tags
end
