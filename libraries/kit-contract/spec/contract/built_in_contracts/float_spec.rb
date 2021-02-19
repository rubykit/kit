require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::Float do

  let(:contract) { described_class }
  let(:args_valid) do
    [
      { args: [0.0] },
      { args: [1.0] },
      { args: [Float::MAX] },
      { args: [Float::MIN] },
      { args: [Float::INFINITY] },
      { args: [Float::EPSILON] },
    ]
  end
  let(:expected_type) { Float }
  let(:args_invalid) do
    {
      { args: [nil] } => nil,
      { args: [1] }   => nil,
      { args: ['1'] } => nil,
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
