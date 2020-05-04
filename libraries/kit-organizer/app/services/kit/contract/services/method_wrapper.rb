module Kit::Contract::Services::MethodWrapper

  METHOD_PREFIX = "_orig_"

  def self.wrap(method_name:, method_type:, class_self:, contracts_before:, contracts_after:)
    aliased_name = "#{METHOD_PREFIX}#{method_name}"

    return if contracts_before.size == 0 && contracts_after.size == 0
    return if !Kit::Contract::Services::Runtime.is_active?
    return if method_name.to_s.start_with?(METHOD_PREFIX)
    return if class_self.respond_to?(aliased_name)

    # Note: we have to add this indirection as we can not use closures from evaled code.
    _, ctx = Kit::Contract::Services::Store.add_and_generate_key(value: contracts_before)
    store_contracts_before_uid = ctx[:key]
    _, ctx = Kit::Contract::Services::Store.add_and_generate_key(value: contracts_after)
    store_contracts_after_uid  = ctx[:key]

    if method_type == :singleton_method
      extension_target = (class << class_self; self; end)
    else
      extension_target = class_self
    end

    create_alias(
      extension_target: extension_target,
      method_name:      method_name,
      aliased_name:     aliased_name,
    )

    create_method_wrapper(
      extension_target:     extension_target,
      target_class:         class_self,
      method_name:          method_name,
      method_type:          method_type,
      aliased_name:         aliased_name,
      contracts_before_uid: store_contracts_before_uid,
      contracts_after_uid:  store_contracts_after_uid,
    )
  end

  # Rename the method so that we can replace it by a wrapped version that will be able to enforce contracts
  def self.create_alias(extension_target:, method_name:, aliased_name:)
    extension_target.module_eval do
      alias_method aliased_name, method_name
    end
  end

  # Replaces the initial method by a wrapped version that will run contracts before & after the original method.
  # @note We are forced to avoid splat as it makes it impossible to perform any introspection on the parameters of the method. This leads to this akward parameter forwarding.
  def self.create_method_wrapper(extension_target:, target_class:, method_name:, method_type:, aliased_name:, contracts_before_uid:, contracts_after_uid:)
    class_name    = target_class.name
    parameters    = target_class.method(aliased_name).parameters
    signature_str = Kit::Contract::Services::RubyHelpers.parameters_as_signature_to_s(parameters: parameters)
    args_str      = Kit::Contract::Services::RubyHelpers.parameters_as_array_to_s(parameters: parameters)

    extension_target.module_eval <<-METHOD, __FILE__, __LINE__ + 1
      def #{method_name}(#{signature_str})
        ::Kit::Contract::Services::Runtime.instrument(
          method_name:          "#{method_name}",
          aliased_name:         "#{aliased_name}",
          method_type:          :#{method_type},
          contracts_before_uid: #{contracts_before_uid},
          contracts_after_uid:  #{contracts_after_uid},
          target:               self,
          target_class:         #{(method_type == :singleton_method) ? 'self' : 'self.class'},
          args:                 #{args_str},
        )
      end
    METHOD
  end

end