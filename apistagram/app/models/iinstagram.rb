module IInstagram
  class IInstagram

    attr_accessor :tag, :token, :response, :data, :photos
  
    def initialize(args)
      if args
        self.token = args[:token]
        self.tag   = args[:tag]
        self.photos = []
      end
      authenticate
    end
  
    def authenticate
      Instagram.configure do |config|
        config.client_id = AppConfiguration['instagram_client_id']
        config.access_token = token
      end
    end
  
    def get_grams
      begin
        self.response = Instagram.tag_recent_media(tag)
        self.data     = self.response.data

        self.data.each do |media|
          self.photos   << {
                            "i_id" => media.id,
                            "url"  => media.images.standard_resolution.url,
                            "username" => media.user.username
                           }
        end
        self.photos
      rescue Exception => e
        raise e
      end
    end
  end
end