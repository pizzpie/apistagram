class Notifier < ActionMailer::Base
  default from: 'craig@craigmorrison.com'

  def contact(contact, type)
    recipients    = ['craig@craigmorrison.com']
    @name         = contact['name']
    @email        = contact['email']
    @company      = contact['company']
    @comments     = contact['comments']
    @photo_url    = contact['photo_url']
    @reason       = contact['reason']
    mail(:subject => "#{type} Received", :to => recipients)
  end
end
