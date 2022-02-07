# Adapter to call endpoints through a Mailer.
#
# This adapter is a wrapper around Actionailer.
module Kit::Router::Adapters::MailerRails

  def self.call(router_conn:)
    Kit::Organizer.call(
      list: [
        router_conn[:endpoint][:callable],
        self.method(:send_to_mailer),
      ],
      ctx:  {
        router_conn: router_conn,
      },
    )
  end

  def self.cast(router_conn:)
    begin
      call(router_conn: router_conn)
    rescue Exception => e # rubocop:disable Lint/RescueException
      Kit::Error.report_exception(exception: e)
    end

    [:ok]
  end

  # ### References
  # - https://github.com/rails/rails/blob/main/actionmailer/lib/action_mailer/base.rb#L736
  # - https://api.rubyonrails.org/v6.0.0/classes/ActionMailer/Base.html
  MAIL_HEADERS = [
    :subject,
    :to,
    :from,
    :cc,
    :bcc,
    :reply_to,
    :data,

    :delivery_method_options,

    :mime_version,
    :charset,
    :content_type,
    :parts_order,

    :return_path,
  ]

  def self.send_to_mailer(router_conn:)
    mailer_class    = router_conn.dig(:adapters, :mailer_rails, :mailer_class)  || default_mailer_adapter&.dig(:mailer_class)
    mailer_method   = router_conn.dig(:adapters, :mailer_rails, :mailer_method) || default_mailer_adapter&.dig(:mailer_method)

    res_data = router_conn[:response][:mailer]

    mailer_instance = ActionMailer::Parameterized::Mailer.new(mailer_class, **{
      content:            router_conn[:response][:content],
      headers:            res_data[:headers]            || {},
      attachments:        res_data[:attachments]        || {},
      inline_attachments: res_data[:inline_attachments] || {},
    },)

    message = mailer_instance.send(mailer_method)

    message.deliver_now

    [:ok]
  end

  def self.rails_default_email(context:)
    params       = context.params
    content_html = params[:content].is_a?(Hash) ? params[:content][:html] : params[:content]

    context.mail(**params[:headers]) do |format|
      format.html { content_html }

      params[:attachments].each        { |k, v| context.attachments[k]        = v }
      params[:inline_attachments].each { |k, v| context.attachments.inline[k] = v }
    end
  end

  class << self

    attr_accessor :default_mailer_adapter

  end

end
