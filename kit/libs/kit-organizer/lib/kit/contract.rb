require 'active_support/concern'

module Kit
  module Contract
    extend ::ActiveSupport::Concern

    included do |base|
      self.reset_tmp_contracts
    end

    class_methods do
      def before(arg)
        if arg.is_a?(Array)
          self.tmp_before = self.tmp_before + arg
        else
          self.tmp_before << arg
        end
      end

      def after(arg)
        if arg.is_a?(Array)
          self.tmp_after = self.tmp_after + arg
        else
          self.tmp_after << arg
        end
      end

      def contract(args)
        if args[:before]
          before(args[:before])
        end
        if args[:after]
          after(args[:after])
        end
      end

      protected

      attr_accessor :tmp_before
      attr_accessor :tmp_after

      def singleton_method_added(method_name)
        return if method_name.to_s.start_with?(prefix)
        return if self.respond_to?("#{prefix}#{method_name}")

        validate_signature!(target_class: self, method_name: method_name)

        save_contracts(target_class: self, method_name: method_name)

        aliased_name = "#{prefix}#{method_name}"

        method_alias(method_name: method_name, aliased_name: aliased_name, target_class: self)
        method_redefine(method_name: method_name, aliased_name: aliased_name, target_class: self)
      end

      def prefix
        "_orig_"
      end

      def validate_signature!(target_class:, method_name:)
        callable         = target_class.method(method_name)
        #accepted_types   = [:key, :keyreq, :keyrest, :block]
        accepted_types   = [:key, :keyreq, :keyrest]

        parameters_types = callable.parameters.map { |type, name| type }

        types_diff = parameters_types - accepted_types
        if types_diff.size > 0
          raise "Kit::Contracts | Unsupported parameters types for `#{target_class.name}.#{method_name}`: `#{types_diff}` "
        end
      end

      def save_contracts(target_class:, method_name:)
        Kit::Contracts::Services::Store.add(
          class_name:  target_class.name,
          method_name: method_name,
          contracts: {
            before: self.tmp_before,
            after:  self.tmp_after,
          },
        )

        reset_tmp_contracts
      end

      def reset_tmp_contracts
        self.tmp_before = []
        self.tmp_after  = []
      end

      def method_alias(method_name:, aliased_name:, target_class:)
        (class << target_class; self; end).module_eval do
          alias_method aliased_name, method_name
        end
      end

      def method_redefine(method_name:, aliased_name:, target_class:)
        class_name    = target_class.name
        parameters    = target_class.method(aliased_name).parameters

        signature_str = signature_as_string(parameters: parameters)

        kargs_str     = parameters.select { |t, n| t == :key || t == :keyreq }.map { |t, n| "#{n}: #{n}" }.join(',')
        #keyrest       = parameters.select { |type, name| type == :keyrest }.try(:[], 1)
        keyrest_str   = 'nil'.to_s

        (class << target_class; self; end).module_eval <<-METHOD, __FILE__, __LINE__ + 1
          def #{method_name}(#{signature_str})
            Kit::Contracts::Services::Call.instrument(
              method_name:  "#{method_name}",
              aliased_name: "#{aliased_name}",
              target_class: #{class_name},
              args: {
                kargs:      {#{kargs_str}},
                keyrest:    #{keyrest_str},
              },
            )
          end
        METHOD
      end

      def signature_as_string(parameters:)
        parameters
          .map do |type, name|
            case type
            when :req
              name
            when :rest
              "*#{name}"
            when :opt
              # Unknown default argument.
              "#{name} = nil"
            when :key
              # Unknown default argument.
              "#{name}: nil"
            when :keyreq
              "#{name}:"
            when :keyrest
              "**#{name}"
            when :block
              "&#{name}"
            end
          end
          .join(', ')
      end

    end

  end
end

require 'kit/contract/engine'
