require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::Numeric do

  let(:contract) { described_class }
  let(:args_valid) do
    [
      { args: [1] },
      { args: [1.0] },
      { args: [::Kernel::Integer(1)] },
      { args: [::Kernel::Float(1)] },
      { args: [::Kernel::Rational(1)] },
      { args: [::Kernel::Complex(1)] },
      { args: [BigDecimal(1)] },
    ]
  end
  let(:expected_type) { Numeric }
  let(:args_invalid) do
    {
      { args: [nil] } => nil,
      { args: ['1'] } => nil,
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
