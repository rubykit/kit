module Kit::Router::Services::Request::Rails
  module Export

    # NOTE: very much a WIP!

    def self.export_request(request:, rails_request:, rails_cookies:, rails_controller:, mime: nil, content: nil, errors: nil, metadata: {})
      export_rails_cookies(request: request, rails_cookies: rails_cookies)
      handle_result(mime: mime, content: content, rails_controller: rails_controller, metadata: metadata)
    end

    def self.handle_result(mime:, content:, rails_controller:, metadata: {})
      if mime == :html
        handle_html(content: content, rails_controller: rails_controller)
      else
        http_metadata = metadata.dig(:http) || {}
        if is_redirect?(http_metadata: http_metadata)
          handle_redirect(http_metadata: http_metadata, rails_controller: rails_controller)
        else
          raise "UNHANDLED SITUATION, NEEDS TO BE IMPLEMENTED!"
        end
      end
    end

    def self.handle_html(content:, rails_controller:)
      rails_controller.render layout: true, html: content
      [:ok]
    end

    def self.is_redirect?(http_metadata:)
      (300...400).cover?(http_metadata[:status])
    end

    # REF: https://github.com/rails/rails/blob/master/actionpack/lib/action_controller/metal/redirecting.rb
    def self.handle_redirect(http_metadata:, rails_controller:)
      redirect_data = http_metadata[:redirect]

      options = {
        status: http_metadata[:status],
        notice: redirect_data[:notice],
        alert:  redirect_data[:alert],
      }

      rails_controller.redirect_to(redirect_data[:location], options)
      [:ok]
    end

    # REF: https://api.rubyonrails.org/v5.1.7/classes/ActionDispatch/Cookies.html
    def self.export_rails_cookies(request:, rails_cookies:)
      data = request.http.cookies
      return [:ok] if data.blank?

      data.each do |name, cookie|
        payload = cookie.slice(:value, :expires)
        if cookie[:encrypted] == true
          cookie_name = "#{Kit::Router::Services::Request::Rails.cookies_encrypted_prefix}#{name}"
          rails_cookies.encrypted[cookie_name] = payload
        elsif cookie[:signed] == true
          cookie_name = "#{Kit::Router::Services::Request::Rails.cookies_signed_prefix}#{name}"
          rails_cookies.signed[cookie_name] = payload
        else
          cookie_name = name
          rails_cookies[cookie_name] = payload
        end

      end

      [:ok]
    end

  end
end