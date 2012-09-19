class User < ActiveRecord::Base
  attr_accessible :provider, :token, :uid

  validates :uid, :provider,
            :presence => true

  validates :uid,
            :uniqueness => true

	def self.create_with_omniauth(auth)
	  create! do |user|
	    user.provider = auth['provider']
	    user.uid = auth['uid']
	    if auth['info']
	      user.email = auth['info']['email'] || ""
	    end
	  end
	end

  def self.authenticate(auth)
    self.where(:provider => auth['provider'], :uid => auth['uid']).first || self.create_with_omniauth(auth)
  end
end
