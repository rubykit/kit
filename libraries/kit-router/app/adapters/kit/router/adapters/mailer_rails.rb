module Kit::Router::Adapters::MailerRails

  def self.call(endpoint:, params:)
    Kit::Organizer.call(
      list: [
        self.method(:create_router_request),
        endpoint,
        self.method(:send_to_mailer),
      ],
      ctx:  {
        params: params,
      },
    )
  end

  def self.cast(endpoint:, params:)
    call(endpoint: endpoint, params: params)

    [:ok]
  end

  def self.create_router_request(params:)
    router_request = Kit::Router::Models::RouterRequest.new(params: params)

    [:ok, router_request: router_request]
  end

  # Ref: https://github.com/rails/rails/blob/main/actionmailer/lib/action_mailer/base.rb#L736
  MAIL_PARAMETERS = [:subject, :to, :from, :cc, :bcc, :reply_to, :data, :return_path]

  def self.send_to_mailer(router_request:, router_response:)
    mailer_class    = router_request.dig(:adapters, :mailer_rails, :mailer_class)  || default_mailer_adapter&.dig(:mailer_class)
    mailer_method   = router_request.dig(:adapters, :mailer_rails, :mailer_method) || default_mailer_adapter&.dig(:mailer_method)

    params = router_request.params.to_h.slice(*MAIL_PARAMETERS)

    mailer_instance = ActionMailer::Parameterized::Mailer.new(mailer_class, **{
      params: params,
      html:   router_response[:content],
    },)

    message = mailer_instance.send(mailer_method)

    message.deliver_now

    [:ok]
  end

  class << self

    attr_accessor :default_mailer_adapter

  end

end
