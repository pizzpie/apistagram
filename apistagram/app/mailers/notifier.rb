class Notifier < ActionMailer::Base
  default from: Thread.current[:site_configuration]['admin_email']

  def contact(contact, type)
    recipients    = [Thread.current[:site_configuration]['admin_email']]
    @name         = contact['name']
    @email        = contact['email']
    @company      = contact['company']
    @comments     = contact['comments']
    @photo_url    = contact['photo_url']
    @reason       = contact['reason']
    mail(:subject => "#{type} Received", :to => recipients)
  end
end
