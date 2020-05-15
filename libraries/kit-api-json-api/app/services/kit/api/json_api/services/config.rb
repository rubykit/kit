# Hold config data.
#
# ### ☠️ Deprecate this
#
# This should be per API instance, using `Kit::Config` when available.
#
module Kit::Api::JsonApi::Services::Config

  include Kit::Contract
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  Ct::PositiveInt = Ct::And[Ct::Integer, ->(page_size) { page_size > 0 }]

  DEFAULT_MAX_PAGE_SIZE = 200
  DEFAULT_PAGE_SIZE     = 100

  before Ct::Hash[page_size: Ct::PositiveInt]
  def self.max_page_size=(page_size:)
    @max_page_size = page_size
  end

  after Ct::PositiveInt
  def self.max_page_size
    page_size = @max_page_size
    if !page_size.is_a?(Integer)
      page_size = DEFAULT_MAX_PAGE_SIZE
    end

    page_size
  end

  before Ct::Hash[page_size: Ct::PositiveInt]
  def self.default_page_size=(page_size:)
    @default_page_size = page_size
  end

  after Ct::PositiveInt
  def self.default_page_size
    page_size = @default_page_size
    if !page_size.is_a?(Integer) || page_size < 1
      page_size = DEFAULT_PAGE_SIZE
    end

    page_size
  end

end
