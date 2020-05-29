require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::IsA do

  let(:contract) { described_class[::String] }
  let(:args_valid) do
    [
      ['a'],
    ]
  end
  let(:expected_type) { String }
  let(:args_invalid) do
    {
      [nil]        => nil,
      [1]          => nil,
      [{ c: :ok }] => nil,
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
