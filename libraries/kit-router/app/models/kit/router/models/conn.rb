# The structure that holds all the info about the request / response.
#
# ## Connection fields
#
# ### Standard fields
#
#   * `adapter` - the connection adapter being used, as a symbol, example: `:http_rails`
#   * `route_id` - the id of the route used to identify the target endpoint, as a string
#   * `endpoint` - a hash containing data on the endpoint that was resolved for `route_id`
#     * `id` - the unique id the endpoint was registered with, as a string
#     * `callable` - the callable for the endpoint
#   * `metadata` - extra information that has been added to the connection, for instance the current user or state the adapter neeeds to maintain.
#
#  ### Optional fields
#
#  These can be `nil` if not applicable to the connection or adapter.
#     * `client_ip` - the IP of the client, example: `151.236,219.228`.
#     * `port` - the requested port as an integer, example: `80`
#     * `protocol` - the request protocol as a symbol, example: `:https`
#
# ## Request fields
#
# ### Standard fields
#
#   * `params` - the request params
#
# ### Html fields
#
#   * `cookies` -
#   * `headers` -
#   * `` -

# ### Mailer fields
#   * `subject` - the subject of the email
#   * `to` - who the message is destined for, can be a string or an array of addresses
#   * `from` - who the message is from
#   * `cc` - string or array of emails address to Carbon-Copy on this email
#   * `bcc` - string or array of emails address to Blind-Carbon-Copy on this email
#   * `reply_to` - string of the email address to set the Reply-To header of the email to
#   * `date` - the date to say the email was sent on.
#   * `headers` - a hash of header field names and value pairs
#   * `parts_order`
#   * `attachments`
#
# ## Response fields
#
#   * `body` - the response content
#
class Kit::Router::Models::Conn

  ATTRS = [
    :adapter,   :route_id, :endpoint, :metadata, :request, :response,
    :client_ip, :port,     :protocol,
  ]

  attr_reader(*ATTRS)

  # rubocop:disable Layout/ParameterAlignment
  # Initializer with some convenience keys.
  def initialize(adapter:,       route_id:,    endpoint:,
                 metadata:  nil, request: nil, response: nil,
                 client_ip: nil, port:    nil, protocol: nil)
    @adapter  = adapter
    @route_id = route_id
    @endpoint = {
      id:       nil,
      callable: nil,
    }.deep_merge(endpoint)

    @metadata = {}
      .deep_merge({
        adapters: { adapter => {} },
      })
      .deep_merge(metadata || {})

    @request = {
      params: {},

      http:   {
        cookies:      {},
        headers:      {},
        params_path:  {},
        params_query: {},
        params_body:  {},
        params_kit:   {},
      },

      mailer: {},
    }.deep_merge(request || {})

    @response = {
      content:      nil,
      charset:      'UTF-8',
      content_type: nil,

      http:         {
        cookies: {},
        headers: {},
        cgi:     {},
        status:  nil,
      },

      mailer:       {
        headers:     {
          subject: nil,
          to:      nil,
          from:    nil,
          cc:      nil,
          bcc:     nil,
          #reply_to:     nil,
          #date:         nil,

          #content_type: nil,
          #ime_version: nil,
          #charset:      nil,
          #parts_order:  nil,
        },

        attachments: {},
      },
    }.deep_merge(response || {})

    @client_ip = client_ip
    @port      = port
    @protocol  = protocol
  end
  # rubocop:enable Layout/ParameterAlignment

  # Allow to pretend we're a hash.
  def [](name)
    send(name.to_sym)
  end

  # Forward `dig`.
  def dig(name, *names)
    name = name.to_sym
    if name.in?(ATTRS)
      send(name).dig(*names)
    else
      nil
    end
  end

  # Convenience method to access params.
  def params
    request[:params]
  end

  # Convenience method to access request.
  def req
    request
  end

  # Convenience method to access request.
  def resp
    response
  end

  # Convenience request to access config.
  def config
    metadata[:config] || {}
  end

  # Ensure we return a deep copy to avoid side effects.
  def to_h
    {
      adapter:   adapter,
      route_id:  route_id.dup,
      endpoint:  endpoint.deep_dup,

      client_ip: client_ip.dup,
      port:      port,
      protocol:  protocol,

      request:   request.deep_dup,
      response:  response.deep_dup,
      metadata:  metadata.deep_dup,
    }
  end

  # Awesome print display.
  def ai(options = {})
    self.to_h.ai(options.merge(class_name_display: 'Kit::Router::Models::Conn'))
  end

end
