require 'ostruct'

module Kit::Router::Models
  # Request object.
  class Request

    attr_reader :params, :root, :http, :metadata, :ip

    def initialize(params:, root: nil, http: nil, metadata: nil, ip: nil, **)
      @params = params
      @ip     = ip
      #@root   = root

      @http = OpenStruct.new(http || {
        csrf_token: nil,
        cookies:    {},
        headers:    {},
        user_agent: nil,
      })

      @metadata = OpenStruct.new(metadata || {})
    end

  end
end
