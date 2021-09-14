class Kit::Auth::Components::Emails::Users::SignUpComponent < Kit::Auth::Components::Emails::EmailComponent

  attr_reader :user

  def initialize(user:, **)
    super

    @user = user.attributes.to_h
  end

  def liquid_assigns_list
    [:user]
  end

end
