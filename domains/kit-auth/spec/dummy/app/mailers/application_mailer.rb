class ::ApplicationMailer < ::ActionMailer::Base

  def default_email
    Kit::Router::Adapters::MailerRails.rails_default_email(context: self)
  end

end
