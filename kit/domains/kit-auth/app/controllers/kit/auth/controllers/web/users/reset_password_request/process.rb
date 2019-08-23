module Kit::Auth::Controllers::Web::Users::ResetPasswordRequest
  module Process

    def self.endpoint(request:)
      # TODO: load user && create event reset event

      [:ok]
    end

    Kit::Router.register({
      uid:     'kit_auth|web|users|reset_password_request|process',
      aliases: ['web|users|reset_password_request|process'],
      target:  self.method(:endpoint),
    })

  end
end