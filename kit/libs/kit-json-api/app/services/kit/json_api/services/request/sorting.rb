# @ref https://jsonapi.org/format/1.1/#fetching-sorting
module Kit::JsonApi::Services::Request::Sorting
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  def self.handle_sorting(config:, query_params:, request:)
    args = { config: config, query_params: query_params, request: request, }

    Kit::Organizer.call({
      list: [
        self.method(:validate_params),
        self.method(:add_to_request),
      ],
      ctx: args,
    })
  end

  def self.validate_params(config:, query_params:)
    [:ok]
  end

  def self.add_to_request(config:, query_params:, request:)
    [:ok, request: request]
  end

end