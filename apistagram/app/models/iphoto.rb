class Iphoto < ActiveRecord::Base

  acts_as_commentable
  
  attr_accessible :i_id, :status, :tag_id, :url, :username, :partner_id

  validates :url, :username,
            :presence => true

  validates :i_id,
            :presence => true,
            :uniqueness => true

  # default_scope where(:partner_id => 2)
  belongs_to :partner
  scope :pending, where("status is null")
  scope :selected, where("status is true")
  scope :listed, where("status is null or status is true")
  scope :rejected, where("status is not null and status is false")

  self.per_page = 18

  has_many :favorites, :dependent => :destroy
  has_many :fans, :through => :favorites, :source => :user

  scope :by_username, lambda{ |username| where(username: username) unless username.nil? }
  scope :by_partner_id, lambda{ |partner_id| where(partner_id: partner_id) unless partner_id.nil? }

  before_save :create_or_update_public_id

  def create_or_update_public_id
    unless public_id
      pub_id = SecureRandom.hex(3)
      if check_public_id(pub_id)
        pub_id = SecureRandom.hex(3)
        check_public_id(pub_id)
      else
        self.public_id = pub_id
      end
    end
  end

  def check_public_id(pub_id)
    Iphoto.find_by_public_id(pub_id)
  end

  def share_link
    Thread.current[:site_configuration]['host'] + "/#{public_id}"
  end

  def self.update_all_with_callbacks(photo_ids, all_photo_ids)
    photo_ids     ||= []
    all_photo_ids = all_photo_ids.split(" ")
    
    approved_count = 0
    removed_count  = 0

    all_photo_ids.each do |pic|
      photo = self.find_by_id(pic.to_i)
        
      if photo
        if photo_ids.include?(pic)
          removed_count = removed_count + 1 if photo.update_attribute(:status, false)
        else
          approved_count = approved_count + 1 if photo.update_attribute(:status, true)
        end
      end
    end
    
    [approved_count, removed_count]
  end

  def user
    User.find_by_name(username)
  end

  def self.get_duration(sort_order)
    if sort_order == "month"
      return 1.month.ago(Time.now)
    elsif sort_order == "week"
      return 1.week.ago(Time.now)
    else
      return 1.day.ago(Time.now)
    end
  end

  def self.get_hottest_pics(dtime, counter = 1)
    if self.count == 0
      return []
    else
      duration = Thread.current[:site_configuration]['hot_duration_in_hours'] * counter
      time = duration.hours.ago(dtime)
      arr = self.joins(:favorites).where('favorites.created_at >= ? and iphotos.id = favorites.iphoto_id', time).limit(9)
      if !arr || arr.count < 9
        counter = counter + 1
        get_hottest_pics(time, counter)
      else
        arr
      end
    end
  end

  def self.fetch_index_listing(cpartner_id, category = nil, sort_order = nil)
    # hot_arr = Favorite.where("created_at >= ?", Thread.current[:site_configuration]['hot_duration_in_hours'].hours.ago(Time.now)).group(:iphoto_id).count.keys
    # pop_arr = Favorite.where("created_at >= ?", Thread.current[:site_configuration]['popular_duration_in_days'].day.ago(Date.today)).group(:iphoto_id).count.keys

    # hot_arr = Favorite.order('created_at DESC').group(:iphoto_id).count.keys
    # pop_arr = Favorite.order('created_at DESC').group(:iphoto_id).count.keys    
    hot_arr = Iphoto.by_partner_id(cpartner_id).get_hottest_pics(Time.now)
    pop_arr = Iphoto.joins(:favorites).where('iphotos.partner_id = ? and favorites.created_at >= ? and iphotos.id = favorites.iphoto_id', cpartner_id, Thread.current[:site_configuration]['popular_duration_in_days'].day.ago(Date.today))
    # pop_arr = hot_arr

    if category
      if category == "hot"
        if hot_arr.empty?
          return []
        else
          return hot_arr.group(:iphoto_id).order('count(favorites.id) desc') #Iphoto.listed.where(:id => hot_arr)
        end
      elsif category == "most_popular"
        if sort_order and ["month", "week", "today"].include?(sort_order)
          # pop_arr = Favorite.where('created_at >= ?', get_duration(sort_order)).group(:iphoto_id).order('COUNT(id) desc')
          return pop_arr.where('favorites.created_at >= ?', get_duration(sort_order)).group(:iphoto_id).order('count(favorites.id) desc')
          # Iphoto.listed.where(:id => pop_arr)
        else
          return pop_arr.group(:iphoto_id).order('count(favorites.id) desc')#Iphoto.listed.where(:id => pop_arr)
        end        
      else
        return self.by_partner_id(cpartner_id).order('created_at desc')
      end
    else
      newest  = self.by_partner_id(cpartner_id).order('created_at desc').limit(6)

      # hottest = Iphoto.listed.where(:id => [hot_arr]).limit(9)
      hottest = hot_arr.empty? ? [] : hot_arr.group(:iphoto_id).order('count(favorites.id) desc')
      # hot_arr.each do |i|
      #   hottest << Iphoto.listed.find_by_id(i)
      #   break if hottest.count == 9
      # end

      # unless hot_arr.count >=9
      #   remaining = 9 - hot_arr.count
      #   add_more_photos(remaining)
      # end

      popular = []
      # popular = Iphoto.listed.where(:id => [pop_arr]).limit(6)
      popular = pop_arr? ? [] : pop_arr.group(:iphoto_id).order('count(favorites.id) desc').limit(6)
      # pop_arr.each do |i|
      #   popular << Iphoto.listed.find_by_id(i)
      #   break if popular.count == 6
      # end

      # unless pop_arr.count >=6
      #   remaining = 6 - pop_arr.count
      #   add_more_photos(remaining)
      # end

      return [newest, hottest, popular]
    end
  end

  # def add_more_photos(remaining)
    
  # end
end
