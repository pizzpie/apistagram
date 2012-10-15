class Notifier < ActionMailer::Base
  default from: "team@tastagram.com"

  def contact(contact, type)
    recipients    = ["admin@tastagram.com"]
    @name         = contact['name']
    @email        = contact['email']
    @company      = contact['company']
    @comments     = contact['comments']
    mail(:subject => "#{type} Received", :to => recipients)
  end
end
