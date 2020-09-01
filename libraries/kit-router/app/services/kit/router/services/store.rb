# Local store to save all endpoints references.
module Kit::Router::Services::Store

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Router::Contracts

  def self.router_store
    @router_store ||= create_store
  end

  after Ct::RouterStore
  def self.create_store
    {
      endpoints:   {},
      aliases:     {},
      mountpoints: [],
=begin
      mountpoints: {
        [:http, :rails] => [],
      },
=end
    }
  end

end
