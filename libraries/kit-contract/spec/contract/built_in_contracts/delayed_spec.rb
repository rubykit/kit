require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::Delayed do

  Contract1 = Kit::Contract::BuiltInContracts::Hash[ # rubocop:disable Lint/ConstantDefinitionInBlock
    v:    Kit::Contract::BuiltInContracts::Eq[1],
    obj2: Kit::Contract::BuiltInContracts::Optional[described_class[-> { Contract2 }]],
  ]

  Contract2 = Kit::Contract::BuiltInContracts::Hash[ # rubocop:disable Lint/ConstantDefinitionInBlock
    v:    Kit::Contract::BuiltInContracts::Eq[2],
  ]

  let(:contract) { Contract1 }

  let(:args_valid) do
    [
      { args: [{ v: 1, obj2: { v: 2 } }] },
    ]
  end
  let(:args_invalid) do
    {
      { args: [{ v: 2, obj2: { v: 2 } }] } => 'EQ failed: expected `1` got `2`',
      { args: [{ v: 1, obj2: { v: 3 } }] } => 'EQ failed: expected `2` got `3`',
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

=begin
  it 'allows delayed resolution of circular contract definitions' do
    v2 = { v: 2 }
    v1 = { v: 1, obj2: v2, }

    status, ctx = Kit::Contract::Services::Validation.valid?(contract: Contract1, args: [v1])
    binding.pry
  end
=end

end
