module Kit::Contract::Services::Call

  def self.instrument(args:, block: nil, target:, target_class:, method_name:, method_type:, aliased_name:)
    class_name = target_class.name
    contracts  = Kit::Contract::Services::Store.get(class_name: class_name, method_name: method_name, method_type: method_type)

    run_contracts(
      contracts:    contracts,
      method_name:  method_name,
      aliased_name: aliased_name,
      target:       target,
      target_class: target_class,
      type:         :before,
      ctx:          args[:kargs],
    )

    result = target.send(aliased_name, args[:kargs])

    run_contracts(
      contracts:    contracts,
      method_name:  method_name,
      aliased_name: aliased_name,
      target:       target,
      target_class: target_class,
      type:         :after,
      ctx:          { result: result },
    )

    result
  end

  def self.run_contracts(contracts:, target:, target_class:, method_name:, aliased_name:, ctx:, type:)
    list = contracts[type]

    return if list.size == 0

    status, ctx_out = Kit::Organizer.call_for_contract({
      list: list,
      ctx:  ctx,
    })

    return if status == :ok

    raise Kit::Contract::Error.new(ctx_out[:contract_error], ctx_out[:errors])

    callable  = target.method(aliased_name)

    error_msg = [
      "Kit::Contract | #{type} failure for `#{target_class.name}.#{method_name}`",
    ]

    if ctx_out[:errors]
      ctx_out[:errors].each do |error|
        error_msg << "  #{error[:detail]}"
      end
    end

    if ctx_out[:contract_error]
      error_callable = ctx_out[:contract_error][:callable]
      if error_callable.respond_to?(:source_location)
        source_location = ctx_out[:contract_error][:callable]&.source_location
        if source_location
          str                    = "  #{source_location}"
          file_name, line_number = source_location
          source                 = IO.readlines(file_name)[line_number - 1].strip

          # NOTE: naive way to detect one-liner predicates
          if source.count('{') > 0 && source.count('{') == source.count('}')
            error_msg << "  #{source_location} #{source}"
          end
        end
      end
    end

    error_msg << "    Called with: #{ctx_out[:contract_error][:ctx]}"

    raise error_msg.join("\n")
  end

  def self.check_if_returns_tupple
  end

end
