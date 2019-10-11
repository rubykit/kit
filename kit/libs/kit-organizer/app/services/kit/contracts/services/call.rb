module Kit::Contracts::Services::Call

  def self.instrument(args:, block: nil, target_class:, method_name:, aliased_name:)
    class_name = target_class.name
    contracts  = Kit::Contracts::Services::Store.get(class_name: class_name, method_name: method_name)

    run_contracts(
      contracts:    contracts,
      method_name:  method_name,
      aliased_name: aliased_name,
      target_class: target_class,
      type:         :before,
      ctx:          args[:kargs],
    )

    result = target_class.send(aliased_name, args[:kargs])

    run_contracts(
      contracts:    contracts,
      method_name:  method_name,
      aliased_name: aliased_name,
      target_class: target_class,
      type: :after,
      ctx: { result: result },
    )

    result
  end

  def self.run_contracts(contracts:, target_class:, method_name:, aliased_name:, ctx:, type:)
    list = contracts[type]

    return if list.size == 0

    result, ctx_out = Kit::Organizer.call_for_contract({
      list: list,
      ctx:  ctx,
    })

    return if result == :ok

    callable  = target_class.method(aliased_name)

    error_msg = [
      "Kit::Contracts | #{type} failure for `#{target_class.name}.#{method_name}`",
    ]

    source_location = ctx_out[:callable].source_location
    if source_location
      str                    = "  #{source_location}"
      file_name, line_number = source_location
      source                 = IO.readlines(file_name)[line_number - 1].strip

      error_msg << "  #{source_location} #{source}"
    end

    error_msg << "  Called with: #{ctx_out[:ctx]}"

    raise error_msg.join("\n")
  end

  def self.check_if_returns_tupple
  end

end
