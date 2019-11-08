module Kit::Contract

  class Error < ::StandardError
    def initialize(contract_errors:, errors:, target:, target_class:, method_name:, method_type:, type:, args:)
      @contract_error = contract_errors
      @errors         = errors
      @target         = target
      @target_class   = target_class
      @method_name    = method_name
      @method_type    = method_type
      @type           = type
      @args           = args

      @backtrace      = caller
      @backtrace.shift()

      super
    end

    def backtrace
      list = []

      if @contract_error
        if @contract_error[:args]
          list << "Arguments used: #{@contract_error[:args]}"
        end
        error_callable = @contract_error[:callable]
        if error_callable.respond_to?(:source_location)
          source_location = @contract_error[:callable]&.source_location
          if source_location
            file_name, line_number = source_location
            source                 = IO.readlines(file_name)[line_number - 1].strip

            # NOTE: naive way to detect one-liner predicates
            if source.count('{') > 0 && source.count('{') == source.count('}')
              list << "#{file_name}:#{line_number}:src `#{source}`"
            end
          end
        end
      end

      @backtrace.dup.unshift(*list)
    end

    def message
      method = "#{@target_class.name}#{(@method_type == :singleton) ? '#' : '.' }#{@method_name}"
      str    = "Contract failure #{@type} `#{method}`"

      if @errors
        errors = @errors.select { |error| error[:detail] != 'Invalid result type for contract' }
        if errors.size > 0
          str += ": #{errors}"
        end
      end

      str
    end

  end

end