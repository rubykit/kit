module Kit::Auth::Actions::Users::UpdatePassword

  def self.call(user:, password:, password_confirmation:)
    _status, ctx = Kit::Organizer.call({
      ctx:  {
        password:              password,
        password_confirmation: password_confirmation,
      },
      list: [
        self.method(:validate_password),
        Kit::Auth::Services::Password.method(:generate_hashed_secret),
        self.method(:update_user),
        self.method(:fire_user_password_updated_event),
      ],
    })

    if ctx[:errors]
      [:error, user: nil, errors: ctx[:errors]]
    else
      [:ok, user: ctx[:user]]
    end
  end

  def self.validate_password(password:, password_confirmation:)
    res = Kit::Auth::Services::Contracts::Password.new.call({
      password:              password,
      password_confirmation: password_confirmation,
    })

    if res.errors.count > 0
      [:error, Kit::Error.from_contract(res)]
    else
      [:ok]
    end
  end

  def self.update_user(user:, hashed_secret:)

    user = user.update!({
      hashed_secret: hashed_secret,
    })

    if user.persisted?
      [:ok, user: user]
    else
      [:error, user: nil, errors: user.errors]
    end
  end

  def self.fire_user_password_updated_event(user:)
    # TODO: fire event!

    [:ok]
  end

end
