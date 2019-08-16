module Kit::Auth::Controllers::Web::AuthorizationTokens
  class CreateController < Kit::Auth::Controllers::WebController

    before_action *[
      :redirect_if_current_user!,
    ]

    Kit::Router.register(uid: 'kit_auth|web|authorization_tokens|new', aliases: ['web|authorization_tokens|new', 'web|users|sign_in', 'web|users|after_sign_out'], controller: self, action: :new)

    def new
      @model = { values: { email: nil, password: nil }, errors: [] }
    end


    Kit::Router.register(uid: 'kit_auth|web|authorization_tokens|create', aliases: ['web|authorization_tokens|create'], controller: self, action: :create)

    def create
      @model = params.to_h.slice(:email, :password).symbolize_keys

      context = @model.merge(
        request:           request,
        oauth_application: ::Doorkeeper::Application.find_by!(uid: 'webapp'),
      )

      res, ctx = Kit::Organizer.call({
        ctx: context,
        list: [
          Kit::Auth::Actions::Users::VerifyUserWithPassword,
          Kit::Auth::Actions::Users::CreateUserRequestMetadata,
          Kit::Auth::Actions::Users::GetAuthorizationTokenForUser,
          Kit::Auth::Actions::Users::UpdateUamForAuthorizationToken,
        ],
      })

      if res == :ok
        cookies.encrypted[:access_token] = ctx[:oauth_access_token].token

        redirect_to Kit::Router.path(id: 'web|users|after_sign_in')
      else
        @errors_list = ctx[:errors]

        render :new
      end
    end

  end
end