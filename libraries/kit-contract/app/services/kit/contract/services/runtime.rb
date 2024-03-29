# Namespace for runtime logic.
module Kit::Contract::Services::Runtime

  def self.instrument(parameters:, target:, target_class:, method_name:, method_type:, aliased_name:, contracts_before_uid:, contracts_after_uid:, block: nil)
    _, ctx    = Kit::Contract::Services::Store.get(key: contracts_before_uid)
    contracts = ctx[:value]

    run_contracts!(
      contracts:     contracts,
      parameters:    parameters,
      error_context: {
        type:         :before,
        method_name:  method_name,
        method_type:  method_type,
        target:       target,
        target_class: target_class,
      },
    )

    result = target.send(aliased_name, *(parameters[:args] || []), **(parameters[:kwargs] || {}), &parameters[:block])

    _, ctx    = Kit::Contract::Services::Store.get(key: contracts_after_uid)
    contracts = ctx[:value]

    run_contracts!(
      contracts:     contracts,
      parameters:    { args: [result] },
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

  def self.run_contracts!(contracts:, parameters:, error_context: {})
    return if contracts.size == 0

    status, ctx_out = Kit::Contract::Services::Validation.all(
      contracts:  contracts,
      parameters: parameters,
      reentrant:  true,
    )

    return if status == :ok

    raise Kit::Contract::Error.new(**error_context.merge({
      contract_errors: ctx_out[:contract_error],
      errors:          ctx_out[:errors],
      parameters:      parameters,
    }))
  end

  # TODO: add different categories of contracts that can be disabled by category
  def self.active?
    @active ||= (ENV['KIT_CONTRACTS'] != 'false' && ENV['KIT_CONTRACTS'] != false)
  end

end
