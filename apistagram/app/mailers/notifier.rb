class Notifier < ActionMailer::Base
  default from: AppConfiguration['admin_email']

  def contact(contact, type)
    recipients    = [AppConfiguration['admin_email']]
    @name         = contact['name']
    @email        = contact['email']
    @company      = contact['company']
    @comments     = contact['comments']
    mail(:subject => "#{type} Received", :to => recipients)
  end
end
