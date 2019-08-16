module Kit::Auth::Controllers::Web::Users
  class CreateController < Kit::Auth::Controllers::WebController

    before_action *[
      :redirect_if_current_user!,
    ]

    Kit::Router.register(uid: 'kit_auth|web|users|new', aliases: ['web|users|new', 'web|users|sign_up'], controller: self, action: :new)

    def new
      @model = { email: nil, password: nil, password_confirmation: nil }
    end


    Kit::Router.register(uid: 'kit_auth|web|users|create', aliases: ['web|users|create'], controller: self, action: :create)

    def create
      @model = params.to_h.slice(:email, :password, :password_confirmation).symbolize_keys

      context = @model.merge(
        request:           request,
        oauth_application: ::Doorkeeper::Application.find_by!(uid: 'webapp'),
      )

      res, ctx = Kit::Organizer.call({
        ctx: context,
        list: [
          Kit::Auth::Actions::Users::CreateUserWithPassword,
          Kit::Auth::Actions::Users::CreateUserRequestMetadata,
          Kit::Auth::Actions::Users::GetAuthorizationTokenForUser,
          Kit::Auth::Actions::Users::UpdateUamForAuthorizationToken,
        ],
      })

      if res == :ok
        cookies.encrypted[:access_token] = ctx[:oauth_access_token].token

        redirect_to Kit::Router.path(id: 'web|users|after_sign_up')
      else
        @errors_list = ctx[:errors]

        render :new
      end
    end

  end
end