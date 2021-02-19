require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::Symbol do

  let(:contract) { described_class }
  let(:args_valid) do
    [
      { args: [:a] },
      { args: [:"1"] },
    ]
  end
  let(:expected_type) { Symbol }
  let(:args_invalid) do
    {
      { args: [nil] } => nil,
      { args: ['a'] } => nil,
      { args: [1] }   => nil,
      { args: ['1'] } => nil,
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
