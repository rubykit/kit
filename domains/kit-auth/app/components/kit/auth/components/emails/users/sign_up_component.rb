class Kit::Auth::Components::Emails::Users::SignUpComponent < Kit::Auth::Components::Emails::EmailComponent

  attr_reader :user_email

  def initialize(user_email:, **)
    super

    @user_email = user_email.attributes.to_h
  end

  def liquid_assigns_list
    [:user_email]
  end

end
