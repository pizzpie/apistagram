namespace :db do
  desc "Fill database with instagram photos"
  task :fetch_instagrams => :environment do
    uname = AppConfiguration['admin_username']
    user  = User.find_by_name(uname)
    if user
      if user.get_grams
        puts "Fetched photos successfully"
      else
        puts "Sorry there were some issues"
      end
    else
      puts "No administrator found by name #{uname}"
    end
  end

  task :reset_public_ids => :environment do
    Iphoto.all.each do |iphoto|
      pub_id = SecureRandom.hex(3)
      iphoto.update_attribute(:public_id, pub_id)
    end
  end
end