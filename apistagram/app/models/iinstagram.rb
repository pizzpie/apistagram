module IInstagram
  class IInstagram

    attr_accessor :tag, :token, :response, :data, :photos, :max_photo_id
  
    def initialize(args)
      if args
        self.token        = args[:token]
        self.tag          = args[:tag]
        self.max_photo_id = args[:max_photo_id]
        self.photos       = []
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
        1.times do |i|
          unless max_photo_id.blank?
            self.response = Instagram.tag_recent_media(tag, :max_id => max_photo_id)
          else
            self.response = Instagram.tag_recent_media(tag)
          end
          self.data     = self.response.data
          if self.data.count > 0
            self.data.each do |media|
              self.photos   << {
                                  :i_id => media.id,
                                  :url  => media.images.standard_resolution.url,
                                  :username => media.user.username
                               }
            end
            self.max_photo_id = self.data.last.id
          end
        end
        self.photos.each do |ipic|
          begin
            Iphoto.create!(ipic)
          rescue Exception => e
            puts e.message
            puts e
          end
        end
        begin
          max_photo = Setup.find_or_create_by_key_name("max_photo_id")
          max_photo.update_attributes(:key_val => max_photo_id)
        rescue Exception => e
          puts e.message
          puts e.debug
        end
        # Setup.set_max_photo_id(max_photo_id)
      rescue Exception => e
        raise e
      end
    end
  end
end