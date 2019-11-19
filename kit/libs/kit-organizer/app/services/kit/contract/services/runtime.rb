module Kit::Contract::Services::Runtime

  def self.instrument(args:, block: nil, target:, target_class:, method_name:, method_type:, aliased_name:, contracts_before_uid:, contracts_after_uid:)
    _, ctx    = Kit::Contract::Services::Store.get(key: contracts_before_uid)
    contracts = ctx[:value]

    run_contracts!(
      contracts:     contracts,
      args:          args,
      error_context: {
        type:         :before,
        method_name:  method_name,
        method_type:  method_type,
        target:       target,
        target_class: target_class,
      },
    )

    result = target.send(aliased_name, *args)

    _, ctx    = Kit::Contract::Services::Store.get(key: contracts_after_uid)
    contracts = ctx[:value]

    run_contracts!(
      contracts:     contracts,
      args:          [result],
      error_context: {
        type:         :after,
        method_name:  method_name,
        method_type:  method_type,
        target:       target,
        target_class: target_class,
      },
    )

    result
  end

  def self.run_contracts!(contracts:, args:, error_context: {})
    return if contracts.size == 0

    status, ctx_out = Kit::Contract::Services::Validation.all({
      contracts: contracts,
      args:      args,
    })

    return if status == :ok

    raise Kit::Contract::Error.new(error_context.merge({
      contract_errors: ctx_out[:contract_error],
      errors:          ctx_out[:errors],
      args:            args,
    }))
  end

  # TODO: add different categories of contracts that can be disabled by category
  def self.is_active?
    @active ||= (ENV['KIT_CONTRACTS'] != 'false' && ENV['KIT_CONTRACTS'] != false)
  end

end
