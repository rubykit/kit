module Kit::Router::Services::Adapters::Http::Rails::Request

  # Export a KitRequest to a Rails response.
  # NOTE: very much a WIP!
  module Export

    def self.export_request(router_request:, router_response:, rails_cookies:, rails_controller:, rails_response:)
      Kit::Organizer.call({
        list: [
          self.method(:export_rails_cookies),
          self.method(:handle_result),
        ],
        ctx:  {
          router_request:   router_request,
          router_response:  router_response,
          rails_cookies:    rails_cookies,
          rails_controller: rails_controller,
          rails_response:   rails_response,
        },
      })
    end

    def self.handle_result(router_request:, router_response:, rails_controller:, rails_response:)
      metadata      = router_response[:metadata] || {}
      mime          = router_response[:mime]
      content       = router_response[:content]

      http_metadata = metadata.dig(:http) || {}
      content_type  = mime ? Mime[mime.to_sym].to_s : nil
      status        = http_metadata[:status] || 200

      if content_type
        rails_response.headers['Content-Type'] = content_type
      end

      rails_response.status = status

      if redirect?(http_metadata: http_metadata)
        handle_redirect(rails_controller: rails_controller, http_metadata: http_metadata)
      elsif mime == :html
        rails_controller.render status: status, content_type: content_type, layout: true, html: content
      else
        rails_controller.render status: status, content_type: content_type, body: content
      end

      [:ok]
    end

    def self.redirect?(http_metadata:)
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
    def self.export_rails_cookies(router_request:, rails_cookies:)
      data = router_request.http.cookies
      return [:ok] if data.blank?

      data.each do |name, cookie|
        payload = cookie.slice(:value, :expires)
        if cookie[:encrypted] == true
          cookie_name = "#{ Kit::Router::Services::Adapters::Http::Rails::Request.cookies_encrypted_prefix }#{ name }"
          rails_cookies.encrypted[cookie_name] = payload
        elsif cookie[:signed] == true
          cookie_name = "#{ Kit::Router::Services::Adapters::Http::Rails::Request.cookies_signed_prefix }#{ name }"
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
