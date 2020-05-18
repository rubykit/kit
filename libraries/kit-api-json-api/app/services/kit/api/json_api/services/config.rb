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
module Kit::Api::JsonApi::Services::Config

  include Kit::Contract
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  PAGE_SIZE_MAX_DEFAULT = 200
  PAGE_SIZE_DEFAULT     = 100

  # Returns an api config object.
  # This is per API.
  def self.default_config(options = {})
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
      paginator:             nil,
      page_size:             page_size,
      page_size_max:         page_size_max,

      field_transformation: :underscore,
      linker:                nil,
    }

    config
  end

end
