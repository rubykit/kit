require_relative "api/concerns/current_user"

module Kit::Auth::Controllers
  # NOTE: This is a little backward: we inherit from the engine container controller in order to display the layout
  class ApiController < ::ApiController
    include Kit::Auth::Controllers::Api::Concerns::CurrentUser

    before_action :set_response_headers

    def cookies
      @cookies ||= OpenStruct.new(encrypted: {})
    end

    protected

    def set_response_headers
      response.headers['Content-Type'] = Mime[:json_api].to_s
    end

  end
end
