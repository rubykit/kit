module Kit::Router::Controllers
  class RouterController < ::WebController

    def route
      status, ctx = Kit::Organizer.call({
        list: [
          Kit::Domain::Services::Request.method(:create_from_rails_request),
          Kit::Auth::Controllers::Web::CurrentUser.method(:resolve_current_user),
          request.params[:kit_router_method],
        ],
        ctx:  {
          rails_request:      self.request,
          rails_cookies:      cookies,
          controller_context: self,
        },
      })

      set_cookies(request_object: ctx[:request])

      if ctx[:mime] == :html
        render layout: true, html: ctx[:content]
      else
        http_metadata = ctx.dig(:metadata, :http) || {}
        if is_redirect?(http_metadata: http_metadata)
          handle_redirect(http_metadata: http_metadata)
        else
          raise "UNHANDLED SITUATION"
        end
      end
    end

    protected

    def is_redirect?(http_metadata:)
      (300...400).cover?(http_metadata[:status])
    end

    # REF: https://github.com/rails/rails/blob/master/actionpack/lib/action_controller/metal/redirecting.rb
    def handle_redirect(http_metadata:)
      redirect_data = http_metadata[:redirect]

      options = {
        status: http_metadata[:status],
        notice: redirect_data[:notice],
        alert:  redirect_data[:alert],
      }

      redirect_to(redirect_data[:location], options)
    end

    # REF: https://api.rubyonrails.org/v5.1.7/classes/ActionDispatch/Cookies.html
    def set_cookies(request_object:)
      data = request_object.http.cookies
      return if data.blank?

      Kit::Domain::Services::Request.export_rails_cookies(request_cookies: data, rails_cookies: cookies)
    end

  end
end
