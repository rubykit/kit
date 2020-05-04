require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe ::Kit::Contract::BuiltInContracts::And do

  let(:contract) { described_class[
    ->(v) { v && v > 3 },
    ->(v) { v && v < 5 }
  ] }
  let(:args_valid) do
    [
      [4],
    ]
  end
  let(:args_invalid) do
    {
      [nil] => 'AND failed: [[{:detail=>"Invalid result type for contract"}], [{:detail=>"Invalid result type for contract"}]]',
      [3]   => 'AND failed: [[{:detail=>"Invalid result type for contract"}]]',
      [5]   => 'AND failed: [[{:detail=>"Invalid result type for contract"}]]',
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end