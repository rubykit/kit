require 'awesome_print'

# When using contracts on method signatures (through `before`, `after`, `contract`) a `Kit::Contract::Error` exception is raised when a contract failure happens.
class Kit::Contract::Error < ::StandardError

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

  # Display informations about the the contract that failed.
  # @api private
  def backtrace
    list = []

    if @contract_error
      if @contract_error[:contracts_stack]
        list << 'Kit::Contract'.red

        contracts = []
        @contract_error[:contracts_stack].each do |el|
          name = el.respond_to?(:get_meta) ? el.get_meta[:name] : nil
          if name
            name = name.yellow
          else
            name = "Unnamed #{ el.class.name }"
          end
          contracts << name
          #contracts << [name, el.inspect].to_s
        end

        list << "  Hierarchy: #{ contracts.join(' > ') }"
      end

      if @contract_error[:args]
        arguments = @contract_error[:args].ai
        list << "  Arguments used: #{ arguments }"
      end
      error_callable = @contract_error[:callable]
      if error_callable.respond_to?(:source_location)
        source_location = @contract_error[:callable]&.source_location
        if source_location
          file_name, line_number = source_location
          source                 = IO.readlines(file_name)[line_number - 1].strip

          # NOTE: naive way to detect one-liner predicates
          if source.count('{') > 0 && source.count('{') == source.count('}')
            list << "#{ file_name }:#{ line_number }:src `#{ source }`"
          end
        end
      end
    end

    @backtrace.dup.unshift(*list)
  end

  # Generates an error message that can be displayed.
  # @api private
  def message
    contract = @contract_error[:callable]

    method   = "#{ @target_class.name }#{ (@method_type == :singleton_method) ? '#' : '.' }#{ @method_name }"
    str      = "Contract failure #{ @type } `#{ method }`"
    if contract.respond_to?(:get_name)
      str += " - Name: `#{ contract.get_name }`"
    end

    if @errors
      errors = @errors
        .map    { |e| e[:detail] }
        .select { |e| e != 'Invalid result type for contract' }
      if errors.size > 0
        str += ": #{ errors }"
      end
    end

    str
  end

end
