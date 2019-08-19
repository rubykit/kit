module Kit::Auth::Controllers::Web::Users
  class ResetPasswordController < Kit::Auth::Controllers::WebController

    before_action *[
      :redirect_if_current_user!,
      :extract_auth_token!,
      -> { redirect_if_missing_scope!(scope: 'update_user_secret') },
    ]

    Kit::Router.register(uid: 'kit_auth|web|users|reset_password|edit', aliases: ['web|users|reset_password|edit'], controller: self, action: :edit)

    def edit
      @model = { password: nil, password_confirmation: nil }
    end


    Kit::Router.register(uid: 'kit_auth|web|users|reset_password|update', aliases: ['web|users|reset_password|update'], controller: self, action: :update)

    def update
      @model = params.to_h.slice(:password, :password_confirmation).symbolize_keys

      context = @model.merge(
        user:    current_user,
        request: request,
      )

      res, ctx = Kit::Organizer.call({
        ctx: context,
        list: [
          Kit::Auth::Actions::Users::UpdatePassword,
          Kit::Auth::Actions::Users::SignInWeb,
        ],
      })

      if res == :ok
        Kit::Auth::Services::OauthAccessToken.revoke(oauth_access_token: current_user_oauth_access_token)
        cookies.encrypted[:access_token] = ctx[:oauth_access_token_plaintext_secret]

        redirect_to Kit::Router.path(id: 'web|users|after_reset_password'), notice: I18n.t('kit.auth.passwords.updated')
      else
        @errors_list = ctx[:errors]

        render :edit
      end

      # Redirect regardless
    end

    protected

    def extract_auth_token!
      @auth_token_secret = request.params[:access_token]
      return if !@auth_token.blank?

      redirect_to Kit::Router.path(id: 'web|users|sign_in')
    end

  end
end