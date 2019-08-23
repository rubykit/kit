module Kit::Auth::Controllers::Web::AuthorizationTokens
  class CreateController < Kit::Auth::Controllers::WebController

=begin

    before_action *[
      :redirect_if_current_user!,
    ]

    Kit::Router.register_rails_action(uid: 'kit_auth|web|authorization_tokens|new', aliases: ['web|authorization_tokens|new', 'web|users|sign_in', 'web|users|after_sign_out', 'web|users|after_reset_password_request'], controller: self, action: :new)

    def new
      @model = { values: { email: nil, password: nil }, errors: [] }
    end


    Kit::Router.register_rails_action(uid: 'kit_auth|web|authorization_tokens|create', aliases: ['web|authorization_tokens|create'], controller: self, action: :create)

    def create
      @model = params.to_h.slice(:email, :password).symbolize_keys

      context = @model.merge(
        request: request,
      )

      res, ctx = Kit::Organizer.call({
        ctx: context,
        list: [
          ->(email:) { [:ok, user: Kit::Auth::Models::Read::User.find_by(email: email)] },
          Kit::Auth::Actions::Users::VerifyPassword,
          Kit::Auth::Actions::Users::SignInWeb,
        ],
      })

      if res == :ok
        cookies.encrypted[:access_token] = ctx[:oauth_access_token_plaintext_secret]

        redirect_to Kit::Router.path(id: 'web|users|after_sign_in')
      else
        @errors_list = ctx[:errors]

        render :new
      end
    end

=end

  end
end