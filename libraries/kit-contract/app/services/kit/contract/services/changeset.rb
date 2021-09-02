# Basic implementation of changeset.
module Kit::Contract::Services::Changeset

  # Performs contracts validation for a list of attributes on `model` (including possible casts).
  # For each attribute, it stops on first error.
  # The order of the validations matters.
  #
  # Validations is a list of either:
  #    - callable
  #    - tupple with [callable, :name_of_expected_kwargs]
  def self.validate(validations:, model:)
    validated_model = model.deep_dup

    status_overall = :ok
    errors = []

    validations.each do |attr_name, attr_validations|
      attr_validations.each do |contract, contract_attr_name|
        contract_attr_name ||= :value
        #contract_attr_name  = vd[1]
        #contract            = vd[0]
        contract_wrapper    = ->(value:) do
          contract.call(**{
            contract_attr_name => value,
            :model             => model,
            :validated_model   => validated_model,
            :attr_name         => contract_attr_name,
          })
        end
        contract_parameters = {
          kwargs: { value: validated_model[attr_name], model: model },
        }

        local_status, local_ctx = Kit::Contract::Services::Validation.valid?(
          contract:   contract_wrapper,
          parameters: contract_parameters,
        )

        if local_status == :error
          status_overall = :error
          (local_ctx[:errors] || []).each { |error| errors << error.merge(attribute: attr_name) }
          break
        elsif (new_value = local_ctx&.dig(:value)) != nil
          validated_model.merge!({ attr_name => new_value })
        end
      end
    end

    if status_overall == :ok
      [:ok,    validated_model: validated_model]
    else
      [:error, errors: errors]
    end
  end

end
