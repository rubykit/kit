require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

# Namespace for test dummy modules.
module TestModules
end

# Dummy module.
module TestModules::FunctorContainer

  def self.callable_method
    true
  end

end

# Dummy module.
class TestModules::FunctorContainer::Functor

  def call
    true
  end

end

describe Kit::Contract::BuiltInContracts::Callable do

  let(:contract) { described_class }
  let(:args_valid) do
    [
      { args: [->(_v) { true }] },
      { args: [TestModules::FunctorContainer.method(:callable_method)] },
      { args: [TestModules::FunctorContainer::Functor.new] },
    ]
  end
  let(:args_invalid) do
    {
      { args: [nil] } => 'RESPOND_TO failed: object does not respond_to `call`',
      { args: [3] }   => 'RESPOND_TO failed: object does not respond_to `call`',
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
