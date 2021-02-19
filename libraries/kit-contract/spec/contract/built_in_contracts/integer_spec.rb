require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::Integer do

  let(:contract) { described_class }
  let(:args_valid) do
    [
      { args: [1] },
      { args: [9_000_000_000_000_000_000_000_000_000] },
    ]
  end
  let(:expected_type) { Integer }
  let(:args_invalid) do
    {
      { args: [nil] }                   => nil,
      { args: [1.0] }                   => nil,
      { args: [::Kernel::Rational(1)] } => nil,
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
