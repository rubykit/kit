require 'json_schemer'

# Json-schema validation logic.
module Kit::Api::JsonApi::Services::SchemaValidation

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Api::JsonApi::Contracts

  # JSON:Api current JSON Schema.
  #
  # ## References
  # - https://json-schema.org
  # - https://jsonapi.org/faq/#is-there-a-json-schema-describing-json-api
  def self.schema
    @schema ||= JSONSchemer.schema(Pathname.new(File.expand_path('../../../../../../config/json_api_json_schema.json', __dir__)))
  end

  # Use `JSONSchemer` to check if `data` complies with the given `schema`.
  #
  # ## References
  # - https://github.com/davishmcclurg/json_schemer
  def self.valid?(data:, schema: self.schema)
    data   = data.deep_stringify_keys
    status = schema.valid?(data)

    if status == true
      [:ok]
    else
      #errors = schema.validate(data)
      [:error]
    end
  end

end
