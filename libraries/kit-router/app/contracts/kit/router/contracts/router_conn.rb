class Kit::Router::Contracts::RouterConn < Kit::Contract::BuiltInContracts::Hash

  Ct = Kit::Router::Contracts

  def setup(keyword_args_contracts = nil)
    @state[:contracts_list] = []

    instance(Ct::IsA[::Kit::Router::Models::Conn], safe: true)
    with(keyword_args_contracts || [])
  end

end
