module Kit::Auth::Actions::Users::CreateWithPassword

  #Contract Hash => [Symbol, KeywordArgs[user: Any, errors: Any]]
  def self.call(email:, password:, password_confirmation:, email_confirmation: nil)
    _status, ctx = Kit::Organizer.call({
      ctx:  {
        email:                 email,
        email_confirmation:    email_confirmation,
        password:              password,
        password_confirmation: password_confirmation,
      },
      list: [
        Kit::Auth::Services::Contracts::EmailSignup.method(:validate),
        Kit::Auth::Services::Contracts::Password.method(:validate),
        Kit::Auth::Services::Password.method(:generate_hashed_secret),
        self.method(:persist_user),
        self.method(:fire_user_created_event),
      ],
    })

    if ctx[:errors]
      [:error, user: nil, errors: ctx[:errors]]
    else
      [:ok, user: ctx[:user]]
    end
  end

  def self.persist_user(email:, hashed_secret:)
    begin
      user = Kit::Auth::Models::Write::User.create({
        email:         email,
        hashed_secret: hashed_secret,
      })
    rescue ActiveRecord::RecordNotUnique
      return [:error, user: nil, errors: [{ attribute: :email, detail: '$attribute is alreadky taken.' }]]
    end

    if user.persisted?
      [:ok, user: user]
    else
      [:error, user: nil, errors: user.errors]
    end
  end

  def self.fire_user_created_event(user:)
    # TODO: fire event!

    [:ok]
  end

end
