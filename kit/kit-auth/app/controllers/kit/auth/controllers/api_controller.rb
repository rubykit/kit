module Kit::Auth::Controllers
  class ApiController < ActionController::API # :nodoc:

    include Kit::Auth::Controllers::Concerns::CurrentUser

    before_action :set_response_headers

    protected

    def set_response_headers
      response.headers['Content-Type'] = Mime[:json_api].to_s
    end

  end
end
