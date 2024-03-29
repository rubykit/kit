module Kit::Auth::Actions::Users::CreateWithPassword

  def self.call(email:, password:)
    status, ctx = Kit::Organizer.call(
      list: [
        #Kit::Auth::Services::Contracts::EmailSignup.method(:validate),
        #Kit::Auth::Services::Contracts::Password.method(:validate),
        Kit::Auth::Services::Password.method(:generate_hashed_secret),
        self.method(:persist_user),
        self.method(:send_event),
      ],
      ctx:  {
        email:    email,
        password: password,
      },
    )

    if status == :error
      [:error, errors: ctx[:errors]]
    else
      [:ok, user: ctx[:user]]
    end
  end

  def self.persist_user(email:, hashed_secret:)
    begin
      user = Kit::Auth::Models::Write::User.create(
        email:         email,
        hashed_secret: hashed_secret,
      )
    rescue ActiveRecord::RecordNotUnique
      return [:error, user: nil, errors: [{ attribute: :email, detail: 'This $attribute is already taken.' }]]
    end

    if user.persisted?
      [:ok, user: user]
    else
      [:error, user: nil, errors: user.errors]
    end
  end

  def self.send_event(user:)
    Kit::Router::Services::Adapters.cast(
      route_id:     'event|users|auth|sign_up',
      adapter_name: :async,
      params:       {
        user_id:        user.id,
        sign_up_method: :email,
      },
    )

    [:ok]
  end

end
