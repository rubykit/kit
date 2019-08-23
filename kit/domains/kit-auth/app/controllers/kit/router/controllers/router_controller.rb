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
        if (300...400).cover?(http_metadata[:status])
          redirect_to(http_metadata.dig(:redirect, :location), status: http_metadata[:status])
        else
          raise "ERROR"
        end
      end
    end

    protected

    # LINK: https://api.rubyonrails.org/v5.1.7/classes/ActionDispatch/Cookies.html
    def set_cookies(request_object:)
      data = request_object.http.cookies
      return if data.blank?

      Kit::Domain::Services::Request.export_rails_cookies(request_cookies: data, rails_cookies: cookies)
    end

  end
end
