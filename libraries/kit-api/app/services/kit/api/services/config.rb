# Hold config data.
#
# ## Example
# ```ruby
# {
#   page_size:     50,
#   max_page_size: 100,
# }
# ```
#
# ### Todo: rewrite this with `Kit::Config` when available!
#
module Kit::Api::Services::Config

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Api::Contracts

  PAGE_SIZE_MAX_DEFAULT = 200
  PAGE_SIZE_DEFAULT     = 100

  # Returns an api config object.
  # This is per API.
  def self.create_config(options = {})
    # Max page size
    page_size_max = options[:page_size_max]
    if !page_size_max.is_a?(Integer)
      page_size_max = PAGE_SIZE_MAX_DEFAULT
    end

    # Default page size
    page_size = options[:page_size]
    if !page_size.is_a?(Integer) || page_size < 1
      page_size = PAGE_SIZE_DEFAULT
    end
    if page_size > page_size_max
      page_size = page_size_max
    end

    config = {
      resources:            {},
      paginator:            nil,
      field_transformation: :underscore,
      linker:               nil,
      linker_config:        {
        export_sparse_fieldsets: true,
        export_filters:          true,
        export_sorting:          true,
      },
      inclusion_level:      2,
    }

    config
      .merge(options)
      .merge({
        page_size:     page_size,
        page_size_max: page_size_max,
      })
  end

  def validate_config(config:)
    contract = Ct::And[
      Ct::Hash[config: Ct::Config],
      self.method(:validate_config_resources),
    ]

    Kit::Contract::Services::Validation.valid?(contract: contract, args: [{ config: config }])
  end

  # Ensure that used Types are registered on the config object, including relationship resources.
  def self.validate_config_resources(config:)
    if config[:resources].empty?
      return [:error, 'Kit::Api - Error: no resources defined for config object']
    end

    config[:resources].each do |resource_name, resource|
      resource[:relationships].each do |relationship_name, relationship|
        relationship_resource = relationship[:resource]
        if !relationship_resource
          return Kit::Error("Kit::Api - Error: missing resource for relationship `#{ resource_name }.#{ relationship_name }`")
        end

        if !config[:resources][relationship_resource]
          return Kit::Error("Kit::Api - Error: unregistered resource `#{ relationship_resource }` for relationship `#{ resource_name }.#{ relationship_name }`")
        end
      end
    end

    [:ok]
  end

end
