module Kit::Auth::Controllers::Web::Users::ResetPasswordRequest
  module Create

    def self.endpoint(request:)
      Kit::Organizer.call({
        ctx:  { request: request, },
        list: [
          Kit::Auth::Controllers::Web::CurrentUser.method(:redirect_if_current_user!),
          self.method(:create_reset_password_request),
        ],
      })
    end

    Kit::Router.register({
      uid:     'kit_auth|web|users|reset_password_request|create',
      aliases: ['web|users|reset_password_request|create'],
      target:  self.method(:endpoint),
    })

    def self.create_reset_password_request(request:)
      model = request.params.slice(:email)

      status, ctx = Kit::Organizer.call({
        ctx: {
          email:   model[:email],
          request: request,
          user:    nil,
        },
        list: [
          self.method(:validate_email),
          Kit::Auth::Actions::RequestMetadata::Create,
          self.method(:create_event),
          self.method(:schedule_process_action),
        ],
      })

      if status == :ok
        Kit::Router::Controllers::Http.redirect_to({
          location: Kit::Router.path(id: 'web|users|after_reset_password_request'),
          notice:   I18n.t('kit.auth.passwords.send_paranoid_instructions'),
        })
      else
        handle_errors(request: request, ctx: ctx, model: model)
      end
    end

    def self.handle_errors(request:, ctx:, model:)
      page = Kit::Auth::Components::Pages::Users::ResetPasswordRequest::New.new(
        model:       model,
        csrf_token:  request.http[:csrf_token],
        errors_list: ctx[:errors],
      )
      content = page.local_render

      [:ok, {
        mime:    :html,
        content: content,
      }]
    end

    def self.validate_email(email:)
      res = Kit::Auth::Services::Contracts::Email.new.call({
        email: email,
      })

      if res.errors.count > 0
        [:error, errors: Kit::Error.from_contract(res)]
      else
        [:ok]
      end
    end

    def self.create_event(email:, request_metadata:)
      Kit::Events::Actions::CreateEvent.call({
        type: Kit::Auth::Events::ResetPasswordRequested,
        data: {
          email:               email,
         request_metadata_id: request_metadata&.id,
        },
      })
    end

    def self.schedule_process_action(event:)
      Kit::Router
        .delay
        .call(id: 'web|users|reset_password_request|process', params: { event_id: event.id })

      [:ok]
    end

  end
end