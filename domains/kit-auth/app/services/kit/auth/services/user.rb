require 'bcrypt'

# Service that contains varous user related logic.
module Kit::Auth::Services::User

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

end
