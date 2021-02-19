module Kit::Auth::Controllers::Web::Users::ResetPasswordRequest
  module Create

    def self.endpoint(router_request:)
      Kit::Organizer.call(
        list: [
          [:alias, :web_redirect_if_current_user!],
          self.method(:create_reset_password_request),
        ],
        ctx:  { router_request: router_request },
      )
    end

    Kit::Router::Services::Router.register(
      uid:     'kit_auth|web|users|reset_password_request|create',
      aliases: ['web|users|reset_password_request|create'],
      target:  self.method(:endpoint),
    )

    def self.create_reset_password_request(router_request:)
      model = router_request.params.slice(:email)

      status, ctx = Kit::Organizer.call(
        list: [
          Kit::Auth::Services::Contracts::Email.method(:validate),
          Kit::Auth::Actions::RequestMetadata::Create,
          self.method(:create_event),
          self.method(:schedule_process_action),
        ],
        ctx:  {
          email:          model[:email],
          router_request: router_request,
          user:           nil,
        },
      )

      if status == :ok
        Kit::Router::Controllers::Http.redirect_to(
          location: Kit::Router::Services::Adapters::Http::Mountpoints.path(id: 'web|users|after_reset_password_request'),
          notice:   I18n.t('kit.auth.passwords.send_paranoid_instructions'),
        )
      else
        Kit::Router::Controllers::Http.render(
          component: Kit::Auth::Components::Pages::Users::ResetPasswordRequest::New,
          params:    {
            model:       model,
            csrf_token:  router_request.http[:csrf_token],
            errors_list: ctx[:errors],
          },
        )
      end
    end

    def self.create_event(email:, request_metadata:)
      Kit::Events::Actions::CreateEvent.call(
        type: Kit::Auth::Events::ResetPasswordRequested,
        data: {
          email:               email,
          request_metadata_id: request_metadata&.id,
        },
      )
    end

    def self.schedule_process_action(event:)
      Kit::Router
        .delay
        .call(id: 'web|users|reset_password_request|process', params: { event_id: event.id })

      [:ok]
    end

  end
end
