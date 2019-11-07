require 'active_support/concern'

module Kit
  module Contract
    extend ::ActiveSupport::Concern

    included do |base|
      self.reset_tmp_contracts
    end

    class_methods do
      def before(arg)
        return if !Kit::Contract::Services::Store.is_active?

        if arg.is_a?(::Array)
          self.tmp_before.concat(arg)
        else
          self.tmp_before << arg
        end

        true
      end

      def after(arg)
        return if !Kit::Contract::Services::Store.is_active?

        if arg.is_a?(::Array)
          self.tmp_after.concat(arg)
        else
          self.tmp_after << arg
        end

        true
      end

      def contract(arg)
        return if !Kit::Contract::Services::Store.is_active?

        if !arg.is_a?(::Hash) || arg.size != 1
          raise "Invalid use"
        end

        data = arg.first

        before(data[0])
        after(data[1])

        true
      end

      def contracts(args)
        return if !Kit::Contract::Services::Store.is_active?

        if args[:before]
          before(args[:before])
        end
        if args[:after]
          after(args[:after])
        end

        true
      end

      protected

      attr_accessor :tmp_before
      attr_accessor :tmp_after

      def singleton_method_added(method_name)
        return if self.tmp_before.size == 0 && self.tmp_after.size == 0
        return if !Kit::Contract::Services::Store.is_active?
        return if method_name.to_s.start_with?(prefix)
        return if self.respond_to?("#{prefix}#{method_name}")

        method_type = :singleton

        save_contracts(target_class_name: self.name, method_name: method_name, method_type: method_type)

        aliased_name = "#{prefix}#{method_name}"

        singleton_method_alias(method_name: method_name, aliased_name: aliased_name, target_class: self)
        singleton_method_redefine(method_name: method_name, aliased_name: aliased_name, target_class: self)
      end

      def method_added(method_name)
        return if self.tmp_before.size == 0 && self.tmp_after.size == 0
        return if !Kit::Contract::Services::Store.is_active?
        return if method_name.to_s.start_with?(prefix)
        return if self.method_defined?("#{prefix}#{method_name}")

        method_type = :method

        save_contracts(target_class_name: self.name, method_name: method_name, method_type: method_type)

        aliased_name = "#{prefix}#{method_name}"

        method_alias(method_name: method_name, aliased_name: aliased_name, target_class: self)
        method_redefine(method_name: method_name, aliased_name: aliased_name, target_class: self)
      end

      def prefix
        "_orig_"
      end

      def save_contracts(target_class_name:, method_name:, method_type:)
        Kit::Contract::Services::Store.add(
          class_name:  target_class_name,
          method_name: method_name,
          method_type: method_type,
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

      def singleton_method_alias(method_name:, aliased_name:, target_class:)
        (class << target_class; self; end).module_eval do
          alias_method aliased_name, method_name
        end
      end

      def singleton_method_redefine(method_name:, aliased_name:, target_class:)
        class_name    = target_class.name
        parameters    = target_class.method(aliased_name).parameters

        signature_str = signature_as_string(parameters: parameters)
        args_str      = parameters_to_arguments_as_string(parameters: parameters)

        (class << target_class; self; end).module_eval <<-METHOD, __FILE__, __LINE__ + 1
          def #{method_name}(#{signature_str})
            ::Kit::Contract::Services::Runtime.instrument(
              method_name:  "#{method_name}",
              aliased_name: "#{aliased_name}",
              method_type:  :singleton,
              target:       #{class_name},
              target_class: #{class_name},
              args:         #{args_str},
            )
          end
        METHOD
      end

      def method_alias(method_name:, aliased_name:, target_class:)
        target_class.alias_method aliased_name, method_name
      end

      def method_redefine(method_name:, aliased_name:, target_class:)
        class_name    = target_class.name
        parameters    = target_class.instance_method(aliased_name).parameters

        signature_str = signature_as_string(parameters: parameters)
        args_str      = parameters_to_arguments_as_strint(parameters: parameters)

        target_class.module_eval <<-METHOD, __FILE__, __LINE__ + 1
          def #{method_name}(#{signature_str})
            ::Kit::Contract::Services::Runtime.instrument(
              method_name:  "#{method_name}",
              aliased_name: "#{aliased_name}",
              method_type:  :method,
              target:       self,
              target_class: #{class_name},
              args:         #{args_str},
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

      def parameters_to_arguments_as_string(parameters:)
        block_name   = (parameters.last&.first == :block)   ? parameters.pop.first : nil
        keyrest_name = (parameters.last&.first == :keyrest) ? parameters.pop.first : nil

        named_str = nil
        keys_str  = nil

        named = parameters
          .select { |t, n| t == :req || t == :rest || t == :opt }
          .map    { |t, n| "#{n}" }

        if named.count > 0
          named_str = named.join(', ')
        end

        keys = parameters
          .select { |t, n| t == :key || t == :keyreq }
          .map    { |t, n| "#{n}: #{n}" }

        if keys.count > 0
          keys_str = "{ #{keys.join(', ')} }"
        end

        if keyrest_name
          if keys_str
            keys_str = "#{keys_str}.merge(#{keyrest_name})"
          else
            keys_str = keyrest_name
          end
        end

        "[#{ named_str ? "#{named_str}, " : '' }#{ keys_str ? "#{keys_str}, " : '' }#{ block_name }]"
      end

    end

  end
end

require 'kit/contract/engine'
