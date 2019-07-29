module Kit::Auth::Controllers
  # NOTE: This is a little backward: we inherit from the engine container controller in order to display the layout
  class ApiController < ::ApiController

    include Kit::Auth::Controllers::Concerns::CurrentUser

    before_action :set_response_headers

    protected

    def set_response_headers
      response.headers['Content-Type'] = Mime[:json_api].to_s
    end

  end
end
