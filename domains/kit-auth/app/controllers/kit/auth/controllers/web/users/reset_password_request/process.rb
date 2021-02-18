module Kit::Auth::Controllers::Web::Users::ResetPasswordRequest
  module Process

    def self.endpoint(router_request:)
      event_record = Kit::Domain::Models::Read::Event.find(router_request.params[:event_id])

      Kit::Organizer.call(
        list:   [
          self.method(:find_user),
          Kit::Auth::Actions::OauthApplications::LoadWeb,
          Kit::Auth::Actions::OauthAccessTokens::CreateForPasswordReset,
          self.method(:create_event),
          self.method(:target_email_system),
        ],
        ctx:    { event_record: event_record },
        expose: { ok: [:user, :oauth_access_token], error: [:errors] },
      )
    end

    Kit::Router::Services::Router.register(
      uid:     'kit_auth|web|users|reset_password_request|process',
      aliases: ['web|users|reset_password_request|process'],
      target:  self.method(:endpoint),
    )

    def self.find_user(event_record:)
      email = event_record.data[:email]
      if email.blank?
        return [:error, detail: "Unknown email `#{ email }`"]
      end

      user = Kit::Domain::Models::Read::User.find_by(email: email)
      if !user
        return [:error, detail: "Could not find user for email `#{ email }`"]
      end

      [:ok, user: user]
    end

    def self.create_event(user:, oauth_access_token:)
      Kit::Events::Actions::CreateEvent.call(
        type:    Kit::Auth::Events::ResetPasswordTokenCreated,
        data:    {
          user_id:            user.id,
          oauth_access_token: oauth_access_token.id,
        },
        targets: {
          except: :email_notifications,
        },
      )
    end

    # NOTE: we only need to do this when there is sensitive data that we do not want to persist in the event
    def self.target_email_system(user:, oauth_access_token_plaintext_secret:, event:)
      # WARNING: This call NEEDS to be sync !
      Kit::Router
        .call(id: 'system|events|process', params: {
          event_id: event.id,
          targets:  {
            except: :email_notifications,
            params: {
              oauth_access_token_plaintext_secret: oauth_access_token_plaintext_secret,
            },
          },
        },)

      [:ok]
    end

  end
end
