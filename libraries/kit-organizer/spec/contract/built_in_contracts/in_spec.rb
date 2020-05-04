require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::In do

  let(:contract) { described_class[1, '1', described_class[2, '2']] }
  let(:args_valid) do
    [
      [1],
      ['1'],
      [2],
      ['2'],
    ]
  end
  let(:args_invalid) do
    {
      [nil]         => 'IN failed: `` is not in `[1, "1", In[2, "2"]]`',
      [4]           => 'IN failed: `4` is not in `[1, "1", In[2, "2"]]`',
      [{ c: :ok, }] => 'IN failed: `{:c=>:ok}` is not in `[1, "1", In[2, "2"]]`',
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end