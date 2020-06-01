require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::TrueClass do

  let(:contract) { described_class }
  let(:args_valid) do
    [
      [true],
    ]
  end
  let(:expected_type) { TrueClass }
  let(:args_invalid) do
    {
      [false] => nil,
      [nil]   => nil,
      [1]     => nil,
      ['1']   => nil,
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
