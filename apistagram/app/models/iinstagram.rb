module IInstagram
  class IInstagram

    attr_accessor :tag, :token, :response, :data, :photos, :max_id
  
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
        10.times do |i|
          if max_id
            self.response = Instagram.tag_recent_media(tag, :max_id => max_id)
          else
            self.response = Instagram.tag_recent_media(tag)
          end
          self.data     = self.response.data
          if self.data.count > 0
            self.data.each do |media|
              self.photos   << {
                                "i_id" => media.id,
                                "url"  => media.images.standard_resolution.url,
                                "username" => media.user.username
                               }
            end
            max_id = self.data.last.id
          end
        end
        self.photos
      rescue Exception => e
        raise e
      end
    end
  end
end