# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


partners = Partner.create([{name: 'cakesta'}, {name: 'tatstagram'}])

# Partner.all.each do |partner|
#   AppConfiguration[partner.name]['tags'].each do |tag|
#     tag = partner.tags.create(:name => tag)
#   end
# end

Partner.all.each do |partner|
  AppConfiguration[partner.name]['tags'].each do |tag|
    tag = partner.tags.create(:name => tag)
  end
end

user = User.first

if user
  user.update_attribute(:is_admin, true)
end