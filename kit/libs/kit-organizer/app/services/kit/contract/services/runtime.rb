module Kit::Contract::Services::Runtime

  def self.instrument(args:, block: nil, target:, target_class:, method_name:, method_type:, aliased_name:)
    class_name = target_class.name
    contracts  = Kit::Contract::Services::Store.get(
      class_name:  class_name,
      method_name: method_name,
      method_type: method_type,
    )

    run_contracts(
      type:         :before,
      contracts:    contracts,
      method_name:  method_name,
      method_type:  method_type,
      aliased_name: aliased_name,
      target:       target,
      target_class: target_class,
      args:         args,
    )

    result = target.send(aliased_name, *args)

    run_contracts(
      type:         :after,
      contracts:    contracts,
      method_name:  method_name,
      method_type:  method_type,
      aliased_name: aliased_name,
      target:       target,
      target_class: target_class,
      args:         [{ result: result }],
    )

    result
  end

  def self.run_contracts(contracts:, target:, target_class:, method_name:, aliased_name:, args:, type:, method_type:)
    list = contracts[type]

    return if list.size == 0

    status, ctx_out = Kit::Contract::Services::Validation.all({
      contracts: list,
      args:      args,
    })

    return if status == :ok

    raise Kit::Contract::Error.new(
      contract_errors: ctx_out[:contract_error],
      errors:          ctx_out[:errors],
      target:          target,
      target_class:    target_class,
      method_name:     method_name,
      method_type:     method_type,
      type:            type,
      args:            args,
    )
  end

end
