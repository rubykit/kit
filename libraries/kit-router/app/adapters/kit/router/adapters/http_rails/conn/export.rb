# Export a router Conn to a Rails response.
module Kit::Router::Adapters::HttpRails::Conn::Export

  def self.export_response(router_conn:, rails_controller:, rails_response:, rails_cookies: nil)
    Kit::Organizer.call(
      list: [
        self.method(:export_rails_cookies),
        self.method(:handle_response),
      ],
      ctx:  {
        router_conn:      router_conn,
        rails_cookies:    rails_cookies,
        rails_controller: rails_controller,
        rails_response:   rails_response,
      },
    )
  end

  def self.handle_response(router_conn:, rails_controller:, rails_response:)
    response      = router_conn.response
    content       = response[:content]
    mime          = response[:http][:mime]
    status        = response[:http][:status] || 200

    content_type  = mime ? Mime[mime.to_sym].to_s : nil

    if content_type
      rails_response.headers['Content-Type'] = content_type
      if content&.encoding
        content_type = "#{ content_type }; charset=#{ content.encoding }"
      end
    end

    rails_response.status = status

    if redirect_status?(status: status)
      handle_redirect(router_conn: router_conn, rails_controller: rails_controller)
    elsif mime == :html
      rails_controller.render status: status, content_type: content_type, layout: true, html: content
    else
      rails_controller.render status: status, content_type: content_type, body: content
    end

    [:ok]
  end

  def self.redirect_status?(status:)
    (300...400).cover?(status)
  end

  # REF: https://github.com/rails/rails/blob/master/actionpack/lib/action_controller/metal/redirecting.rb
  def self.handle_redirect(router_conn:, rails_controller:)
    redirect_data = router_conn.response[:http][:redirect]

    options = {
      status: router_conn.response[:http][:status],
    }

    rails_controller.redirect_to(redirect_data[:location], options)

    (redirect_data[:flash] || {}).each { |k, v| rails_controller.flash[k] = v }

    [:ok]
  end

  # REF: https://api.rubyonrails.org/v5.1.7/classes/ActionDispatch/Cookies.html
  def self.export_rails_cookies(router_conn:, rails_cookies: nil)
    return [:ok] if !rails_cookies

    data = router_conn.response[:http][:cookies]
    return [:ok] if data.blank?

    data.each do |name, cookie|
      payload = cookie.slice(:value, :expires)
      if cookie[:encrypted] == true
        cookie_name = "#{ Kit::Router::Adapters::HttpRails::Conn.cookies_encrypted_prefix }#{ name }"
        rails_cookies.encrypted[cookie_name] = payload
      elsif cookie[:signed] == true
        cookie_name = "#{ Kit::Router::Adapters::HttpRails::Conn.cookies_signed_prefix }#{ name }"
        rails_cookies.signed[cookie_name] = payload
      else
        cookie_name = name
        rails_cookies[cookie_name] = payload
      end

    end

    [:ok]
  end

end
