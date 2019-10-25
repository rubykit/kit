module Kit::Contract

  class Error < ::StandardError
    def initialize(contract_error, errors = nil)
      @contract_error = contract_error
      @errors         = errors

      super()
    end

    def message
      error.message
    end
  end

=begin

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

=end

end