# Service that contains varous user related logic.
module Kit::Auth::Services::UserEmail

  def self.find_by_email(email:)
    if email.blank?
      return [:error, detail: "Invalid email `#{ email }`"]
    end

    user_model = Kit::Auth::Models::Read::User.find_by(email: email)
    if !user_model
      return [:error, detail: "Could not find user with email `#{ email }`"]
    end

    [:ok, user: user_model]
  end

  def self.confirm(user_email:)
    if !user_email.confirmed?
      user_email.update(email_confirmed_at: DateTime.now)
      user_email.reload
    end

    [:ok, user_email: user_email]
  end

  def self.find_by_email(email:)
    if email.blank?
      return [:error, detail: "Invalid email `#{ email }`"]
    end

    user_email_model = Kit::Auth::Models::Read::UserEmail.find_by(email: email)
    if !user_email_model
      return [:error, detail: "Could not find user with email `#{ email }`"]
    end

    [:ok, user_email: user_email_model]
  end

end
