class ::ApplicationMailer < ::ActionMailer::Base

  default from: 'no-reply@rubykit.com'

  def default_email
    mail(**params[:params]) do |format|
      format.html { params[:html] }
    end
  end

end
