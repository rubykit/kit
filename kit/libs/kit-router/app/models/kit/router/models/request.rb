require 'ostruct'

module Kit::Router::Models
  class Request
    attr_reader :params, :root, :http, :metadata, :ip

    def initialize(params:, root: nil, http: nil, metadata: nil, ip: nil, **)
      @params = params
      #@root   = root

      @ip     = ip

      @http   = OpenStruct.new(http || {
        csrf_token: nil,
        cookies:    {},
        headers:    {},
        user_agent: nil,
      })

      @metadata = OpenStruct.new(metadata || {})
    end
  end
end