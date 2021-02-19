require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::Any do

  let(:contract) { described_class }
  let(:args_valid) do
    [
      { args: [nil] },
      { args: [4] },
      { args: [[2]] },
      { args: [{ b: 2 }] },
      { args: [1..2] },
      { args: ['test'] },
      { args: [Object.new()] },
    ]
  end

  it_behaves_like 'a contract that succeeds on valid values'

end
